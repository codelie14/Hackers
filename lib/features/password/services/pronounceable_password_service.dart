import 'dart:math';

class PronounceablePasswordService {
  PronounceablePasswordService._();

  static final Random _random = Random.secure();

  // Syllable patterns for pronounceable passwords
  static const List<String> _consonants = [
    'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 
    'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'z'
  ];

  static const List<String> _vowels = [
    'a', 'e', 'i', 'o', 'u', 'y'
  ];

  static const List<String> _digraphs = [
    'ch', 'gh', 'ph', 'sh', 'th', 'wh', 'ck', 'ng', 
    'qu', 'rh', 'wr', 'kn', 'mb', 'nd', 'nt', 'st'
  ];

  static const List<String> _syllables = [
    'ba', 'be', 'bi', 'bo', 'bu', 'by',
    'ca', 'ce', 'ci', 'co', 'cu', 'cy',
    'da', 'de', 'di', 'do', 'du', 'dy',
    'fa', 'fe', 'fi', 'fo', 'fu', 'fy',
    'ga', 'ge', 'gi', 'go', 'gu', 'gy',
    'ha', 'he', 'hi', 'ho', 'hu', 'hy',
    'ja', 'je', 'ji', 'jo', 'ju', 'jy',
    'ka', 'ke', 'ki', 'ko', 'ku', 'ky',
    'la', 'le', 'li', 'lo', 'lu', 'ly',
    'ma', 'me', 'mi', 'mo', 'mu', 'my',
    'na', 'ne', 'ni', 'no', 'nu', 'ny',
    'pa', 'pe', 'pi', 'po', 'pu', 'py',
    'ra', 're', 'ri', 'ro', 'ru', 'ry',
    'sa', 'se', 'si', 'so', 'su', 'sy',
    'ta', 'te', 'ti', 'to', 'tu', 'ty',
    'va', 've', 'vi', 'vo', 'vu', 'vy',
    'wa', 'we', 'wi', 'wo', 'wu', 'wy',
    'xa', 'xe', 'xi', 'xo', 'xu', 'xy',
    'za', 'ze', 'zi', 'zo', 'zu', 'zy'
  ];

  /// Generate a pronounceable password
  static String generate({
    int length = 12,
    bool includeNumbers = true,
    bool includeSpecial = false,
    bool capitalize = true,
  }) {
    if (length < 4) length = 4;
    if (length > 128) length = 128;

    final StringBuffer password = StringBuffer();
    bool useConsonant = _random.nextBool();
    
    while (password.length < length) {
      String segment;
      
      // Alternate between consonants and vowels for pronounceability
      if (useConsonant) {
        // Sometimes use digraphs for variety
        if (_random.nextDouble() < 0.2) {
          segment = _digraphs[_random.nextInt(_digraphs.length)];
        } else {
          segment = _consonants[_random.nextInt(_consonants.length)];
        }
      } else {
        // Use syllables or vowels
        if (_random.nextDouble() < 0.7) {
          segment = _syllables[_random.nextInt(_syllables.length)];
        } else {
          segment = _vowels[_random.nextInt(_vowels.length)];
        }
      }
      
      password.write(segment);
      useConsonant = !useConsonant;
    }
    
    String result = password.toString();
    
    // Trim to exact length
    if (result.length > length) {
      result = result.substring(0, length);
    }
    
    // Capitalize if requested
    if (capitalize) {
      result = _capitalizeSmart(result);
    }
    
    // Add numbers if requested
    if (includeNumbers && length > 4) {
      result = _insertNumbers(result, length);
    }
    
    // Add special characters if requested
    if (includeSpecial && length > 6) {
      result = _insertSpecialChars(result);
    }
    
    return result;
  }

  /// Generate multiple pronounceable passwords
  static List<String> generateBatch({
    int count = 5,
    int length = 12,
    bool includeNumbers = true,
    bool includeSpecial = false,
    bool capitalize = true,
  }) {
    return List.generate(
      count,
      (_) => generate(
        length: length,
        includeNumbers: includeNumbers,
        includeSpecial: includeSpecial,
        capitalize: capitalize,
      ),
    );
  }

  static String _capitalizeSmart(String text) {
    if (text.isEmpty) return text;
    
    // Capitalize first letter and letters after numbers/special chars
    final StringBuffer result = StringBuffer();
    bool capitalizeNext = true;
    
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (capitalizeNext && char.toLowerCase() != char.toUpperCase()) {
        result.write(char.toUpperCase());
        capitalizeNext = false;
      } else {
        result.write(char.toLowerCase());
      }
      
      // Capitalize after numbers or special chars
      if (RegExp(r'[0-9!@#$%^&*]').hasMatch(char)) {
        capitalizeNext = true;
      }
    }
    
    return result.toString();
  }

  static String _insertNumbers(String text, int targetLength) {
    final random = Random.secure();
    final numbers = '0123456789';
    var result = text;
    
    // Insert 2-4 numbers at random positions
    final numCount = random.nextInt(3) + 2;
    for (var i = 0; i < numCount; i++) {
      final pos = random.nextInt(result.length);
      final num = numbers[random.nextInt(numbers.length)];
      result = result.substring(0, pos) + num + result.substring(pos);
    }
    
    // Trim if too long
    if (result.length > targetLength) {
      result = result.substring(0, targetLength);
    }
    
    return result;
  }

  static String _insertSpecialChars(String text) {
    final random = Random.secure();
    const specials = '!@#\$%^&*()-_=+[]{}|;:,.<>?';
    var result = text;
    
    // Insert 1-2 special characters
    final specialCount = random.nextInt(2) + 1;
    for (var i = 0; i < specialCount; i++) {
      final pos = random.nextInt(result.length);
      final special = specials[random.nextInt(specials.length)];
      result = result.substring(0, pos) + special + result.substring(pos);
    }
    
    return result;
  }

  /// Calculate approximate pronunciation score
  static double getPronounceabilityScore(String password) {
    if (password.isEmpty) return 0.0;
    
    int vowelCount = 0;
    int consonantCount = 0;
    int alternatingPattern = 0;
    
    for (var i = 0; i < password.length; i++) {
      final char = password[i].toLowerCase();
      final isVowel = 'aeiouy'.contains(char);
      
      if (isVowel) {
        vowelCount++;
        if (i > 0 && !'aeiouy'.contains(password[i - 1].toLowerCase())) {
          alternatingPattern++;
        }
      } else if (char.toLowerCase() != char.toUpperCase()) {
        consonantCount++;
        if (i > 0 && 'aeiouy'.contains(password[i - 1].toLowerCase())) {
          alternatingPattern++;
        }
      }
    }
    
    // Score based on vowel/consonant ratio and alternation
    final totalLetters = vowelCount + consonantCount;
    if (totalLetters == 0) return 0.0;
    
    final vowelRatio = vowelCount / totalLetters;
    final alternationScore = alternatingPattern / totalLetters;
    
    // Ideal vowel ratio is around 0.4-0.5
    final ratioScore = 1 - (0.45 - vowelRatio).abs() * 2;
    
    return ((ratioScore + alternationScore) / 2 * 100).clamp(0, 100);
  }
}
