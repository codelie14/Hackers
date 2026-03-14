# 📝 Hackers - Quick Start Guide

**Version:** 1.1.0-beta  
**Last Updated:** March 14, 2026

---

## 🎯 Current Status

You're currently at **v1.1.0-beta** with **32 functional tools** implemented (64% of MVP target).

### What's Ready ✅

- ✅ Complete Flutter architecture with Riverpod + GoRouter
- ✅ Professional dark terminal theme
- ✅ Multi-platform responsive UI (mobile drawer / desktop rail)
- ✅ 32 working tools across 5 categories
- ✅ Encrypted storage layer ready
- ✅ SQLite database configured

### Next Priority 🎯

Complete the remaining **18 tools** to reach 50-tool MVP:
1. **Crypto**: Argon2, BLAKE2, CRC checksum, Random key generator (4 tools)
2. **Password**: Mnemonic generator, Password history (2 tools)
3. **Encode/Decode**: HTML entities, Unicode escape, Base58, XOR cipher (4 tools)
4. **Developer**: Markdown previewer, SQL formatter, HTTP status reference (3 tools)
5. **QR Code**: Content analyzer, Custom designer (2 tools)

---

## 🚀 Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code (if needed)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App

```bash
# Android
flutter run

# iOS
flutter run -d ios

# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

---

## 📁 Project Structure

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp + ProviderScope
│
├── core/                              # Core infrastructure
│   ├── theme/
│   │   ├── app_theme.dart            # ✅ Complete theme system
│   │   └── app_colors.dart           # Color palette
│   ├── router/
│   │   └── app_router.dart           # ✅ Navigation routes
│   ├── storage/
│   │   ├── secure_storage.dart       # ✅ AES-256 encrypted storage
│   │   └── local_db.dart             # ✅ SQLite database
│   └── utils/
│       ├── clipboard_utils.dart      # Copy helpers
│       ├── format_utils.dart         # Formatting utilities
│       └── validators.dart           # Input validators
│
├── data/
│   ├── models/
│   │   ├── tool_model.dart           # Tool data model
│   │   └── history_entry.dart        # History tracking
│   └── tools_registry.dart           # ✅ 263 registered tools
│
├── features/                          # Feature modules
│   ├── home/
│   │   └── home_screen.dart          # Home screen
│   ├── category/
│   │   └── category_screen.dart      # Category browser
│   ├── crypto/                       # ✅ 9 tools implemented
│   │   ├── widgets/
│   │   └── providers/
│   ├── password/                     # ✅ 6 tools implemented
│   │   ├── widgets/
│   │   └── providers/
│   ├── encode_decode/                # ✅ 7 tools implemented
│   │   ├── widgets/
│   │   └── providers/
│   ├── developer/                    # ✅ 9 tools implemented
│   │   ├── widgets/
│   │   └── providers/
│   └── qr_barcode/                   # ✅ 1 tool implemented
│       ├── widgets/
│       └── providers/
│
└── shared/                            # Reusable components
    └── widgets/
        ├── app_scaffold.dart         # Responsive layout
        ├── category_drawer.dart      # Mobile navigation
        ├── tool_card.dart            # Tool display cards
        ├── result_box.dart           # Result display
        ├── copy_button.dart          # Copy with feedback
        ├── app_button.dart           # Primary action button
        ├── app_input.dart            # Themed input field
        ├── section_header.dart       # Section divider
        ├── code_display.dart         # Code blocks
        ├── loading_spinner.dart      # Loading states
        ├── app_badge.dart            # Category badges
        └── search_overlay.dart       # Global search
```

---

## 🛠️ Adding a New Tool

### Step 1: Create Widget

Create file in `lib/features/[category]/widgets/`:

```dart
// lib/features/crypto/widgets/example_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/*';

class ExampleWidget extends ConsumerStatefulWidget {
  const ExampleWidget({super.key});

  @override
  ConsumerState<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends ConsumerState<ExampleWidget> {
  // Your implementation
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Example Tool',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionHeader('Input'),
            // Your inputs
            AppButton('Execute ▶', onPressed: () {}),
            SectionHeader('Result'),
            ResultBox(content: 'result'),
          ],
        ),
      ),
    );
  }
}
```

### Step 2: Register in Tools Registry

Edit `lib/data/tools_registry.dart`:

```dart
ToolModel(
  id: 'example_tool',
  name: 'Example Tool',
  description: 'Description of what it does.',
  category: ToolCategory.crypto,
  icon: Icons.example,
  tags: ['example', 'tool'],
  isAvailable: true,
  routePath: '/category/crypto/example_tool',
),
```

### Step 3: Add Route

Edit `lib/core/router/app_router.dart`:

```dart
// Import your widget
import '../../features/crypto/widgets/example_widget.dart';

// Add route
GoRoute(
  path: '/crypto/example',
  builder: (_, __) => const ExampleWidget(),
),
```

### Step 4: Test

```bash
flutter run
```

Navigate to your tool and test functionality.

---

## 📊 Implementation Priority

### P0 (Critical for MVP)
Must implement these first:
- ✅ Hash functions (done)
- ✅ AES encryption (done)
- ✅ Password generation (done)
- ⏳ Password history encryption
- ⏳ QR phishing analyzer

### P1 (High Priority)
Important but can ship day-one post-launch:
- ⏳ Argon2 hash
- ⏳ Markdown previewer
- ⏳ Custom QR designer

### P2 (Medium Priority)
Nice-to-have for MVP:
- ⏳ BLAKE2 hash
- ⏳ Base58 encoding
- ⏳ SQL formatter

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Coverage report
flutter test --coverage
```

### Manual Testing Checklist

For each tool:
- [ ] Inputs accept expected values
- [ ] Execute button works
- [ ] Results display correctly
- [ ] Copy button copies result
- [ ] Share button shares result
- [ ] Error handling works
- [ ] Loading state shows during processing
- [ ] Haptic feedback on mobile
- [ ] Offline functionality confirmed

---

## 📦 Build for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
flutter build ios --release
```

Then open in Xcode for archive.

### macOS

```bash
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/`

### Windows

```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

### Linux

```bash
flutter build linux --release
```

Output: `build/linux/x64/release/bundle/`

---

## 🔧 Troubleshooting

### Build Issues

**Problem:** Dependency conflicts
```bash
flutter clean
flutter pub get
```

**Problem:** Code generation errors
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Runtime Issues

**Problem:** Route not found
- Check route path in `app_router.dart`
- Verify widget import
- Ensure tool has `routePath` in registry

**Problem:** Theme not applying
- Hot reload may be needed
- Check if using `AppTheme.darkTheme` in `app.dart`

**Problem:** Storage not working
- Ensure platform permissions are set
- Check `flutter_secure_storage` initialization

---

## 📚 Documentation

### Main Documents

- **[README.md](README.md)** — Project overview and installation
- **[ROADMAP.md](ROADMAP.md)** — Product roadmap and timeline
- **[CHANGELOG.md](CHANGELOG.md)** — Version history
- **[IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)** — Detailed progress report
- **[docs/hackers_offline_features.md](docs/hackers_offline_features.md)** — Full feature spec

### Code References

- **Theme**: `lib/core/theme/app_theme.dart`
- **Routes**: `lib/core/router/app_router.dart`
- **Tools Registry**: `lib/data/tools_registry.dart`
- **Shared Widgets**: `lib/shared/widgets/`

---

## 🤝 Contributing

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/add-example-tool

# Make changes and commit
git add .
git commit -m "feat: add Example Tool to Crypto category"

# Push branch
git push origin feature/add-example-tool

# Open Pull Request on GitHub
```

### Commit Message Format

```
feat:     new tool or feature
fix:      bug fix
style:    UI/UX changes without logic
refactor: code refactoring
docs:     documentation updates
test:     adding or updating tests
```

---

## 📞 Support

### Getting Help

- **GitHub Issues:** Report bugs and request features
- **GitHub Discussions:** Ask questions and share ideas
- **Documentation:** Check README and ROADMAP

### Common Questions

**Q: When will v1.1.0 be released?**  
A: Target is end of March 2026 when we reach 50 tools.

**Q: Can I contribute?**  
A: Yes! Check IMPLEMENTATION_STATUS.md for tools needing implementation.

**Q: Will this work offline?**  
A: Yes! All MVP tools are 100% offline. No network calls.

**Q: Which platforms are supported?**  
A: Android, iOS, macOS, Windows, and Linux.

---

## 🎯 Next Steps

### This Week
1. Implement HTML entities encoder/decoder
2. Implement Unicode escape converter
3. Implement Base58 (Bitcoin) encoder
4. Implement XOR cipher tool

### Next Week
1. Build mnemonic generator
2. Build password history with encryption
3. Build markdown previewer
4. Write unit tests for crypto providers

---

**Ready to build?** Pick a tool from the priority list and start coding! 🚀

---

*Last updated: March 14, 2026*  
*Maintained by: Archange Elie Yatte*
