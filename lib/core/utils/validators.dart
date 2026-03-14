class Validators {
  Validators._();

  static bool isHex(String value) {
    final clean = value.trim().replaceAll(' ', '').replaceAll(':', '');
    return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(clean);
  }

  static bool isBase64(String value) {
    final clean = value.trim();
    try {
      return RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(clean) &&
          clean.length % 4 == 0;
    } catch (_) {
      return false;
    }
  }

  static bool isValidJson(String value) {
    try {
      // Simple JSON check using regex markers
      final trimmed = value.trim();
      return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'));
    } catch (_) {
      return false;
    }
  }

  static bool isValidEmail(String value) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim());
  }

  static bool isValidIpv4(String value) {
    final parts = value.trim().split('.');
    if (parts.length != 4) return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }

  static bool isValidUrl(String value) {
    try {
      final uri = Uri.parse(value.trim());
      return uri.hasScheme && uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }

  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static String? requireNonEmpty(String? value, [String field = 'Input']) {
    if (isEmpty(value)) return '$field cannot be empty';
    return null;
  }
}
