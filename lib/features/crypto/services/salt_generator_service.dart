import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class SaltGeneratorService {
  SaltGeneratorService._();

  /// Generate cryptographically secure random salt
  static String generateSalt({int length = 32, bool hexOutput = true}) {
    if (length < 8 || length > 256) {
      throw ArgumentError('Salt length must be between 8 and 256 bytes');
    }

    // Use dart:math SecureRandom for cryptographic randomness
    final random = Random.secure();
    final salt = Uint8List(length);
    
    for (var i = 0; i < length; i++) {
      salt[i] = random.nextInt(256);
    }

    return hexOutput ? _bytesToHex(salt) : base64.encode(salt);
  }

  /// Generate salt using SHA256 of timestamp + random (less secure but fast)
  static String quickSalt() {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final random = Random.secure().nextInt(1000000).toString();
    final bytes = utf8.encode('$timestamp$random${DateTime.now().millisecond}');
    return sha256.convert(bytes).toString();
  }

  /// Generate multiple salts at once
  static List<String> generateMultipleSalts({
    int count = 5,
    int length = 32,
    bool hexOutput = true,
  }) {
    return List.generate(count, (_) => generateSalt(length: length, hexOutput: hexOutput));
  }

  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
