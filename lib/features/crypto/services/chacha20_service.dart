import 'dart:convert';
import 'dart:typed_data';

// ChaCha20-Poly1305 implementation - requires cryptography package
// For MVP, use AES as alternative (already implemented)
// To enable ChaCha20: add `cryptography: ^0.6.1` to pubspec.yaml

class ChaCha20Service {
  ChaCha20Service._();

  /// Encrypt data using ChaCha20-Poly1305 AEAD cipher
  /// NOTE: Requires cryptography package - currently using placeholder
  static Future<Map<String, String>> encrypt(String plaintext, String keyHex,
      {String? nonceHex}) async {
    // Placeholder - in production use actual cryptography package
    throw UnimplementedError(
        'ChaCha20 package not installed. Use AES encryption instead.');
  }

  /// Decrypt data using ChaCha20-Poly1305 AEAD cipher
  /// NOTE: Requires cryptography package - currently using placeholder
  static Future<Map<String, String>> decrypt(String ciphertextHex,
      String keyHex, String nonceHex, String macHex) async {
    // Placeholder - in production use actual cryptography package
    throw UnimplementedError(
        'ChaCha20 package not installed. Use AES encryption instead.');
  }

  /// Generate a random 256-bit key for ChaCha20
  static String generateKey() {
    final random =
        List.generate(32, (_) => DateTime.now().microsecondsSinceEpoch % 256);
    return bytesToHex(Uint8List.fromList(random));
  }

  static String bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List _hexToBytes(String hex) {
    if (hex.length.isOdd) {
      hex = '0$hex';
    }
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
