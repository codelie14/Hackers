import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashService {
  HashService._();

  static Map<String, String> hashAll(String input) {
    final bytes = utf8.encode(input);
    return {
      'MD5': md5.convert(bytes).toString(),
      'SHA1': sha1.convert(bytes).toString(),
      'SHA224': sha224.convert(bytes).toString(),
      'SHA256': sha256.convert(bytes).toString(),
      'SHA384': sha384.convert(bytes).toString(),
      'SHA512': sha512.convert(bytes).toString(),
    };
  }

  static String hash(String algorithm, String input) {
    final bytes = utf8.encode(input);
    switch (algorithm.toLowerCase()) {
      case 'md5': return md5.convert(bytes).toString();
      case 'sha1': return sha1.convert(bytes).toString();
      case 'sha224': return sha224.convert(bytes).toString();
      case 'sha256': return sha256.convert(bytes).toString();
      case 'sha384': return sha384.convert(bytes).toString();
      case 'sha512': return sha512.convert(bytes).toString();
      default: throw ArgumentError('Unknown algorithm: $algorithm');
    }
  }

  static String hmac(String algorithm, String key, String message) {
    final keyBytes = utf8.encode(key);
    final msgBytes = utf8.encode(message);
    Hmac hmacInstance;
    switch (algorithm.toUpperCase()) {
      case 'HMAC-SHA256': hmacInstance = Hmac(sha256, keyBytes); break;
      case 'HMAC-SHA512': hmacInstance = Hmac(sha512, keyBytes); break;
      case 'HMAC-SHA1': hmacInstance = Hmac(sha1, keyBytes); break;
      case 'HMAC-SHA384': hmacInstance = Hmac(sha384, keyBytes); break;
      default: hmacInstance = Hmac(sha256, keyBytes);
    }
    return hmacInstance.convert(msgBytes).toString();
  }

  static bool compareHashes(String a, String b) {
    if (a.length != b.length) return false;
    // Constant-time comparison
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
