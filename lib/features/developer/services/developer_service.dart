import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';

class DeveloperService {
  DeveloperService._();

  // JSON
  static String formatJson(String input, {int indent = 2}) {
    final decoded = jsonDecode(input);
    final encoder = JsonEncoder.withIndent(' ' * indent);
    return encoder.convert(decoded);
  }

  static String minifyJson(String input) {
    final decoded = jsonDecode(input);
    return jsonEncode(decoded);
  }

  // UUID
  static String generateUuidV4() => const Uuid().v4();
  static String generateUuidV1() => const Uuid().v1();

  static List<String> generateUuids(int count, {int version = 4}) {
    return List.generate(count, (_) => version == 1 ? const Uuid().v1() : const Uuid().v4());
  }

  // Random bytes / token
  static String randomHex(int byteCount) {
    final rng = Random.secure();
    return List.generate(byteCount, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }

  static String randomBase64(int byteCount) {
    final rng = Random.secure();
    final bytes = List.generate(byteCount, (_) => rng.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  // Timestamp
  static Map<String, dynamic> timestampInfo(DateTime dt) {
    return {
      'unix_seconds': dt.millisecondsSinceEpoch ~/ 1000,
      'unix_millis': dt.millisecondsSinceEpoch,
      'iso8601': dt.toIso8601String(),
      'utc': dt.toUtc().toString(),
      'rfc2822': _toRfc2822(dt.toUtc()),
    };
  }

  static String _toRfc2822(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year} ${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)} +0000';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
