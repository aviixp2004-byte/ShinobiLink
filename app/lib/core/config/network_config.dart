class NetworkConfig {
  NetworkConfig._();

  static const String multicastAddress = '239.255.255.250';

  static const int discoveryPort = 40404;
  static const int transferPort = 40405;

  static const int maxPeers = 100;

  static const Duration peerExpiry = Duration(minutes: 2);
}
