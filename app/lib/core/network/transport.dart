import '../../models/packet_model.dart';
import 'transport_type.dart';

abstract class Transport {
  TransportType get type;

  Future<void> start();

  Future<void> stop();

  Future<void> send(PacketModel packet);

  Stream<PacketModel> receive();
}
