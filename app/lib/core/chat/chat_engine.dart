import '../../models/message_model.dart';
import '../../models/packet_model.dart';

class ChatEngine {
  PacketModel messageToPacket(MessageModel message) {
    return PacketModel(
      id: message.id,
      from: message.senderId,
      to: message.receiverId,
      type: 'text',
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
      delivered: true,
    );
  }
}
