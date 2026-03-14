import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class ChaCha20Service {
  ChaCha20Service._();

  /// Encrypt data using ChaCha20-Poly1305 AEAD cipher
  static Future<Map<String, String>> encrypt(String plaintext, String keyHex, {String? nonceHex}) async {
    try {
      final algorithm = Chacha20.poly1305();
      
      // Convert key from hex to bytes
      final keyBytes = _hexToBytes(keyHex);
      
      // Generate or use provided nonce (12 bytes for ChaCha20)
      Uint8List nonce;
      if (nonceHex != null && nonceHex.isNotEmpty) {
        nonce = _hexToBytes(nonceHex);
        if (nonce.length != 12) {
          throw ArgumentError('Nonce must be exactly 12 bytes (24 hex characters)');
        }
      } else {
        // Generate random nonce
        nonce = Uint8List.fromList(List.generate(12, (_) => DateTime.now().microsecondsSinceEpoch % 256));
      }
      
      final secretKey = SecretKey(keyBytes);
      
      final result = await algorithm.encrypt(
        utf8.encode(plaintext),
        secretKey: secretKey,
        nonce: nonce,
      );
      
      return {
        'ciphertext': bytesToHex(result.cipherText),
        'nonce': bytesToHex(nonce),
        'mac': bytesToHex(result.mac.bytes),
        'success': 'true',
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'success': 'false',
      };
    }
  }

  /// Decrypt data using ChaCha20-Poly1305 AEAD cipher
  static Future<Map<String, String>> decrypt(String ciphertextHex, String keyHex, String nonceHex, String macHex) async {
    try {
      final algorithm = Chacha20.poly1305();
      
      final keyBytes = _hexToBytes(keyHex);
      final nonce = _hexToBytes(nonceHex);
      final ciphertext = _hexToBytes(ciphertextHex);
      final mac = MacAlgorithm(_hexToBytes(macHex));
      
      if (nonce.length != 12) {
        throw ArgumentError('Nonce must be exactly 12 bytes (24 hex characters)');
      }
      
      final secretKey = SecretKey(keyBytes);
      
      final result = await algorithm.decrypt(
        ciphertext,
        secretKey: secretKey,
        nonce: nonce,
        mac: mac,
      );
      
      return {
        'plaintext': utf8.decode(result),
        'success': 'true',
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'success': 'false',
      };
    }
  }

  /// Generate a random 256-bit key for ChaCha20
  static String generateKey() {
    final random = List.generate(32, (_) => DateTime.now().microsecondsSinceEpoch % 256);
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
