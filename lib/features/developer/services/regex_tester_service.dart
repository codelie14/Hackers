class RegexTesterService {
  RegexTesterService._();

  /// Test regex pattern against input text
  static Map<String, dynamic> testRegex({
    required String pattern,
    required String text,
    bool caseInsensitive = false,
    bool multiLine = false,
    bool dotAll = false,
  }) {
    try {
      // Build regex flags
      String flags = '';
      if (caseInsensitive) flags += 'i';
      if (multiLine) flags += 'm';
      if (dotAll) flags += 's';
      
      final fullPattern = flags.isNotEmpty 
          ? '(?$flags)$pattern' 
          : pattern;
      
      final regex = RegExp(fullPattern);
      
      // Find all matches
      final matches = <Map<String, dynamic>>[];
      final allMatches = regex.allMatches(text);
      
      for (final match in allMatches) {
        final matchData = <String, dynamic>{
          'match': match.group(0),
          'start': match.start,
          'end': match.end,
          'groups': <dynamic>[],
        };
        
        // Extract capture groups
        for (var i = 1; i <= match.groupCount; i++) {
          matchData['groups'].add(match.group(i));
        }
        
        matches.add(matchData);
      }
      
      return {
        'success': true,
        'pattern': pattern,
        'flags': flags,
        'matchCount': matches.length,
        'matches': matches,
        'hasMatches': matches.isNotEmpty,
        'firstMatch': matches.isNotEmpty ? matches[0] : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Invalid regex pattern: ${e.toString()}',
      };
    }
  }

  /// Highlight matches in text with markdown-like formatting
  static String highlightMatches({
    required String pattern,
    required String text,
    bool caseInsensitive = false,
    bool multiLine = false,
    bool dotAll = false,
  }) {
    try {
      String flags = '';
      if (caseInsensitive) flags += 'i';
      if (multiLine) flags += 'm';
      if (dotAll) flags += 's';
      
      final fullPattern = flags.isNotEmpty 
          ? '(?$flags)$pattern' 
          : pattern;
      
      final regex = RegExp(fullPattern);
      
      return text.replaceAllMapped(regex, (match) {
        return '**${match.group(0)}**';
      });
    } catch (e) {
      return text;
    }
  }

  /// Explain common regex patterns
  static String explainPattern(String pattern) {
    final explanations = <String, String>{
      r'\d': 'Matches any digit (0-9)',
      r'\w': 'Matches any word character (a-z, A-Z, 0-9, _)',
      r'\s': 'Matches any whitespace character',
      r'\D': 'Matches any non-digit character',
      r'\W': 'Matches any non-word character',
      r'\S': 'Matches any non-whitespace character',
      '.': 'Matches any character (except newline)',
      '*': 'Matches 0 or more times (greedy)',
      '+': 'Matches 1 or more times (greedy)',
      '?': 'Matches 0 or 1 time (optional)',
      '{n}': 'Matches exactly n times',
      '{n,}': 'Matches n or more times',
      '{n,m}': 'Matches between n and m times',
      '^': 'Matches start of string/line',
      r'$': 'Matches end of string/line',
      '[]': 'Character class - matches any character inside',
      '[^]': 'Negated character class',
      '()': 'Capturing group',
      '(?:)': 'Non-capturing group',
      '|': 'Alternation (OR operator)',
      r'\b': 'Word boundary',
      r'\B': 'Non-word boundary',
    };

    final foundExplanations = <String>[];
    
    for (final entry in explanations.entries) {
      if (pattern.contains(entry.key)) {
        foundExplanations.add('`${entry.key}` - ${entry.value}');
      }
    }

    if (foundExplanations.isEmpty) {
      return 'No common regex patterns recognized. This may be a literal pattern.';
    }

    return foundExplanations.join('\n');
  }

  /// Generate regex pattern for common use cases
  static String generatePattern(String useCase) {
    final patterns = {
      'email': r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
      'url': r'https?://[^\s<>"{}|\\^`\[\]]+',
      'ip': r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b',
      'ipv6': r'([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}',
      'date': r'\d{4}-\d{2}-\d{2}',
      'time': r'\d{2}:\d{2}(:\d{2})?',
      'phone': r'\+?[\d\s-()]+',
      'credit_card': r'\b\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}\b',
      'ssn': r'\b\d{3}-\d{2}-\d{4}\b',
      'hex_color': r'#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})',
      'rgb_color': r'rgb\(\d{1,3},\s*\d{1,3},\s*\d{1,3}\)',
      'html_tag': r'<(/?)(\w+)[^>]*>',
      'filename': r'[a-zA-Z0-9_\-.]+\.[a-zA-Z0-9]+',
      'username': r'^[a-zA-Z][a-zA-Z0-9_]{2,19}$',
      'password_strong': r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
      'bitcoin_address': r'\b[13][a-km-zA-HJ-NP-Z1-9]{25,34}\b',
      'ethereum_address': r'\b0x[a-fA-F0-9]{40}\b',
    };

    return patterns[useCase.toLowerCase()] ?? 'Pattern not found';
  }

  /// Validate common formats
  static bool validateFormat(String format, String value) {
    final patterns = {
      'email': RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
      'url': RegExp(r'^https?://[^\s<>"{}|\\^`\[\]]+$'),
      'ip': RegExp(r'^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b$'),
      'date_iso': RegExp(r'^\d{4}-\d{2}-\d{2}$'),
      'time_24h': RegExp(r'^([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$'),
      'uuid': RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false),
      'hex_color': RegExp(r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$'),
      'base64': RegExp(r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'),
    };

    final regex = patterns[format.toLowerCase()];
    if (regex == null) return false;

    return regex.hasMatch(value);
  }
}
