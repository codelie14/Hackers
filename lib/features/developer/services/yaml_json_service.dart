import 'dart:convert';
import 'package:yaml/yaml.dart';

class YamlJsonService {
  YamlJsonService._();

  /// Convert YAML to JSON with formatting
  static String yamlToJson(String yamlString, {bool pretty = true}) {
    try {
      final yamlDoc = loadYaml(yamlString);
      final jsonMap = _convertYamlToMap(yamlDoc);
      
      if (pretty) {
        return JsonEncoder.withIndent('  ').convert(jsonMap);
      } else {
        return jsonEncode(jsonMap);
      }
    } catch (e) {
      throw FormatException('Invalid YAML: ${e.toString()}');
    }
  }

  /// Convert JSON to YAML
  static String jsonToYaml(String jsonString) {
    try {
      final jsonDoc = jsonDecode(jsonString);
      return _convertToJsonYaml(jsonDoc, 0);
    } catch (e) {
      throw FormatException('Invalid JSON: ${e.toString()}');
    }
  }

  /// Validate YAML syntax
  static Map<String, dynamic> validateYaml(String yamlString) {
    try {
      final yamlDoc = loadYaml(yamlString);
      return {
        'valid': true,
        'message': 'Valid YAML syntax',
      };
    } catch (e) {
      return {
        'valid': false,
        'message': e.toString(),
      };
    }
  }

  /// Minify JSON
  static String minifyJson(String jsonString) {
    try {
      final jsonDoc = jsonDecode(jsonString);
      return jsonEncode(jsonDoc);
    } catch (e) {
      throw FormatException('Invalid JSON: ${e.toString()}');
    }
  }

  /// Beautify/Format JSON
  static String beautifyJson(String jsonString) {
    try {
      final jsonDoc = jsonDecode(jsonString);
      return JsonEncoder.withIndent('  ').convert(jsonDoc);
    } catch (e) {
      throw FormatException('Invalid JSON: ${e.toString()}');
    }
  }

  /// Validate JSON syntax
  static Map<String, dynamic> validateJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return {
        'valid': true,
        'message': 'Valid JSON syntax',
      };
    } catch (e) {
      return {
        'valid': false,
        'message': e.toString(),
      };
    }
  }

  // Helper: Convert YamlMap/YamlList to regular Map/List
  static dynamic _convertYamlToMap(dynamic yamlNode) {
    if (yamlNode is YamlMap) {
      final map = <String, dynamic>{};
      for (final entry in yamlNode.nodes.entries) {
        map[entry.key.toString()] = _convertYamlToMap(entry.value);
      }
      return map;
    } else if (yamlNode is YamlList) {
      return yamlNode.nodes.map(_convertYamlToMap).toList();
    } else if (yamlNode is YamlScalar) {
      return yamlNode.value;
    }
    return yamlNode;
  }

  // Helper: Convert JSON to YAML format recursively
  static String _convertToJsonYaml(dynamic node, int indentLevel) {
    final indent = '  ' * indentLevel;
    
    if (node == null) {
      return '${indent}null';
    } else if (node is String) {
      // Check if string needs quoting
      if (node.isEmpty || 
          node.contains(':') || 
          node.contains('#') ||
          node.startsWith(' ') ||
          node.endsWith(' ') ||
          node.contains('\n')) {
        return "${indent}'${node.replaceAll("'", "''")}'";
      }
      return '$indent$node';
    } else if (node is bool) {
      return '$indent${node.toString().toLowerCase()}';
    } else if (node is num) {
      return '$indent$node';
    } else if (node is List) {
      if (node.isEmpty) {
        return '$indent[]';
      }
      final buffer = StringBuffer();
      for (var item in node) {
        if (item is Map || item is List) {
          buffer.write('$indent-\\n');
          buffer.write(_convertToJsonYaml(item, indentLevel + 1));
        } else {
          buffer.write('$indent- ${_convertToJsonYaml(item, 0).trim()}\\n');
        }
      }
      return buffer.toString();
    } else if (node is Map) {
      if (node.isEmpty) {
        return '${indent}{}';
      }
      final buffer = StringBuffer();
      final entries = node.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final key = entry.key.toString();
        final value = entry.value;
        
        if (value is Map || value is List) {
          buffer.write('$indent$key:\\n');
          buffer.write(_convertToJsonYaml(value, indentLevel + 1));
        } else {
          final yamlValue = _convertToJsonYaml(value, 0).trim();
          buffer.write('$indent$key: $yamlValue\\n');
        }
      }
      return buffer.toString();
    }
    
    return '$indent$node';
  }
}
