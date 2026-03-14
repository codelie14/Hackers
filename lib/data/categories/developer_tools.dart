import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// DEVELOPER TOOLS
/// Development Utilities and Helpers
/// ────────────────────────────────────────────────────────────

class DeveloperTools {
  DeveloperTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'json_tool',
      name: 'JSON Formatter',
      description:
          'Format, validate, beautify, and minify JSON data with syntax highlighting.',
      category: ToolCategory.developer,
      icon: Icons.data_object,
      tags: ['json', 'format', 'validate', 'beautify', 'minify'],
      isAvailable: true,
      routePath: '/developer/json-formatter',
    ),
    ToolModel(
      id: 'json_yaml_tool',
      name: 'JSON ↔ YAML Converter',
      description: 'Convert between JSON and YAML formats bidirectionally.',
      category: ToolCategory.developer,
      icon: Icons.compare_arrows,
      tags: ['json', 'yaml', 'convert'],
      isAvailable: true,
      routePath: '/developer/json-yaml',
    ),
    ToolModel(
      id: 'jwt_decoder',
      name: 'JWT Decoder',
      description:
          'Decode and inspect JWT tokens — header, payload, signature analysis.',
      category: ToolCategory.developer,
      icon: Icons.verified_user_outlined,
      tags: ['jwt', 'token', 'decode', 'auth'],
      isAvailable: true,
      routePath: '/developer/jwt',
    ),
    ToolModel(
      id: 'regex_tester',
      name: 'Regex Tester',
      description:
          'Test regular expressions with live match highlighting and group extraction.',
      category: ToolCategory.developer,
      icon: Icons.search,
      tags: ['regex', 'regexp', 'test', 'match'],
      isAvailable: true,
      routePath: '/developer/regex-tester',
    ),
    ToolModel(
      id: 'diff_tool',
      name: 'Diff Tool',
      description:
          'Compare two text blocks side-by-side with unified diff highlighting.',
      category: ToolCategory.developer,
      icon: Icons.difference,
      tags: ['diff', 'compare', 'text', 'patch'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'cron_tool',
      name: 'CRON Explainer',
      description:
          'Parse cron expressions and preview their next execution times.',
      category: ToolCategory.developer,
      icon: Icons.schedule,
      tags: ['cron', 'schedule', 'task', 'explain'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'timestamp_tool',
      name: 'Timestamp Converter',
      description:
          'Convert between Unix timestamps and human-readable date/time formats.',
      category: ToolCategory.developer,
      icon: Icons.access_time,
      tags: ['timestamp', 'unix', 'date', 'time', 'epoch'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'uuid_generator',
      name: 'UUID Generator',
      description:
          'Generate UUID v1, v4, and v7 universally unique identifiers.',
      category: ToolCategory.developer,
      icon: Icons.tag,
      tags: ['uuid', 'guid', 'v4', 'unique', 'id'],
      isAvailable: true,
      routePath: '/developer/uuid',
    ),
    ToolModel(
      id: 'color_converter',
      name: 'Color Converter',
      description:
          'Convert colors between HEX, RGB, HSL, HSV, and CMYK with palette generation.',
      category: ToolCategory.developer,
      icon: Icons.color_lens_outlined,
      tags: ['color', 'hex', 'rgb', 'hsl', 'palette'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'markdown_preview',
      name: 'Markdown Previewer',
      description:
          'Preview and edit Markdown with real-time rendering (GFM support).',
      category: ToolCategory.developer,
      icon: Icons.description_outlined,
      tags: ['markdown', 'preview', 'gfm', 'md'],
      isAvailable: true,
      routePath: '/developer/markdown',
    ),
    ToolModel(
      id: 'sql_formatter',
      name: 'SQL Formatter',
      description: 'Format and beautify SQL queries with syntax highlighting.',
      category: ToolCategory.developer,
      icon: Icons.storage,
      tags: ['sql', 'format', 'database', 'query'],
      isAvailable: true,
      routePath: '/developer/sql-formatter',
    ),
    ToolModel(
      id: 'http_status',
      name: 'HTTP Status Reference',
      description:
          'Complete reference of HTTP status codes with descriptions and use cases.',
      category: ToolCategory.developer,
      icon: Icons.http,
      tags: ['http', 'status', 'codes', 'reference'],
      isAvailable: true,
      routePath: '/developer/http-status',
    ),
    ToolModel(
      id: 'lorem_ipsum',
      name: 'Lorem Ipsum Generator',
      description:
          'Generate lorem ipsum placeholder text in paragraphs, sentences, or words.',
      category: ToolCategory.developer,
      icon: Icons.text_fields,
      tags: ['lorem', 'ipsum', 'placeholder', 'text'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'fake_data_gen',
      name: 'Fake Data Generator',
      description:
          'Generate realistic fake names, emails, addresses, and other synthetic data.',
      category: ToolCategory.developer,
      icon: Icons.person_outlined,
      tags: ['fake', 'data', 'test', 'mock'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'gitignore_gen',
      name: '.gitignore Generator',
      description: 'Generate .gitignore files for common languages and IDEs.',
      category: ToolCategory.developer,
      icon: Icons.block_outlined,
      tags: ['git', 'gitignore', 'generate'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'json_csv_tool',
      name: 'JSON ↔ CSV Converter',
      description: 'Convert JSON arrays to CSV and vice versa.',
      category: ToolCategory.developer,
      icon: Icons.table_chart_outlined,
      tags: ['json', 'csv', 'convert', 'table'],
      isAvailable: false,
    ),
  ];
}
