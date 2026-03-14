import 'dart:math';
import 'dart:convert';

class PasswordService {
  PasswordService._();

  static const _upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  static const _digits = '0123456789';
  static const _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  static const _ambiguous = 'Il1O0';

  static String generate({
    required int length,
    bool upperCase = true,
    bool lowerCase = true,
    bool digits = true,
    bool symbols = true,
    bool excludeAmbiguous = false,
    String? customCharset,
  }) {
    String charset = customCharset ?? '';
    if (customCharset == null) {
      if (upperCase) charset += _upperCase;
      if (lowerCase) charset += _lowerCase;
      if (digits) charset += _digits;
      if (symbols) charset += _symbols;
    }

    if (excludeAmbiguous) {
      for (final c in _ambiguous.split('')) {
        charset = charset.replaceAll(c, '');
      }
    }

    if (charset.isEmpty) throw Exception('No character set selected');

    final rng = Random.secure();
    return List.generate(length, (_) => charset[rng.nextInt(charset.length)]).join();
  }

  static double entropy(String password) {
    if (password.isEmpty) return 0;
    final charset = _detectCharsetSize(password);
    return password.length * log(charset) / log(2);
  }

  static int _detectCharsetSize(String password) {
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSymbols = password.contains(RegExp(r'[^A-Za-z0-9]'));
    int size = 0;
    if (hasUpper) size += 26;
    if (hasLower) size += 26;
    if (hasDigits) size += 10;
    if (hasSymbols) size += 32;
    return size == 0 ? 26 : size;
  }

  static String strengthLabel(double entropy) {
    if (entropy < 28) return 'VERY WEAK';
    if (entropy < 36) return 'WEAK';
    if (entropy < 60) return 'FAIR';
    if (entropy < 80) return 'STRONG';
    return 'VERY STRONG';
  }

  static Duration bruteForceDuration(double entropy) {
    // Assume 1 billion guesses per second (GPU)
    const guessesPerSecond = 1e9;
    final totalGuesses = pow(2, entropy);
    final seconds = totalGuesses / guessesPerSecond;
    return Duration(seconds: seconds.clamp(0, double.maxFinite).round());
  }

  static String generatePin(int length) {
    final rng = Random.secure();
    return List.generate(length, (_) => rng.nextInt(10).toString()).join();
  }
}
