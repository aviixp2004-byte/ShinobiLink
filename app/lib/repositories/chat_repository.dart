import 'dart:async';

import '../core/chat/chat_engine.dart';
import '../core/network/network_manager.dart';
import '../core/network/packet_type.dart';
import '../models/message_model.dart';
import '../models/packet_model.dart';
import '../features/chat/services/chat_storage_service.dart';

class ChatRepository {
  ChatRepository({
    required this.networkManager,
    required this.chatEngine,
  });

  final NetworkManager networkManager;
  final ChatEngine chatEngine;

  final ChatStorageService _storage = ChatStorageService();

  final List<MessageModel> _messages = [];

  final Set<String> _processedAcks = {};

  DateTime? _lastPacketAt;
  Timer? _heartbeatTimer;
  bool _connectionHealthy = true;

  bool _peerTyping = false;
  Timer? _typingTimeout;

  final StreamController<List<MessageModel>> _messagesController =
      StreamController<List<MessageModel>>.broadcast();

  StreamSubscription? _subscription;

  List<MessageModel> get messages => List.unmodifiable(_messages);

  Stream<List<MessageModel>> get messagesStream =>
      _messagesController.stream;

  DateTime? get lastPacketAt => _lastPacketAt;

  bool get connectionHealthy => _connectionHealthy;

  bool get peerTyping => _peerTyping;




  bool get isConnectionStale {
    if (_lastPacketAt == null) return false;

    return DateTime.now().difference(_lastPacketAt!).inSeconds > 30;
  }

  void loadMessages() {
    _messages.clear();
    _messages.addAll(_storage.getMessages());
    _notify();
  }

  void _notify() {
    _messagesController.add(List.unmodifiable(_messages));
  }



  void _setPeerTyping() {
    _peerTyping = true;
    _typingTimeout?.cancel();

    _typingTimeout = Timer(
      const Duration(seconds: 2),
      () {
        _peerTyping = false;
      },
    );

    _notify();
  }

  Future<void> startListening() async {
    await _subscription?.cancel();

    _startHeartbeat();

    _subscription = networkManager.receive().listen((packet) async {
      await _handlePacket(packet);
    });
  }



  Future<void> _handlePacket(PacketModel packet) async {
    _lastPacketAt = DateTime.now();

    if (packet.type == PacketType.ping) {
      final pong = chatEngine.createPong(packet);
      await networkManager.send(pong);
      return;
    }

    if (packet.type == PacketType.pong) {
      return;
    }

    if (packet.type == PacketType.typing) {
      _setPeerTyping();
      return;
    }

    if (packet.type == PacketType.read) {
      _handleRead(packet);
      return;
    }

    if (packet.isAck) {
      _handleAck(packet);
      return;
    }

    await _handleIncomingMessage(packet);
  }

  Future<void> _handleIncomingMessage(PacketModel packet) async {
    final message = chatEngine.packetToMessage(packet);
    _messages.add(message);
    await _storage.saveMessage(message);
    _notify();

    final readAck = chatEngine.createReadAck(packet);
    await networkManager.send(readAck);

    final ack = chatEngine.createAck(packet);
    await networkManager.send(ack);
  }


  void _handleRead(PacketModel packet) {
    if (packet.replyTo == null) return;

    final index = _messages.indexWhere(
      (m) => m.id == packet.replyTo,
    );

    if (index == -1) return;

    final message = _messages[index];

    _messages[index] = MessageModel(
      id: message.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      text: message.text,
      timestamp: message.timestamp,
      status: MessageStatus.read,
    );

    _storage.saveMessage(_messages[index]);
    _notify();
  }

  void _handleAck(PacketModel packet) {
    if (packet.replyTo == null) return;

    if (!_processedAcks.add(packet.id)) {
      return;
    }

    final index = _messages.indexWhere(
      (m) => m.id == packet.replyTo,
    );

    if (index == -1) {
      return;
    }

    final message = _messages[index];

    _messages[index] = MessageModel(
      id: message.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      text: message.text,
      timestamp: message.timestamp,
      status: MessageStatus.delivered,
    );

    _storage.saveMessage(_messages[index]);
    _notify();
  }



  void _startHeartbeat() {
    _heartbeatTimer?.cancel();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) async {
        final previous = _connectionHealthy;
        _connectionHealthy = !isConnectionStale;

        if (previous != _connectionHealthy) {
          _notify();
        }

        if (!_connectionHealthy) {
          return;
        }

        await _retryPendingMessages();

        // TODO: Replace with actual peer IDs from ConnectionManager.
        final ping = chatEngine.createPing(
          from: "me",
          to: "peer",
        );

        await networkManager.send(ping);
      },
    );
  }

  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
  }



  Future<void> sendTyping({
    required String from,
    required String to,
  }) async {
    final packet = chatEngine.createTyping(
      from: from,
      to: to,
    );

    await networkManager.send(packet);
  }

  Future<void> send(MessageModel message) async {
    _messages.add(message);
    await _storage.saveMessage(message);
    _notify();

    final packet = chatEngine.messageToPacket(message);

    await networkManager.send(packet);

    final index = _messages.indexWhere((m) => m.id == message.id);

    if (index != -1) {
      _messages[index] = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        text: message.text,
        timestamp: message.timestamp,
        status: MessageStatus.sent,
      );

      await _storage.saveMessage(_messages[index]);
      _notify();
    }
  }

  void receive(MessageModel message) {
    _messages.add(message);
    _storage.saveMessage(message);
    _notify();
  }





  Future<void> _retryPendingMessages() async {
    final pending = await pendingMessages();

    for (final message in pending) {
      await send(message);
    }
  }

  Future<List<MessageModel>> pendingMessages() async {
    return _messages
        .where((m) => m.status == MessageStatus.sending)
        .toList();
  }



  Future<void> deleteMessage(String id) async {
    _messages.removeWhere((m) => m.id == id);

    await _storage.deleteMessage(id);

    _notify();
  }

  void clear() {
    _messages.clear();
    _notify();
  }

  Future<void> dispose() async {
    _heartbeatTimer?.cancel();
    _typingTimeout?.cancel();
    await stopListening();
    await _messagesController.close();
  }
}
