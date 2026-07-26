import '../../models/message_model.dart';
import '../../models/packet_model.dart';
import '../network/packet_type.dart';

class ChatEngine {
  PacketModel messageToPacket(MessageModel message) {
    return PacketModel(
      id: message.id,
      from: message.senderId,
      to: message.receiverId,
      type: PacketType.message,
      payload: message.text,
      ttl: 5,
      timestamp: message.timestamp,
    );
  }

  MessageModel packetToMessage(PacketModel packet) {
    return MessageModel(
      id: packet.id,
      senderId: packet.from,
      receiverId: packet.to,
      text: packet.payload,
      timestamp: packet.timestamp,
      status: MessageStatus.delivered,
    );
  }

  PacketModel createAck(PacketModel packet) {
    return PacketModel(
      id: '${packet.id}_ack',
      from: packet.to,
      to: packet.from,
      type: PacketType.ack,
      payload: '',
      ttl: 5,
      timestamp: DateTime.now(),
      replyTo: packet.id,
    );
  }


  PacketModel createPing({
    required String from,
    required String to,
  }) {
    return PacketModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      from: from,
      to: to,
      type: PacketType.ping,
      payload: '',
      ttl: 1,
      timestamp: DateTime.now(),
    );
  }



  PacketModel createTyping({
    required String from,
    required String to,
  }) {
    return PacketModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      from: from,
      to: to,
      type: PacketType.typing,
      payload: '',
      ttl: 1,
      timestamp: DateTime.now(),
    );
  }



  PacketModel createDisconnect({
    required String from,
    required String to,
  }) {
    return PacketModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      from: from,
      to: to,
      type: PacketType.disconnect,
      payload: '',
      ttl: 1,
      timestamp: DateTime.now(),
    );
  }

  PacketModel createPong(PacketModel ping) {
    return PacketModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      from: ping.to,
      to: ping.from,
      type: PacketType.pong,
      payload: '',
      ttl: 1,
      timestamp: DateTime.now(),
      replyTo: ping.id,
    );
  }

}
