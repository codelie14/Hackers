import 'dart:convert';
import 'dart:math';

class EncodeDecodeService {
  EncodeDecodeService._();

  // Base64
  static String encodeBase64(String input, {bool urlSafe = false}) {
    final bytes = utf8.encode(input);
    return urlSafe ? base64Url.encode(bytes) : base64.encode(bytes);
  }

  static String decodeBase64(String input) {
    try {
      final normalized = input.replaceAll('-', '+').replaceAll('_', '/');
      final padded = normalized.padRight((normalized.length + 3) ~/ 4 * 4, '=');
      return utf8.decode(base64.decode(padded));
    } catch (_) {
      throw Exception('Invalid Base64 input');
    }
  }

  // Hex
  static String encodeHex(String input) {
    return utf8.encode(input).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static String decodeHex(String input) {
    final clean = input.trim().replaceAll(' ', '').replaceAll(':', '');
    if (clean.length % 2 != 0) throw Exception('Invalid hex string length');
    final bytes = <int>[];
    for (var i = 0; i < clean.length; i += 2) {
      bytes.add(int.parse(clean.substring(i, i + 2), radix: 16));
    }
    return utf8.decode(bytes);
  }

  // URL encode
  static String encodeUrl(String input) => Uri.encodeFull(input);
  static String decodeUrl(String input) => Uri.decodeFull(input);

  static String encodeUrlComponent(String input) => Uri.encodeComponent(input);
  static String decodeUrlComponent(String input) => Uri.decodeComponent(input);

  // ROT13
  static String rot13(String input) {
    return String.fromCharCodes(input.runes.map((c) {
      if (c >= 65 && c <= 90) return (c - 65 + 13) % 26 + 65;
      if (c >= 97 && c <= 122) return (c - 97 + 13) % 26 + 97;
      return c;
    }));
  }

  // ROT47
  static String rot47(String input) {
    return String.fromCharCodes(input.runes.map((c) {
      if (c >= 33 && c <= 126) return (c - 33 + 47) % 94 + 33;
      return c;
    }));
  }

  // Morse
  static const _morseAlphabet = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.',
    'G': '--.', 'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
    'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
    'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..', '0': '-----', '1': '.----', '2': '..---',
    '3': '...--', '4': '....-', '5': '.....', '6': '-....', '7': '--...',
    '8': '---..', '9': '----.', ' ': '/',
  };

  static final _reverseMorse = {for (final e in _morseAlphabet.entries) e.value: e.key};

  static String encodeToMorse(String input) {
    return input.toUpperCase().split('').map((c) => _morseAlphabet[c] ?? '?').join(' ');
  }

  static String decodeFromMorse(String input) {
    return input.split('   ').map((word) {
      if (word == '/') return ' ';
      return word.split(' ').map((code) => _reverseMorse[code] ?? '?').join();
    }).join(' ');
  }

  // Binary / Octal / ASCII
  static String textToBinary(String input) {
    return utf8.encode(input).map((b) => b.toRadixString(2).padLeft(8, '0')).join(' ');
  }

  static String binaryToText(String input) {
    final parts = input.trim().replaceAll(' ', '').split(RegExp(r'(?<=.{8})'));
    // Re-chunk in groups of 8
    final bytes = <int>[];
    final clean = input.trim().replaceAll(RegExp(r'\s+'), '');
    for (var i = 0; i < clean.length; i += 8) {
      final chunk = clean.substring(i, (i + 8).clamp(0, clean.length));
      bytes.add(int.parse(chunk, radix: 2));
    }
    return utf8.decode(bytes);
  }

  static String textToOctal(String input) {
    return utf8.encode(input).map((b) => b.toRadixString(8).padLeft(3, '0')).join(' ');
  }

  static String octalToText(String input) {
    final parts = input.trim().split(RegExp(r'\s+'));
    final bytes = parts.map((p) => int.parse(p, radix: 8)).toList();
    return utf8.decode(bytes);
  }

  static String textToAscii(String input) {
    return input.runes.map((r) => r.toString()).join(' ');
  }

  static String asciiToText(String input) {
    final codePoints = input.trim().split(RegExp(r'\s+'));
    return String.fromCharCodes(codePoints.map((c) => int.parse(c)));
  }
}
