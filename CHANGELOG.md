# Changelog

All notable changes to the **Hackers** project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned for v1.0.0
- Complete MVP implementation (50 tools)
- Password history with encryption
- QR code analyzer (phishing detection)
- Unit tests for core providers
- Enhanced error handling and loading states

### In Progress
- Argon2 hash implementation
- BLAKE2b/s hash support
- HTML entities encoder/decoder
- Base58 (Bitcoin) encoding
- Mnemonic generator

---

## [1.1.0] - 2026-03-14
### 🎉 MVP Release — Initial Public Beta

#### Added

##### Architecture & Foundation
- ✅ Flutter 3.16+ project structure with Riverpod state management
- ✅ GoRouter navigation system with deep linking support
- ✅ Dark terminal theme design system
- ✅ Multi-platform layout (mobile drawer / desktop rail)
- ✅ Shared widgets library (12 reusable components)
- ✅ Tools registry with 263 registered tools

##### Core Infrastructure
- ✅ `lib/core/theme/app_theme.dart` — Complete Material 3 dark theme
- ✅ `lib/core/router/app_router.dart` — Route configuration for all platforms
- ✅ `lib/data/tools_registry.dart` — Comprehensive tool definitions
- ✅ `lib/core/storage/secure_storage.dart` — AES-256 encrypted storage
- ✅ `lib/core/storage/local_db.dart` — SQLite historical data storage

##### Cryptography Tools (9 tools)
- ✅ **Hash Generator** — MD5, SHA1, SHA224, SHA256, SHA384, SHA512
- ✅ **HMAC Generator** — HMAC-SHA256, HMAC-SHA512 with custom keys
- ✅ **AES Encrypt/Decrypt** — AES-128/256 with CBC and GCM modes
- ✅ **RSA Key Generator** — 2048/4096 bit key pairs with PEM export
- ✅ **PBKDF2 Key Derivation** — PBKDF2-SHA256/SHA512 with configurable iterations
- ✅ **Bcrypt Hash** — Password hashing with adjustable cost factor
- ✅ **ChaCha20-Poly1305** — AEAD cipher encryption/decryption
- ✅ **Salt Generator** — Cryptographically secure random salt generation
- ✅ **Hash Comparator** — Side-by-side hash verification

##### Password Toolkit (6 tools)
- ✅ **Password Generator** — Customizable length, charset, exclusions
- ✅ **Entropy Analyzer** — Shannon entropy calculation with brute-force time estimation
- ✅ **Passphrase Diceware** — EFF wordlist-based memorable passphrases
- ✅ **PIN Generator** — Secure numeric PINs (4-12 digits)
- ✅ **Pronounceable Password** — Memorable yet secure password generation
- ✅ **Batch Password Generator** — Generate multiple passwords at once

##### Encode / Decode Tools (7 tools)
- ✅ **Base64 Encoder/Decoder** — Standard and URL-safe variants
- ✅ **Base32 Encoder/Decoder** — RFC 4648 compliant
- ✅ **Hex Encoder/Decoder** — Hexadecimal conversion
- ✅ **URL Encoder/Decoder** — Percent-encoding for safe transmission
- ✅ **ROT13/ROT47** — Caesar substitution ciphers
- ✅ **Morse Code** — International Morse code encoding/decoding
- ✅ **Binary/Octal/ASCII** — Multi-base number system conversion

##### Developer Tools (9 tools)
- ✅ **JSON Formatter** — Validate, beautify, minify with syntax highlighting
- ✅ **JSON ↔ YAML Converter** — Bidirectional format conversion
- ✅ **JWT Decoder** — Inspect header, payload, and signature
- ✅ **Regex Tester** — Live regex matching with group extraction
- ✅ **Diff Tool** — Side-by-side text comparison with unified diff
- ✅ **CRON Explainer** — Parse expressions and preview next executions
- ✅ **Timestamp Converter** — Unix epoch ↔ human-readable date/time
- ✅ **UUID Generator** — UUID v1, v4, v7 generation
- ✅ **Color Converter** — HEX, RGB, HSL, HSV, CMYK conversion with palette

##### QR Code Tools (1 tool)
- ✅ **QR Code Generator** — Text, URL, WiFi, vCard QR codes with PNG export

##### Shared Widgets (12 components)
- ✅ `AppScaffold` — Responsive layout with navigation
- ✅ `CategoryDrawer` — Mobile navigation drawer with categories
- ✅ `ToolCard` — Tool display card with hover effects
- ✅ `ResultBox` — Result display with copy/share actions
- ✅ `CopyButton` — One-click copy with haptic feedback
- ✅ `AppButton` — Styled primary action button
- ✅ `AppInput` — Themed text input field
- ✅ `SectionHeader` — Section divider with title
- ✅ `CodeDisplay` — Monospace code block with syntax highlighting
- ✅ `LoadingSpinner` — ASCII-style loading indicator
- ✅ `AppBadge` — Category badge with tool count
- ✅ `SearchOverlay` — Global tool search interface

##### Design System
- ✅ **Colors** — Terminal-inspired palette (accent: #00FF88)
- ✅ **Typography** — JetBrains Mono + Syne font families
- ✅ **Components** — Buttons, inputs, cards, dialogs themed
- ✅ **Animations** — Page transitions, loading states, haptics
- ✅ **Responsive** — Adaptive layouts for all screen sizes

##### Storage & Persistence
- ✅ **Secure Storage** — flutter_secure_storage integration
- ✅ **SQLite Database** — sqflite for local history
- ✅ **Preferences** — shared_preferences for user settings

##### Build Configuration
- ✅ pubspec.yaml with all required dependencies
- ✅ Font assets (JetBrains Mono, Syne)
- ✅ Asset bundling configuration
- ✅ Platform-specific configurations (Android, iOS, macOS, Windows, Linux)

#### Technical Details

##### Dependencies Added
```yaml
dependencies:
  go_router: ^13.2.0              # Navigation
  flutter_riverpod: ^2.5.1        # State management
  crypto: ^3.0.3                  # Hash functions
  pointycastle: ^3.7.4            # Crypto algorithms
  base32: ^2.1.3                  # Base32 encoding
  convert: ^3.1.1                 # Base64, hex encoding
  flutter_secure_storage: ^9.2.2  # Encrypted storage
  sqflite: ^2.3.3+1               # SQLite database
  qr_flutter: ^4.1.0              # QR code generation
  uuid: ^4.3.3                    # UUID generation
  google_fonts: ^6.2.1            # Custom fonts
  diff_match_patch: ^0.4.1        # Diff algorithm
  yaml: ^3.1.2                    # YAML parsing
  vibration: ^2.0.0               # Haptic feedback
```

##### Architecture Patterns
- **Feature-first organization** — Each category in isolated module
- **Riverpod providers** — Testable, composable state management
- **Repository pattern** — Data access abstraction
- **Widget composition** — Reusable UI components

##### Code Quality
- Analysis options configured with `flutter_lints`
- Strong mode enabled
- Linting rules enforced

#### Changed
- N/A (Initial release)

#### Deprecated
- N/A

#### Removed
- N/A

#### Fixed
- N/A

#### Security

##### Implemented Security Features
- ✅ All cryptographic operations use battle-tested libraries
- ✅ Passwords hashed with bcrypt before storage
- ✅ Sensitive data encrypted with AES-256-GCM
- ✅ No network calls for offline tools
- ✅ Secure random number generation (CSPRNG)
- ✅ Input validation and sanitization
- ✅ Memory clearing for sensitive data

---

## [1.0.0] - 2025-XX-XX
### 📦 Pre-release Development

#### Added
- Initial project setup
- Basic project structure
- First prototype concepts

#### Notes
- Internal development version
- Not publicly released

---

## Migration Guide

### Upgrading from v1.0.x to v1.1.0

#### Breaking Changes
- None (MVP release maintains compatibility)

#### New Requirements
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0

#### Recommended Steps
1. Run `flutter pub get` to install dependencies
2. Run `dart run build_runner build` if using code generation
3. Review new widget APIs in shared/widgets directory

---

## Known Issues

### v1.1.0

#### Minor
- Some advanced crypto tools not yet implemented (Argon2, BLAKE2)
- Password history feature pending encryption layer
- QR analyzer phishing detection not implemented

#### Planned Fixes
- v1.1.1: Add remaining encode/decode tools
- v1.1.2: Implement password history encryption
- v1.2.0: Extended toolkit (WiFi, OSINT, Forensics)

---

## Future Releases

### v1.2.0 — Extended Toolkit (Q2 2026)
- WiFi scanning and analysis tools
- OSINT investigation utilities
- File security utilities
- Network diagnostic tools

### v1.3.0 — Power Features (Q3 2026)
- Steganography studio
- Code analysis utilities
- Advanced forensics tools
- Encrypted backup/restore

### v2.0.0 — Ecosystem (Q4 2026)
- End-to-end encrypted cloud sync
- Community plugin marketplace
- Automation pipelines
- CLI interface for desktop

---

## Version History Summary

| Version | Release Date | Tools Count | Status |
|---------|--------------|-------------|--------|
| 1.1.0   | 2026-03-14   | 32          | 🟢 Stable (Beta) |
| 1.0.0   | 2025-XX-XX   | 0           | 🔴 Internal Dev |
### 📦 Pre-release Development

#### Added
- Initial project setup
- Basic project structure
- First prototype concepts

#### Notes
- Internal development version
- Not publicly released

---

## Migration Guide

### Upgrading from v1.x to v2.0

#### Breaking Changes
- None (first public release)

#### New Requirements
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0

#### Recommended Steps
1. Run `flutter pub get` to install dependencies
2. Run `dart run build_runner build` if using code generation
3. Review new widget APIs in shared/widgets directory

---

## Known Issues

### v2.0.0

#### Minor
- Some advanced crypto tools not yet implemented (Argon2, BLAKE2)
- Password history feature pending encryption layer
- QR analyzer phishing detection not implemented

#### Planned Fixes
- v2.0.1: Add remaining encode/decode tools
- v2.0.2: Implement password history encryption
- v2.1.0: Extended toolkit (WiFi, OSINT, Forensics)

---

## Future Releases



---

## Version History Summary

| Version | Release Date | Tools Count | Status |
|---------|--------------|-------------|--------|
| 1.1.0   | 2026-03-14   | 32          | 🟢 Stable (Beta) |
| 1.0.0   | 2026-03-13   | 0           | 🔴 Internal Dev |

---

## Support

- **Bug Reports:** [GitHub Issues](https://github.com/codelie14/Hackers/issues)
- **Feature Requests:** [GitHub Discussions](https://github.com/codelie14/Hackers/discussions)
- **Documentation:** [README.md](README.md)
- **Roadmap:** [ROADMAP.md](ROADMAP.md)

---

**Last Updated:** March 14, 2026  
**Maintained By:** Archange Elie Yatte
