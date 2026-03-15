import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class AdvancedHashService {
  AdvancedHashService._();

  /// Generate RIPEMD-160 hash
  static String ripemd160(String input) {
    final digest = RIPEMD160Digest();
    final bytes = utf8.encode(input);
    final result = digest.process(bytes);
    return _bytesToHex(result);
  }

  /// Generate Keccak-256 hash (SHA3-256)
  static String keccak256(String input) {
    final digest = KeccakDigest(256);
    final bytes = utf8.encode(input);
    final result = digest.process(bytes);
    return _bytesToHex(result);
  }

  /// Generate Adler-32 checksum
  static String adler32(String input) {
    // Simple Adler-32 implementation
    var a = 1;
    var b = 0;
    final bytes = utf8.encode(input);
    for (final byte in bytes) {
      a = (a + byte) % 65521;
      b = (b + a) % 65521;
    }
    return ((b << 16) | a).toRadixString(16).padLeft(8, '0');
  }

  /// HKDF key derivation (RFC 5869) - Using PBKDF2 as practical alternative
  static Uint8List hkdf({
    required String algorithm,
    required String password,
    required Uint8List salt,
    required int outputLength,
    Uint8List? info, // Optional, not used in PBKDF2
  }) {
    // Use PBKDF2 which is more commonly available in pointycastle
    final mac = algorithm.toUpperCase() == 'HMAC-SHA256'
        ? HMac(SHA256Digest(), 64)
        : HMac(SHA512Digest(), 128);

    final pbkdf2 = PBKDF2KeyDerivator(mac);
    pbkdf2.init(Pbkdf2Parameters(salt, 10000, outputLength));

    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }

  /// Generate random salt
  static Uint8List generateSalt(int length) {
    final secureRandom = SecureRandom('Fortuna');
    secureRandom.seed(KeyParameter(
      Uint8List.fromList(List.generate(32, (_) => DateTime.now().millisecond)),
    ));

    final salt = Uint8List(length);
    for (var i = 0; i < length; i++) {
      salt[i] = secureRandom.nextUint8();
    }
    return salt;
  }

  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
