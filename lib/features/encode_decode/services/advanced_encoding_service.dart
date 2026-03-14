import 'dart:convert';
import 'package:convert/convert.dart';

class AdvancedEncodingService {
  AdvancedEncodingService._();

  // ═══════════════════════════════════════════════════════
  // HTML ENTITIES
  // ═══════════════════════════════════════════════════════

  static String htmlEncode(String text) {
    final StringBuffer result = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      final code = text.codeUnitAt(i);
      if (code > 127 || '<>&'.contains(char)) {
        result.write('&#$code;');
      } else {
        result.write(char);
      }
    }
    return result.toString();
  }

  static String htmlDecode(String html) {
    return html.replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (match) => String.fromCharCode(int.parse(match.group(1)!)),
    );
  }

  // ═══════════════════════════════════════════════════════
  // UNICODE ESCAPES
  // ═══════════════════════════════════════════════════════

  static String unicodeEscape(String text) {
    final StringBuffer result = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final rune = text.runes.elementAt(i);
      if (rune > 127) {
        result.write('\\u{${rune.toRadixString(16).padLeft(4, '0')}}');
      } else {
        result.writeCharCode(rune);
      }
    }
    return result.toString();
  }

  static String unicodeUnescape(String text) {
    return text.replaceAllMapped(
      RegExp(r'\\u\{([0-9A-Fa-f]+)\}'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );
  }

  // ═══════════════════════════════════════════════════════
  // XOR ENCODING
  // ═══════════════════════════════════════════════════════

  static String xorEncode(String text, String key) {
    if (key.isEmpty) throw ArgumentError('Key cannot be empty');
    
    final textBytes = utf8.encode(text);
    final keyBytes = utf8.encode(key);
    
    final result = <int>[];
    for (var i = 0; i < textBytes.length; i++) {
      result.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return hex.encode(result);
  }

  static String xorDecode(String hexData, String key) {
    if (key.isEmpty) throw ArgumentError('Key cannot be empty');
    
    try {
      final dataBytes = hex.decode(hexData);
      final keyBytes = utf8.encode(key);
      
      final result = <int>[];
      for (var i = 0; i < dataBytes.length; i++) {
        result.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(result);
    } catch (e) {
      throw FormatException('Invalid hex data or decoding failed');
    }
  }

  // ═══════════════════════════════════════════════════════
  // BASE58 (BITCOIN ALPHABET)
  // ═══════════════════════════════════════════════════════

  static const String _base58Alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static String base58Encode(List<int> data) {
    if (data.isEmpty) return '';

    var zeros = 0;
    while (zeros < data.length && data[zeros] == 0) {
      zeros++;
    }

    var size = data.length * 138 ~/ 100 + 1;
    var b58 = List<int>.filled(size, 0);

    for (var i = zeros; i < data.length; i++) {
      var carry = data[i];
      for (var j = size - 1; j >= 0; j--) {
        carry += 256 * b58[j];
        b58[j] = carry % 58;
        carry ~/= 58;
      }
    }

    var start = 0;
    while (start < size && b58[start] == 0) {
      start++;
    }

    final result = StringBuffer();
    for (var i = 0; i < zeros; i++) {
      result.write(_base58Alphabet[0]);
    }
    for (var i = start; i < size; i++) {
      result.write(_base58Alphabet[b58[i]]);
    }

    return result.toString();
  }

  static List<int> base58Decode(String encoded) {
    if (encoded.isEmpty) return [];

    var zeros = 0;
    while (zeros < encoded.length && encoded[zeros] == _base58Alphabet[0]) {
      zeros++;
    }

    var size = encoded.length * 733 ~/ 1000 + 1;
    var b256 = List<int>.filled(size, 0);

    for (var i = zeros; i < encoded.length; i++) {
      var carry = _base58Alphabet.indexOf(encoded[i]);
      if (carry < 0) {
        throw FormatException('Invalid Base58 character: ${encoded[i]}');
      }
      for (var j = size - 1; j >= 0; j--) {
        carry += 58 * b256[j];
        b256[j] = carry % 256;
        carry ~/= 256;
      }
    }

    var start = 0;
    while (start < size && b256[start] == 0) {
      start++;
    }

    return [...List.filled(zeros, 0), ...b256.sublist(start)];
  }

  // ═══════════════════════════════════════════════════════
  // NATO PHONETIC ALPHABET
  // ═══════════════════════════════════════════════════════

  static const Map<String, String> _natoMap = {
    'A': 'Alpha', 'B': 'Bravo', 'C': 'Charlie', 'D': 'Delta',
    'E': 'Echo', 'F': 'Foxtrot', 'G': 'Golf', 'H': 'Hotel',
    'I': 'India', 'J': 'Juliett', 'K': 'Kilo', 'L': 'Lima',
    'M': 'Mike', 'N': 'November', 'O': 'Oscar', 'P': 'Papa',
    'Q': 'Quebec', 'R': 'Romeo', 'S': 'Sierra', 'T': 'Tango',
    'U': 'Uniform', 'V': 'Victor', 'W': 'Whiskey', 'X': 'X-ray',
    'Y': 'Yankee', 'Z': 'Zulu',
  };

  static String toNato(String text) {
    return text.toUpperCase().split('').map((char) {
      if (char == ' ') return ' ';
      return _natoMap[char] ?? char;
    }).join(' ');
  }

  static String fromNato(String nato) {
    final reverseMap = {for (var e in _natoMap.entries) e.value: e.key};
    return nato.split(' ').map((word) {
      if (word.isEmpty) return ' ';
      return reverseMap[word] ?? word;
    }).join();
  }

  // ═══════════════════════════════════════════════════════
  // MORSE CODE (Extended version)
  // ═══════════════════════════════════════════════════════

  static const Map<String, String> _morseMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.',
    'F': '..-.', 'G': '--.', 'H': '....', 'I': '..', 'J': '.---',
    'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---',
    'P': '.--.', 'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-',
    'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-', 'Y': '-.--',
    'Z': '--..', '1': '.----', '2': '..---', '3': '...--',
    '4': '....-', '5': '.....', '6': '-....', '7': '--...',
    '8': '---..', '9': '----.', '0': '-----',
    ' ': '/',
  };

  static String toMorse(String text) {
    return text.toUpperCase().split('').map((char) {
      return _morseMap[char] ?? char;
    }).join(' ');
  }

  static String fromMorse(String morse) {
    final reverseMap = {for (var e in _morseMap.entries) e.value: e.key};
    return morse.split(' ').map((code) {
      return reverseMap[code] ?? code;
    }).join();
  }
}
