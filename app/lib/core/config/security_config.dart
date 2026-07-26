class SecurityConfig {
  SecurityConfig._();

  static const int aesKeySize = 256;

  static const bool enableReplayProtection = true;
  static const bool requireAuthenticatedHandshake = true;

  static const Duration sessionLifetime = Duration(hours: 24);
}
