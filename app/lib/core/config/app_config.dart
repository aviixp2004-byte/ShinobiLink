class AppConfig {
  AppConfig._();

  static const String appName = 'Shinobi-Link';
  static const String packageName = 'com.aviixp.shinobilink';

  static const String protocolVersion = '1.0.0';

  static const bool enableLogging = true;
  static const bool enableDiagnostics = true;

  static const Duration discoveryInterval = Duration(seconds: 5);
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration handshakeTimeout = Duration(seconds: 10);
  static const Duration heartbeatInterval = Duration(seconds: 20);
  static const Duration retryInterval = Duration(seconds: 3);

  static const int maxRetryAttempts = 5;
  static const int maxPacketSize = 65536;

  // Automatic reconnection
  static const Duration initialReconnectDelay = Duration(seconds: 2);
  static const Duration maxReconnectDelay = Duration(seconds: 32);
  static const int maxReconnectAttempts = 5;

  static const int defaultPort = 40404;
}
