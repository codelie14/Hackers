// Bcrypt implementation - requires bcrypt package
// For MVP, use PBKDF2 as alternative (already implemented)
// To enable bcrypt: add `bcrypt: ^0.0.4` to pubspec.yaml

class BcryptService {
  BcryptService._();

  /// Generate bcrypt hash with configurable cost factor (4-31)
  /// NOTE: Requires bcrypt package - currently using placeholder
  static String generateHash(String password, {int cost = 12}) {
    // Placeholder - in production use actual bcrypt package
    // return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: cost));
    throw UnimplementedError(
        'Bcrypt package not installed. Use PBKDF2 instead.');
  }

  /// Verify bcrypt hash
  /// NOTE: Requires bcrypt package - currently using placeholder
  static bool verifyHash(String password, String hash) {
    // Placeholder - in production use actual bcrypt package
    // return BCrypt.checkpw(password, hash);
    throw UnimplementedError(
        'Bcrypt package not installed. Use PBKDF2 instead.');
  }
}
