# Tools Registry - Modular Architecture

## 📁 Structure

The tools registry is now organized in a modular structure for better maintainability and scalability.

```
lib/data/
├── tools_registry.dart              # Main entry point - aggregates all categories
├── categories/
│   ├── crypto_tools.dart            # Cryptography (28 tools)
│   ├── password_tools.dart          # Password Toolkit (8 tools)
│   ├── encode_decode_tools.dart     # Encode/Decode (17 tools)
│   ├── file_security_tools.dart     # File Security (7 tools)
│   ├── network_tools.dart           # Network Tools (11 tools)
│   ├── wifi_tools.dart              # WiFi Tools (5 tools)
│   ├── developer_tools.dart         # Developer Tools (16 tools)
│   ├── system_tools.dart            # System Tools (6 tools)
│   ├── forensics_tools.dart         # Forensics (8 tools)
│   ├── osint_tools.dart             # OSINT (7 tools)
│   ├── steganography_tools.dart     # Steganography (5 tools)
│   ├── code_analysis_tools.dart     # Code Analysis (7 tools)
│   ├── qr_barcode_tools.dart        # QR Code & Barcode (5 tools)
│   ├── privacy_tools.dart           # Privacy & Anti-tracking (6 tools)
│   └── encoding_utils_tools.dart    # Encoding Utilities (7 tools)
```

## 🎯 Benefits

### 1. **Maintainability**
- Each category file has a single responsibility
- Easier to find and update specific tools
- Reduced merge conflicts in Git

### 2. **Scalability**
- Can easily add new categories without bloating main file
- Each category can grow independently
- Clear separation of concerns

### 3. **Readability**
- Smaller, focused files (50-300 lines vs 1400+ lines)
- Better code organization
- Easier onboarding for new developers

### 4. **Performance**
- Dart only imports what's needed
- Faster IDE indexing
- Better code caching

## 📊 Statistics

| Category | Tools Count | File Size |
|----------|-------------|-----------|
| Crypto | 28 | ~313 lines |
| Password | 8 | ~102 lines |
| Encode/Decode | 17 | ~184 lines |
| Developer | 16 | ~180 lines |
| Network | 11 | ~131 lines |
| Forensics | 8 | ~91 lines |
| OSINT | 7 | ~85 lines |
| Code Analysis | 7 | ~84 lines |
| Encoding Utils | 7 | ~84 lines |
| File Security | 7 | ~83 lines |
| System | 6 | ~74 lines |
| Privacy | 6 | ~75 lines |
| Steganography | 5 | ~65 lines |
| QR & Barcode | 5 | ~66 lines |
| WiFi | 5 | ~64 lines |
| **TOTAL** | **148 tools** | **~1,686 lines** |

## 🔧 Usage

All tools are accessible through the main `ToolsRegistry` class:

```dart
// Get all tools
final allTools = ToolsRegistry.all;

// Filter by category
final cryptoTools = ToolsRegistry.byCategory(ToolCategory.crypto);

// Get available tools only
final availableTools = ToolsRegistry.available();

// Search tools
final hashTools = ToolsRegistry.search('hash');
```

## 📝 Adding New Tools

1. Find the appropriate category file in `lib/data/categories/`
2. Add your new `ToolModel` to the `all` list
3. Ensure the `routePath` matches a registered route in `app_router.dart`
4. Set `isAvailable: true` if the widget exists

Example:
```dart
ToolModel(
  id: 'my_new_tool',
  name: 'My New Tool',
  description: 'Description of what it does',
  category: ToolCategory.crypto,
  icon: Icons.security,
  tags: ['tag1', 'tag2'],
  isAvailable: true,
  routePath: '/crypto/my-new-tool',
),
```

## 🏗️ Architecture

Each category file follows the same pattern:

```dart
import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// CATEGORY NAME TOOLS
/// Description of the category
/// ────────────────────────────────────────────────────────────

class CategoryTools {
  CategoryTools._();

  static const List<ToolModel> all = [
    // Tool definitions here
  ];
}
```

The main `tools_registry.dart` uses spread operator (`...`) to combine all categories:

```dart
static List<ToolModel> get all => [
  ...CryptoTools.all,
  ...PasswordTools.all,
  // ... etc
];
```

---

**Last Updated:** March 14, 2026  
**Version:** v1.1.0-beta
