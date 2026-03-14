<div align="center">

<!-- Logo -->
<img src="assets/images/hackers_logo.svg" alt="Hackers Logo" width="240" height="240"/>

# HACKERS

### Offline Security Toolkit

**Une boîte à outils de cybersécurité complète — offline, mobile & desktop**

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-00FF88?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-00CC66?style=flat-square)](https://flutter.dev/multi-platform)
[![Version](https://img.shields.io/badge/Version-1.1.0-00FF88?style=flat-square)](CHANGELOG.md)

---

*Développé par **Archange Elie Yatte** — [IndraLabs](https://archangeyatte.vercel.app)*

</div>

---

## 📖 Table des matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Captures d'écran](#-captures-décran)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Lancer le projet](#-lancer-le-projet)
- [Architecture](#-architecture)
- [Contribuer](#-contribuer)
- [Roadmap](#-roadmap)
- [Licence](#-licence)

---

## 🔥 À propos

**Hackers** est une application **offline-first** destinée aux informaticiens, développeurs et professionnels de la cybersécurité. Elle regroupe **plus de 350 outils techniques** organisés en 15 catégories, accessibles sans aucune connexion internet.

> "Tout ce dont tu as besoin, dans ta poche. Sans connexion. Sans compromis."

### Pourquoi Hackers ?

- **100% offline** — aucune donnée ne quitte ton appareil
- **Multi-plateforme** — Android, iOS, macOS, Windows, Linux
- **Stockage chiffré** — les données sensibles sont protégées localement (AES-256)
- **Outil unique** — remplace des dizaines d'applications et sites web
- **Open source** — transparent, auditable, contributif

---

## ⚡ Fonctionnalités

> 350+ outils répartis en 15 catégories

| # | Catégorie | Nb. d'outils | Highlight |
|---|-----------|:---:|---|
| 1 | 🔐 Cryptographie | 50+ | AES, RSA, ECDSA, ChaCha20, BLAKE3, Ed25519 |
| 2 | 🔑 Password Toolkit | 20+ | Générateur, entropie, Diceware, zxcvbn |
| 3 | 🔄 Encode / Decode | 30+ | Base64, Base58, Morse, Punycode, ROT47 |
| 4 | 📁 File Security | 15+ | Hash fichier, magic bytes, analyse PE/ELF |
| 5 | 🌐 Network Tools | 40+ | CIDR, DNS, Port Scanner, SSL/TLS, iptables |
| 6 | 📶 WiFi Tools | 15+ | RSSI, canal optimal, QR WiFi, WPA3 |
| 7 | 🛠️ Developer Tools | 50+ | JSON, JWT, Regex, Diff, CRON, SQL, UUID |
| 8 | 🔢 Encoding Utilities | 25+ | UUID v7, ULID, OTP, TOTP, PEM↔JWK |
| 9 | 🔍 Forensics Tools | 30+ | EXIF, Hex Dump, Stéganographie, Entropie |
| 10 | 💻 System Tools | 20+ | CPU/RAM, ARP, netstat, audit SSH/sudo |
| 11 | 🕵️ OSINT Tools | 25+ | Dorks, extracteurs, typosquatting, wordlist |
| 12 | 🎨 Steganography Studio | 12+ | LSB, audio, PDF, watermarking |
| 13 | 🧬 Code Analysis | 15+ | Détection secrets, CVE, désobfuscation |
| 14 | 📱 QR Code & Barcode | 12+ | QR, EAN-13, PDF417, export SVG/PNG |
| 15 | 🛡️ Privacy & Anti-Tracking | 15+ | Anonymisation, nettoyeur URLs, fingerprint |

---

## 📸 Captures d'écran

> *(à venir après la première build)*

| Accueil | Cryptographie | Developer Tools |
|---------|--------------|-----------------|
| *soon*  | *soon*       | *soon*          |

---

## 🛠️ Prérequis

Avant de commencer, assure-toi d'avoir installé :

| Outil | Version minimale | Lien |
|-------|:---:|------|
| Flutter SDK | 3.16.0 | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.2.0 | inclus avec Flutter |
| Android Studio / Xcode | dernière | pour les simulateurs |
| Git | 2.x | [git-scm.com](https://git-scm.com) |

Vérifie ton environnement Flutter :
```bash
flutter doctor
```

---

## 📦 Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/codelie14/Hackers.git
cd hackers
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Générer les fichiers Riverpod (code generation)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Vérifier les assets

Assure-toi que les fichiers suivants sont présents :

```
assets/
├── logo/
│   └── hackers_logo.svg
└── data/
    ├── wordlist_diceware.txt
    └── common_passwords.txt
```

---

## 🚀 Lancer le projet

### Android

```bash
flutter run -d android
```

### iOS

```bash
flutter run -d ios
```

### macOS

```bash
flutter run -d macos
```

### Windows

```bash
flutter run -d windows
```

### Linux

```bash
flutter run -d linux
```

### Build de production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

---

## 🗂️ Architecture

Le projet suit une architecture **Feature-First** avec **Riverpod** pour la gestion d'état.

```
lib/
├── main.dart                    # Point d'entrée
├── app.dart                     # MaterialApp + GoRouter + ProviderScope
│
├── core/                        # Couche transversale
│   ├── theme/                   # ThemeData, couleurs, typographie
│   ├── router/                  # GoRouter — routes de l'app
│   ├── storage/                 # SQLite + flutter_secure_storage
│   └── utils/                   # Helpers globaux
│
├── data/
│   ├── models/                  # Tool, HistoryEntry...
│   └── tools_registry.dart      # Registre des 350+ outils
│
├── features/                    # Un dossier par catégorie
│   ├── crypto/
│   │   ├── providers/           # Riverpod providers
│   │   ├── screens/             # Pages Flutter
│   │   └── widgets/             # Widgets d'outils
│   ├── password/
│   ├── encode_decode/
│   └── ...                      # 15 catégories au total
│
└── shared/
    └── widgets/                 # Composants UI réutilisables
        ├── app_scaffold.dart
        ├── result_box.dart
        ├── copy_button.dart
        └── ...
```

### Packages principaux

| Package | Usage |
|---------|-------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `pointycastle` | AES, RSA, ECDSA, PBKDF2 |
| `crypto` | MD5, SHA1, SHA256, SHA512, HMAC |
| `cryptography` | ChaCha20, Ed25519, X25519, AES-GCM |
| `flutter_secure_storage` | Stockage chiffré des secrets |
| `sqflite` | Historique local SQLite |
| `qr_flutter` | Génération QR Code |
| `flutter_svg` | Affichage du logo SVG |
| `diff_match_patch` | Outil Diff |

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Voici comment participer :

### Workflow

```bash
# 1. Fork le projet
# 2. Crée ta branche
git checkout -b feature/nom-de-loutil

# 3. Commit tes changements
git commit -m "feat: ajout outil [NomOutil] dans [Categorie]"

# 4. Push
git push origin feature/nom-de-loutil

# 5. Ouvre une Pull Request
```

### Convention de commits

```
feat:     nouvel outil ou fonctionnalité
fix:      correction de bug
style:    modification UI/UX sans logique
refactor: refactoring sans changement de comportement
docs:     mise à jour documentation
test:     ajout ou modification de tests
```

### Ajouter un nouvel outil

1. Crée le widget dans `lib/features/[categorie]/widgets/`
2. Enregistre-le dans `lib/data/tools_registry.dart`
3. Ajoute la route dans `lib/core/router/app_router.dart`
4. Teste offline (aucun appel réseau non déclaré)

---

## 🗺️ Roadmap

> 📊 **Current Progress:** 32/50 MVP tools implemented (64%)

### ✅ v1.1.0 — MVP Release (March 2026)

**Status:** 🟢 Beta Ready

#### Completed Features
- [x] Architecture Flutter + Riverpod
- [x] Design system dark terminal
- [x] Navigation multi-plateforme
- [x] 32 outils implémentés et fonctionnels

#### Cryptographie (9/15 outils)
- [x] Hash Generator (MD5, SHA1, SHA256, SHA512)
- [x] HMAC Generator (SHA256, SHA512)
- [x] AES Encrypt/Decrypt (CBC, GCM)
- [x] RSA Key Generator (2048/4096 bits)
- [x] PBKDF2 Key Derivation
- [x] Bcrypt Hash
- [x] ChaCha20-Poly1305
- [x] Salt Generator
- [x] Hash Comparator
- [ ] Argon2 Hash *(v1.1.1)*
- [ ] BLAKE2b/s Hash *(v1.1.1)*
- [ ] CRC Checksum *(v1.1.1)*
- [ ] Random Key Generator *(v1.1.1)*

#### Password Toolkit (6/8 outils)
- [x] Password Generator
- [x] Entropy Analyzer
- [x] Passphrase Diceware
- [x] PIN Generator
- [x] Pronounceable Password
- [x] Batch Password Generator
- [ ] Mnemonic Generator *(v1.1.1)*
- [ ] Password History *(v1.1.2)*

#### Encode / Decode (7/12 outils)
- [x] Base64 Encode/Decode
- [x] Base32 Encode/Decode
- [x] Hex Encode/Decode
- [x] URL Encode/Decode
- [x] ROT13 / ROT47
- [x] Morse Code
- [x] Binary / Octal / ASCII
- [ ] HTML Entities *(v1.1.1)*
- [ ] Unicode Escape *(v1.1.1)*
- [ ] Base58 (Bitcoin) *(v1.1.1)*
- [ ] XOR Cipher *(v1.1.1)*

#### Developer Tools (9/12 outils)
- [x] JSON Formatter / Validator
- [x] JSON ↔ YAML Converter
- [x] JWT Decoder
- [x] Regex Tester
- [x] Diff Tool
- [x] CRON Explainer
- [x] Timestamp Converter
- [x] UUID Generator (v1, v4, v7)
- [x] Color Converter (HEX/RGB/HSL/HSV/CMYK)
- [ ] Markdown Previewer *(v1.1.2)*
- [ ] SQL Formatter *(v1.1.2)*
- [ ] HTTP Status Reference *(v1.1.2)*

#### QR Code & Barcode (1/3 outils)
- [x] QR Code Generator
- [ ] QR Content Analyzer *(v1.1.2)*
- [ ] Custom QR Designer *(v1.1.2)*

---

### 🔜 v1.2.0 — Extended Toolkit (Q2 2026)

**Focus:** File Security, Network, and System Tools

- [ ] File Security (File Hash Calculator, Magic Bytes Analyzer)
- [ ] Network Tools (CIDR Calculator, DNS Lookup, Port Scanner)
- [ ] System Information (CPU/RAM Monitor, Network Info)
- [ ] Forensics (EXIF Extractor, Hex Dump Viewer)
- [ ] Encoding Utils (TOTP Generator, SSH Key Generator)
- [ ] Privacy Tools (PII Masker, URL Tracker Stripper)

---

### 🚀 v1.3.0 — Power Features (Q3 2026)

**Focus:** Advanced analysis and automation

- [ ] Steganography Studio (LSB Encode/Decode, Bit Plane Visualizer)
- [ ] Code Analysis (Secret Detector, Dependency Analyzer)
- [ ] WiFi Tools (WiFi Scanner, Channel Optimizer)
- [ ] OSINT Tools (Google Dorks, Data Extractors)
- [ ] Encrypted Backup/Restore
- [ ] Keyboard Shortcuts (Desktop)

---

### 🌟 v2.0.0 — Ecosystem (Q4 2026)

**Focus:** Cloud sync and extensibility

- [ ] End-to-End Encrypted Cloud Sync
- [ ] Automation Pipelines (Tool Chaining)
- [ ] Plugin Marketplace
- [ ] CLI Version (Desktop)
- [ ] Custom Themes
- [ ] Scripting API

---

📝 **See detailed roadmap:** [ROADMAP.md](ROADMAP.md)

---

## 📄 Licence

---

<div align="center">

**Hackers v1.0** — construit avec ❤️ par [Archange Elie Yatte](https://archangeyatte.vercel.app) — [GitHub](https://github.com/codelie14/Hackers)

`[ offline. secure. open. ]`

</div>