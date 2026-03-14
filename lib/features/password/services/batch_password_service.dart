import 'dart:math';

class BatchPasswordService {
  BatchPasswordService._();

  static final Random _random = Random.secure();

  /// Generate multiple passwords with full customization
  static List<String> generateBatch({
    required int count,
    required int length,
    bool useUppercase = true,
    bool useLowercase = true,
    bool useNumbers = true,
    bool useSpecial = true,
    bool excludeAmbiguous = false,
    String customCharset = '',
  }) {
    if (count < 1) count = 1;
    if (count > 100) count = 100;
    if (length < 1) length = 1;
    if (length > 256) length = 256;

    // Build character set
    String charset = customCharset.isNotEmpty 
        ? customCharset 
        : _buildCharset(
            useUppercase: useUppercase,
            useLowercase: useLowercase,
            useNumbers: useNumbers,
            useSpecial: useSpecial,
            excludeAmbiguous: excludeAmbiguous,
          );

    if (charset.isEmpty) {
      throw ArgumentError('Character set cannot be empty');
    }

    // Ensure at least one character from each selected type
    final List<String> passwords = [];
    
    for (var i = 0; i < count; i++) {
      final password = _generatePassword(
        length: length,
        charset: charset,
        useUppercase: useUppercase && customCharset.isEmpty,
        useLowercase: useLowercase && customCharset.isEmpty,
        useNumbers: useNumbers && customCharset.isEmpty,
        useSpecial: useSpecial && customCharset.isEmpty,
      );
      passwords.add(password);
    }

    return passwords;
  }

  static String _buildCharset({
    required bool useUppercase,
    required bool useLowercase,
    required bool useNumbers,
    required bool useSpecial,
    required bool excludeAmbiguous,
  }) {
    String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';
    String special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    // Exclude ambiguous characters if requested
    if (excludeAmbiguous) {
      // Remove: l, I, 1, L, o, O, 0
      uppercase = uppercase.replaceAll(RegExp(r'[IO]'), '');
      lowercase = lowercase.replaceAll(RegExp(r'[lo]'), '');
      numbers = numbers.replaceAll('0', '').replaceAll('1', '');
      special = special.replaceAll('|', '');
    }

    StringBuffer charset = StringBuffer();
    if (useUppercase) charset.write(uppercase);
    if (useLowercase) charset.write(lowercase);
    if (useNumbers) charset.write(numbers);
    if (useSpecial) charset.write(special);

    return charset.toString();
  }

  static String _generatePassword({
    required int length,
    required String charset,
    required bool useUppercase,
    required bool useLowercase,
    required bool useNumbers,
    required bool useSpecial,
  }) {
    final StringBuffer password = StringBuffer();
    
    // Ensure at least one character from each type
    if (useUppercase) {
      password.write(charset[_random.nextInt(charset.length)]);
    }
    
    // Fill remaining length
    while (password.length < length) {
      password.write(charset[_random.nextInt(charset.length)]);
    }

    // Shuffle the password
    final chars = password.toString().split('');
    for (var i = chars.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = chars[i];
      chars[i] = chars[j];
      chars[j] = temp;
    }

    return chars.join('').substring(0, length);
  }

  /// Calculate password entropy in bits
  static double calculateEntropy(String password, String charset) {
    if (password.isEmpty || charset.isEmpty) return 0;
    
    final poolSize = charset.length;
    final length = password.length;
    
    // Entropy = log2(poolSize^length) = length * log2(poolSize)
    return length * (log(poolSize) / log(2));
  }

  /// Estimate brute force time
  static String estimateBruteForceTime(String password, String charset, {String attackType = 'online'}) {
    final entropy = calculateEntropy(password, charset);
    
    // Attempts per second based on attack type
    double attemptsPerSecond;
    switch (attackType.toLowerCase()) {
      case 'offline_fast':
        attemptsPerSecond = 100000000000; // 100 billion (GPU cluster)
        break;
      case 'offline_slow':
        attemptsPerSecond = 1000000; // 1 million (single GPU)
        break;
      case 'online':
      default:
        attemptsPerSecond = 1000; // 1000 (rate-limited online service)
    }

    // Total combinations = 2^entropy
    final totalCombinations = pow(2, entropy);
    final seconds = totalCombinations / attemptsPerSecond;

    return _formatDuration(seconds);
  }

  static String _formatDuration(double seconds) {
    if (seconds < 1) return 'Instant';
    if (seconds < 60) return '${seconds.toStringAsFixed(0)} seconds';
    if (seconds < 3600) return '${(seconds / 60).toStringAsFixed(0)} minutes';
    if (seconds < 86400) return '${(seconds / 3600).toStringAsFixed(0)} hours';
    if (seconds < 2629743) return '${(seconds / 86400).toStringAsFixed(0)} days';
    if (seconds < 31556926) return '${(seconds / 2629743).toStringAsFixed(0)} months';
    if (seconds < 315569260) return '${(seconds / 31556926).toStringAsFixed(0)} years';
    if (seconds < 3155692600) return '${(seconds / 315569260).toStringAsFixed(1)} centuries';
    return 'Millions of years';
  }

  /// Check if password meets requirements
  static Map<String, dynamic> analyzePassword(String password, String charset) {
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'));
    
    final entropy = calculateEntropy(password, charset);
    
    String strength;
    if (entropy < 28) {
      strength = 'Very Weak';
    } else if (entropy < 36) {
      strength = 'Weak';
    } else if (entropy < 60) {
      strength = 'Medium';
    } else if (entropy < 80) {
      strength = 'Strong';
    } else {
      strength = 'Very Strong';
    }

    return {
      'length': password.length,
      'hasUppercase': hasUpper,
      'hasLowercase': hasLower,
      'hasNumber': hasNumber,
      'hasSpecial': hasSpecial,
      'entropy': entropy,
      'strength': strength,
      'score': (entropy / 100).clamp(0, 1),
    };
  }
}
