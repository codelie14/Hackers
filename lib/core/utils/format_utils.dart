class FormatUtils {
  FormatUtils._();

  static String bytesToHex(List<int> bytes, {bool upperCase = false}) {
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return upperCase ? hex.toUpperCase() : hex;
  }

  static List<int> hexToBytes(String hex) {
    final clean = hex.replaceAll(' ', '').replaceAll(':', '');
    final result = <int>[];
    for (var i = 0; i < clean.length; i += 2) {
      result.add(int.parse(clean.substring(i, i + 2), radix: 16));
    }
    return result;
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String truncate(String text, {int maxLength = 40}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }

  static String formatDuration(Duration d) {
    if (d.inSeconds < 60) return '${d.inSeconds}s';
    if (d.inMinutes < 60) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    if (d.inHours < 24) return '${d.inHours}h ${d.inMinutes % 60}m';
    if (d.inDays < 365) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inDays < 365 * 100) return '${(d.inDays / 365).toStringAsFixed(0)}y';
    return '> 100 years';
  }

  static String formatBigNumber(double n) {
    if (n < 1e3) return n.toStringAsFixed(0);
    if (n < 1e6) return '${(n / 1e3).toStringAsFixed(1)}K';
    if (n < 1e9) return '${(n / 1e6).toStringAsFixed(1)}M';
    if (n < 1e12) return '${(n / 1e9).toStringAsFixed(1)}B';
    if (n < 1e15) return '${(n / 1e12).toStringAsFixed(1)}T';
    return '∞';
  }

  static String hexGroup(String hex, {int groupSize = 2, String separator = ' '}) {
    final clean = hex.replaceAll(' ', '');
    final groups = <String>[];
    for (var i = 0; i < clean.length; i += groupSize) {
      groups.add(clean.substring(i, (i + groupSize).clamp(0, clean.length)));
    }
    return groups.join(separator);
  }
}
