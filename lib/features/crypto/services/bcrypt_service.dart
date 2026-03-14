import 'package:bcrypt/bcrypt.dart';

class BcryptService {
  BcryptService._();

  /// Generate bcrypt hash with configurable cost factor (4-31)
  static String generateHash(String password, {int cost = 12}) {
    if (cost < 4 || cost > 31) {
      throw ArgumentError('Cost factor must be between 4 and 31');
    }
    
    return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: cost));
  }

  /// Verify bcrypt hash
  static bool verifyHash(String password, String hash) {
    try {
      return BCrypt.checkpw(password, hash);
    } catch (e) {
      return false;
    }
  }
}
