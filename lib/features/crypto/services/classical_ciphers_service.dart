class ClassicalCiphersService {
  ClassicalCiphersService._();

  // ═══════════════════════════════════════════════════════
  // CAESAR CIPHER
  // ═══════════════════════════════════════════════════════

  /// Encrypt text using Caesar cipher with shift
  static String caesarEncrypt(String text, int shift) {
    shift = ((shift % 26) + 26) % 26; // Normalize shift to 0-25
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) { // Uppercase A-Z
        return ((rune - 65 + shift) % 26) + 65;
      } else if (rune >= 97 && rune <= 122) { // Lowercase a-z
        return ((rune - 97 + shift) % 26) + 97;
      }
      return rune; // Keep non-alphabetic characters unchanged
    }));
  }

  /// Decrypt Caesar cipher
  static String caesarDecrypt(String text, int shift) {
    return caesarEncrypt(text, -shift);
  }

  /// Brute force all possible Caesar shifts
  static List<String> caesarBruteForce(String text) {
    return List.generate(26, (shift) {
      final decrypted = caesarDecrypt(text, shift);
      return 'Shift $shift: $decrypted';
    });
  }

  // ═══════════════════════════════════════════════════════
  // VIGENÈRE CIPHER
  // ═══════════════════════════════════════════════════════

  /// Encrypt text using Vigenère cipher
  static String vigenereEncrypt(String text, String key) {
    if (key.isEmpty) throw ArgumentError('Key cannot be empty');
    
    final cleanKey = key.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (cleanKey.isEmpty) throw ArgumentError('Key must contain letters');
    
    var keyIndex = 0;
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) { // Uppercase
        final shift = cleanKey.codeUnitAt(keyIndex % cleanKey.length) - 97;
        keyIndex++;
        return ((rune - 65 + shift) % 26) + 65;
      } else if (rune >= 97 && rune <= 122) { // Lowercase
        final shift = cleanKey.codeUnitAt(keyIndex % cleanKey.length) - 97;
        keyIndex++;
        return ((rune - 97 + shift) % 26) + 97;
      }
      return rune; // Keep non-alphabetic characters unchanged
    }));
  }

  /// Decrypt Vigenère cipher
  static String vigenereDecrypt(String text, String key) {
    if (key.isEmpty) throw ArgumentError('Key cannot be empty');
    
    final cleanKey = key.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (cleanKey.isEmpty) throw ArgumentError('Key must contain letters');
    
    var keyIndex = 0;
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) { // Uppercase
        final shift = cleanKey.codeUnitAt(keyIndex % cleanKey.length) - 97;
        keyIndex++;
        return ((rune - 65 - shift + 26) % 26) + 65;
      } else if (rune >= 97 && rune <= 122) { // Lowercase
        final shift = cleanKey.codeUnitAt(keyIndex % cleanKey.length) - 97;
        keyIndex++;
        return ((rune - 97 - shift + 26) % 26) + 97;
      }
      return rune; // Keep non-alphabetic characters unchanged
    }));
  }

  // ═══════════════════════════════════════════════════════
  // ATBASH CIPHER
  // ═══════════════════════════════════════════════════════

  /// Encrypt/decrypt using Atbash cipher (mirror substitution)
  static String atbash(String text) {
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) { // Uppercase A-Z
        return 90 - (rune - 65);
      } else if (rune >= 97 && rune <= 122) { // Lowercase a-z
        return 122 - (rune - 97);
      }
      return rune; // Keep non-alphabetic characters unchanged
    }));
  }

  // ═══════════════════════════════════════════════════════
  // ROT13 / ROT47
  // ═══════════════════════════════════════════════════════

  /// Apply ROT13 (special case of Caesar with shift 13)
  static String rot13(String text) {
    return caesarEncrypt(text, 13);
  }

  /// Apply ROT47 (extends ROT13 to ASCII printable characters)
  static String rot47(String text) {
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 33 && rune <= 126) {
        return 33 + ((rune - 33 + 47) % 94);
      }
      return rune;
    }));
  }

  // ═══════════════════════════════════════════════════════
  // AFFINE CIPHER
  // ═══════════════════════════════════════════════════════

  /// Encrypt using Affine cipher: E(x) = (ax + b) mod 26
  static String affineEncrypt(String text, int a, int b) {
    if (_gcd(a, 26) != 1) {
      throw ArgumentError('Parameter "a" must be coprime with 26');
    }
    
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) {
        return (((a * (rune - 65) + b) % 26) + 65);
      } else if (rune >= 97 && rune <= 122) {
        return (((a * (rune - 97) + b) % 26) + 97);
      }
      return rune;
    }));
  }

  /// Decrypt Affine cipher: D(x) = a⁻¹(x - b) mod 26
  static String affineDecrypt(String text, int a, int b) {
    if (_gcd(a, 26) != 1) {
      throw ArgumentError('Parameter "a" must be coprime with 26');
    }
    
    final aInv = _modInverse(a, 26);
    
    return String.fromCharCodes(text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) {
        return ((aInv * ((rune - 65) - b + 26) % 26) + 65);
      } else if (rune >= 97 && rune <= 122) {
        return ((aInv * ((rune - 97) - b + 26) % 26) + 97);
      }
      return rune;
    }));
  }

  // Helper: Greatest Common Divisor
  static int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  // Helper: Modular Multiplicative Inverse
  static int _modInverse(int a, int m) {
    for (var x = 1; x < m; x++) {
      if ((a * x) % m == 1) return x;
    }
    throw ArgumentError('Modular inverse does not exist');
  }

  // ═══════════════════════════════════════════════════════
  // RAIL FENCE CIPHER
  // ═══════════════════════════════════════════════════════

  /// Encrypt using Rail Fence (Zig-Zag) cipher
  static String railFenceEncrypt(String text, int rails) {
    if (rails < 2) throw ArgumentError('Rails must be at least 2');
    if (text.isEmpty) return text;
    
    final fence = List.generate(rails, (_) => <int>[]);
    var rail = 0;
    var direction = 1;
    
    // Create the fence pattern
    for (var i = 0; i < text.length; i++) {
      fence[rail].add(i);
      rail += direction;
      if (rail == 0 || rail == rails - 1) direction *= -1;
    }
    
    // Read off the fence
    final result = StringBuffer();
    for (final row in fence) {
      for (final idx in row) {
        result.writeCharCode(text.codeUnitAt(idx));
      }
    }
    
    return result.toString();
  }

  /// Decrypt Rail Fence cipher
  static String railFenceDecrypt(String text, int rails) {
    if (rails < 2) throw ArgumentError('Rails must be at least 2');
    if (text.isEmpty) return text;
    
    final length = text.length;
    final fence = List.generate(rails, (_) => <int>[]);
    var rail = 0;
    var direction = 1;
    
    // Mark the fence positions
    for (var i = 0; i < length; i++) {
      fence[rail].add(i);
      rail += direction;
      if (rail == 0 || rail == rails - 1) direction *= -1;
    }
    
    // Fill the fence with ciphertext characters
    final filledFence = List.generate(rails, (_) => <String>[]);
    var charIndex = 0;
    for (var r = 0; r < rails; r++) {
      for (var pos in fence[r]) {
        filledFence[r].add(text[charIndex++]);
      }
    }
    
    // Read the plaintext from the fence
    final result = StringBuffer();
    rail = 0;
    direction = 1;
    final indices = List.filled(rails, 0);
    
    for (var i = 0; i < length; i++) {
      result.write(filledFence[rail][indices[rail]++]);
      rail += direction;
      if (rail == 0 || rail == rails - 1) direction *= -1;
    }
    
    return result.toString();
  }

  // ═══════════════════════════════════════════════════════
  // SUBSTITUTION CIPHER
  // ═══════════════════════════════════════════════════════

  /// Encrypt using simple substitution cipher with custom alphabet mapping
  static String substitutionEncrypt(String text, Map<String, String> mapping) {
    return text.split('').map((char) {
      final lower = char.toLowerCase();
      final upper = char.toUpperCase();
      if (mapping.containsKey(lower)) {
        return char == lower ? mapping[lower]! : mapping[lower]!.toUpperCase();
      }
      return char;
    }).join();
  }

  /// Decrypt substitution cipher (reverse mapping)
  static String substitutionDecrypt(String text, Map<String, String> mapping) {
    final reverseMap = {for (var e in mapping.entries) e.value: e.key};
    return text.split('').map((char) {
      final lower = char.toLowerCase();
      if (reverseMap.containsKey(lower)) {
        return char == lower ? reverseMap[lower]! : reverseMap[lower]!.toUpperCase();
      }
      return char;
    }).join();
  }
}
