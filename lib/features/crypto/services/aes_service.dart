import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart';

class AesService {
  AesService._();

  static const int _ivLength = 16;
  static const int _gcmTagLength = 128;

  static Uint8List _deriveKey(String password, Uint8List salt, int keySize) {
    final keyBytes = utf8.encode(password);
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, 10000, keySize));
    return pbkdf2.process(Uint8List.fromList(keyBytes));
  }

  static Uint8List _randomBytes(int length) {
    final rng = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => rng.nextInt(256)));
  }

  static String encryptCBC(String plaintext, String password) {
    try {
      final salt = _randomBytes(16);
      final iv = _randomBytes(_ivLength);
      final key = _deriveKey(password, salt, 32);

      final cipher = CBCBlockCipher(AESEngine());
      final params = ParametersWithIV(KeyParameter(key), iv);
      final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
      paddedCipher.init(true, PaddedBlockCipherParameters(params, null));

      final input = utf8.encode(plaintext);
      final output = paddedCipher.process(Uint8List.fromList(input));

      // Result: base64(salt + iv + ciphertext)
      final combined = Uint8List(salt.length + iv.length + output.length);
      combined.setRange(0, salt.length, salt);
      combined.setRange(salt.length, salt.length + iv.length, iv);
      combined.setRange(salt.length + iv.length, combined.length, output);

      return base64.encode(combined);
    } catch (e) {
      throw Exception('AES-CBC encryption failed: $e');
    }
  }

  static String decryptCBC(String encryptedBase64, String password) {
    try {
      final combined = base64.decode(encryptedBase64);
      final salt = combined.sublist(0, 16);
      final iv = combined.sublist(16, 32);
      final ciphertext = combined.sublist(32);

      final key = _deriveKey(password, salt, 32);

      final cipher = CBCBlockCipher(AESEngine());
      final params = ParametersWithIV(KeyParameter(key), iv);
      final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
      paddedCipher.init(false, PaddedBlockCipherParameters(params, null));

      final output = paddedCipher.process(ciphertext);
      return utf8.decode(output);
    } catch (e) {
      throw Exception('AES-CBC decryption failed: $e');
    }
  }

  static String encryptGCM(String plaintext, String password) {
    try {
      final salt = _randomBytes(16);
      final iv = _randomBytes(12); // GCM uses 12-byte nonce
      final key = _deriveKey(password, salt, 32);

      final cipher = GCMBlockCipher(AESEngine());
      final params = AEADParameters(
        KeyParameter(key),
        _gcmTagLength,
        iv,
        Uint8List(0),
      );
      cipher.init(true, params);

      final input = utf8.encode(plaintext);
      final output = cipher.process(Uint8List.fromList(input));

      final combined = Uint8List(salt.length + iv.length + output.length);
      combined.setRange(0, salt.length, salt);
      combined.setRange(salt.length, salt.length + iv.length, iv);
      combined.setRange(salt.length + iv.length, combined.length, output);

      return base64.encode(combined);
    } catch (e) {
      throw Exception('AES-GCM encryption failed: $e');
    }
  }

  static String decryptGCM(String encryptedBase64, String password) {
    try {
      final combined = base64.decode(encryptedBase64);
      final salt = combined.sublist(0, 16);
      final iv = combined.sublist(16, 28);
      final ciphertext = combined.sublist(28);

      final key = _deriveKey(password, salt, 32);

      final cipher = GCMBlockCipher(AESEngine());
      final params = AEADParameters(
        KeyParameter(key),
        _gcmTagLength,
        iv,
        Uint8List(0),
      );
      cipher.init(false, params);

      final output = cipher.process(ciphertext);
      return utf8.decode(output);
    } catch (e) {
      throw Exception('AES-GCM decryption failed: $e');
    }
  }
}
