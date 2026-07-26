abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ConnectionException extends AppException {
  const ConnectionException(super.message);
}

class BluetoothException extends AppException {
  const BluetoothException(super.message);
}

class WifiDirectException extends AppException {
  const WifiDirectException(super.message);
}

class HandshakeException extends AppException {
  const HandshakeException(super.message);
}

class SecurityException extends AppException {
  const SecurityException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class ConfigurationException extends AppException {
  const ConfigurationException(super.message);
}
