import 'package:flutter/material.dart';
import 'models/tool_model.dart';

// ─── Route IDs ─────────────────────────────────────────────
// Implemented tools have a routePath matching a screen widget that exists.
// All others are shown as "COMING SOON" cards in the category screen.

class ToolsRegistry {
  ToolsRegistry._();

  static const List<ToolModel> all = [
    // ═══════════════════════════════════════════════════════
    // 1. CRYPTOGRAPHY
    // ═══════════════════════════════════════════════════════

    // Hashing — MVP implemented
    ToolModel(id: 'hash_generator', name: 'Hash Generator', description: 'Generate MD5, SHA1, SHA224, SHA256, SHA384, SHA512 hashes from any text input.', category: ToolCategory.crypto, icon: Icons.fingerprint, tags: ['hash', 'md5', 'sha', 'sha256', 'digest'], isAvailable: true, routePath: '/category/crypto/hash_generator'),
    ToolModel(id: 'hmac_generator', name: 'HMAC Generator', description: 'Generate HMAC-SHA256 and HMAC-SHA512 message authentication codes.', category: ToolCategory.crypto, icon: Icons.verified_outlined, tags: ['hmac', 'sha256', 'sha512', 'mac'], isAvailable: true, routePath: '/category/crypto/hmac_generator'),
    ToolModel(id: 'hash_comparator', name: 'Hash Comparator', description: 'Compare two hash values to verify integrity. Supports all common algorithms.', category: ToolCategory.crypto, icon: Icons.compare_arrows, tags: ['compare', 'hash', 'verify'], isAvailable: true, routePath: '/category/crypto/hash_comparator'),
    ToolModel(id: 'bcrypt_hash', name: 'Bcrypt Hash', description: 'Generate and verify Bcrypt password hashes with configurable cost factor.', category: ToolCategory.crypto, icon: Icons.enhanced_encryption, tags: ['bcrypt', 'password', 'hash'], isAvailable: false),
    ToolModel(id: 'argon2_hash', name: 'Argon2 Hash', description: 'Argon2id memory-hard password hashing function.', category: ToolCategory.crypto, icon: Icons.enhanced_encryption, tags: ['argon2', 'password', 'hash'], isAvailable: false),
    ToolModel(id: 'salt_generator', name: 'Salt Generator', description: 'Generate cryptographically secure random salts of configurable length.', category: ToolCategory.crypto, icon: Icons.grain, tags: ['salt', 'random', 'crypto'], isAvailable: false),
    ToolModel(id: 'blake2b_hash', name: 'BLAKE2b Hash', description: 'High-speed cryptographic hash using BLAKE2b algorithm.', category: ToolCategory.crypto, icon: Icons.fingerprint, tags: ['blake2', 'hash'], isAvailable: false),
    ToolModel(id: 'blake2s_hash', name: 'BLAKE2s Hash', description: 'BLAKE2s — optimized for 8 to 32-bit platforms.', category: ToolCategory.crypto, icon: Icons.fingerprint, tags: ['blake2', 'hash'], isAvailable: false),
    ToolModel(id: 'ripemd160_hash', name: 'RIPEMD-160 Hash', description: 'RIPEMD-160 cryptographic hash function used in Bitcoin.', category: ToolCategory.crypto, icon: Icons.fingerprint, tags: ['ripemd', 'hash', 'bitcoin'], isAvailable: false),
    ToolModel(id: 'keccak256_hash', name: 'Keccak-256 Hash', description: 'Keccak-256 / SHA3-256 hash used in Ethereum smart contracts.', category: ToolCategory.crypto, icon: Icons.fingerprint, tags: ['keccak', 'sha3', 'ethereum', 'hash'], isAvailable: false),
    ToolModel(id: 'crc_checksum', name: 'CRC Checksum', description: 'Compute CRC16, CRC32, and CRC64 checksums for data integrity.', category: ToolCategory.crypto, icon: Icons.rule, tags: ['crc', 'checksum', 'integrity'], isAvailable: false),
    ToolModel(id: 'adler32_checksum', name: 'Adler-32 Checksum', description: 'Fast Adler-32 checksum algorithm used in zlib.', category: ToolCategory.crypto, icon: Icons.rule, tags: ['adler', 'checksum'], isAvailable: false),

    // Encryption — MVP implemented  
    ToolModel(id: 'aes_tool', name: 'AES Encrypt / Decrypt', description: 'AES-128/256 encryption with CBC and GCM modes. Secure symmetric encryption.', category: ToolCategory.crypto, icon: Icons.lock, tags: ['aes', 'encrypt', 'decrypt', 'cbc', 'gcm'], isAvailable: true, routePath: '/category/crypto/aes_tool'),
    ToolModel(id: 'rsa_tool', name: 'RSA Key Generator', description: 'Generate RSA 2048/4096 bit key pairs. Supports PEM export format.', category: ToolCategory.crypto, icon: Icons.vpn_key, tags: ['rsa', 'keys', 'asymmetric', 'pem'], isAvailable: true, routePath: '/category/crypto/rsa_tool'),
    ToolModel(id: 'pbkdf2_tool', name: 'PBKDF2 Key Derivation', description: 'Derive cryptographic keys from passwords using PBKDF2-SHA256/SHA512.', category: ToolCategory.crypto, icon: Icons.key, tags: ['pbkdf2', 'kdf', 'key', 'derivation'], isAvailable: true, routePath: '/category/crypto/pbkdf2_tool'),
    ToolModel(id: 'chacha20_tool', name: 'ChaCha20-Poly1305', description: 'Encrypt and decrypt using ChaCha20-Poly1305 AEAD cipher.', category: ToolCategory.crypto, icon: Icons.lock_outline, tags: ['chacha20', 'poly1305', 'encrypt'], isAvailable: false),
    ToolModel(id: 'rsa_encrypt', name: 'RSA Encrypt / Decrypt', description: 'Encrypt and decrypt messages using RSA public/private key pairs.', category: ToolCategory.crypto, icon: Icons.lock_person, tags: ['rsa', 'encrypt', 'decrypt'], isAvailable: false),
    ToolModel(id: 'random_key_gen', name: 'Random Key Generator', description: 'Generate cryptographically secure random 256-bit or 512-bit keys.', category: ToolCategory.crypto, icon: Icons.shuffle, tags: ['random', 'key', 'csprng'], isAvailable: false),
    ToolModel(id: 'hkdf_tool', name: 'HKDF Key Derivation', description: 'HMAC-based Extract-and-Expand Key Derivation Function.', category: ToolCategory.crypto, icon: Icons.key, tags: ['hkdf', 'kdf', 'derivation'], isAvailable: false),
    ToolModel(id: 'triple_des', name: '3DES Encrypt / Decrypt', description: 'Triple DES symmetric block cipher for legacy compatibility.', category: ToolCategory.crypto, icon: Icons.lock_outline, tags: ['3des', 'des', 'encrypt'], isAvailable: false),
    ToolModel(id: 'blowfish_tool', name: 'Blowfish Cipher', description: 'Blowfish symmetric block cipher encryption and decryption.', category: ToolCategory.crypto, icon: Icons.lock_outline, tags: ['blowfish', 'encrypt'], isAvailable: false),
    ToolModel(id: 'vigenere_cipher', name: 'Vigenère Cipher', description: 'Classical polyalphabetic substitution cipher.', category: ToolCategory.crypto, icon: Icons.abc, tags: ['vigenere', 'cipher', 'classical'], isAvailable: false),
    ToolModel(id: 'caesar_cipher', name: 'Caesar Cipher', description: 'Caesar shift cipher — encode and decode with any shift value.', category: ToolCategory.crypto, icon: Icons.abc, tags: ['caesar', 'cipher', 'shift'], isAvailable: false),
    ToolModel(id: 'otp_generator', name: 'One-Time Pad', description: 'Generate and apply a one-time pad for perfect secrecy.', category: ToolCategory.crypto, icon: Icons.password, tags: ['otp', 'one-time-pad', 'encrypt'], isAvailable: false),

    // Signatures & Certificates
    ToolModel(id: 'ecdsa_keys', name: 'ECDSA Key Generator', description: 'Generate ECDSA key pairs for digital signatures.', category: ToolCategory.crypto, icon: Icons.vpn_key_outlined, tags: ['ecdsa', 'keys', 'signature'], isAvailable: false),
    ToolModel(id: 'ed25519_keys', name: 'Ed25519 Key Generator', description: 'Generate Ed25519 keys for EdDSA digital signatures.', category: ToolCategory.crypto, icon: Icons.vpn_key_outlined, tags: ['ed25519', 'keys', 'signature'], isAvailable: false),
    ToolModel(id: 'x509_analyzer', name: 'X.509 Certificate Analyzer', description: 'Parse and inspect X.509 certificates in PEM or DER format.', category: ToolCategory.crypto, icon: Icons.workspace_premium, tags: ['x509', 'certificate', 'pem', 'tls'], isAvailable: false),
    ToolModel(id: 'msg_signature', name: 'Message Signer / Verifier', description: 'Sign messages and verify signatures using RSA/ECDSA keys.', category: ToolCategory.crypto, icon: Icons.draw_outlined, tags: ['sign', 'verify', 'signature'], isAvailable: false),
    ToolModel(id: 'csr_generator', name: 'CSR Generator', description: 'Generate Certificate Signing Requests for SSL/TLS certificates.', category: ToolCategory.crypto, icon: Icons.description_outlined, tags: ['csr', 'certificate', 'ssl'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 2. PASSWORD TOOLKIT
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'password_generator', name: 'Password Generator', description: 'Generate strong passwords with custom length, charset, and exclusion rules.', category: ToolCategory.password, icon: Icons.password, tags: ['password', 'generate', 'secure'], isAvailable: true, routePath: '/category/password/password_generator'),
    ToolModel(id: 'entropy_analyzer', name: 'Entropy Analyzer', description: 'Analyze password strength with entropy score and brute-force time estimate.', category: ToolCategory.password, icon: Icons.analytics, tags: ['entropy', 'strength', 'password', 'security'], isAvailable: true, routePath: '/category/password/entropy_analyzer'),
    ToolModel(id: 'passphrase_diceware', name: 'Passphrase Diceware', description: 'Generate memorable passphrases using the EFF Diceware wordlist (offline).', category: ToolCategory.password, icon: Icons.casino_outlined, tags: ['passphrase', 'diceware', 'eff', 'wordlist'], isAvailable: true, routePath: '/category/password/passphrase_diceware'),
    ToolModel(id: 'pin_generator', name: 'PIN Generator', description: 'Generate cryptographically secure PINs from 4 to 12 digits.', category: ToolCategory.password, icon: Icons.pin, tags: ['pin', 'numeric', 'secure'], isAvailable: true, routePath: '/category/password/pin_generator'),
    ToolModel(id: 'pronounceable_pwd', name: 'Pronounceable Password', description: 'Generate passwords that are easier to remember while staying secure.', category: ToolCategory.password, icon: Icons.record_voice_over_outlined, tags: ['password', 'pronounceable', 'memorable'], isAvailable: false),
    ToolModel(id: 'batch_password_gen', name: 'Batch Password Generator', description: 'Generate multiple passwords at once with configurable options.', category: ToolCategory.password, icon: Icons.format_list_bulleted, tags: ['batch', 'password', 'bulk'], isAvailable: false),
    ToolModel(id: 'mnemonic_generator', name: 'Mnemonic Generator', description: 'Generate memorable acronym-based mnemonics from text.', category: ToolCategory.password, icon: Icons.memory_outlined, tags: ['mnemonic', 'acronym', 'memory'], isAvailable: false),
    ToolModel(id: 'password_history', name: 'Password History', description: 'View, manage, and securely clear your local password generation history.', category: ToolCategory.password, icon: Icons.history, tags: ['history', 'password', 'storage'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 3. ENCODE / DECODE
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'base64_tool', name: 'Base64 Encode / Decode', description: 'Encode and decode Base64 (standard and URL-safe variants).', category: ToolCategory.encodeDecode, icon: Icons.swap_horiz, tags: ['base64', 'encode', 'decode'], isAvailable: true, routePath: '/category/encodeDecode/base64_tool'),
    ToolModel(id: 'base32_tool', name: 'Base32 Encode / Decode', description: 'Encode and decode data using the Base32 encoding scheme.', category: ToolCategory.encodeDecode, icon: Icons.swap_horiz, tags: ['base32', 'encode', 'decode'], isAvailable: true, routePath: '/category/encodeDecode/base32_tool'),
    ToolModel(id: 'hex_tool', name: 'Hex Encode / Decode', description: 'Convert text to hexadecimal representation and back.', category: ToolCategory.encodeDecode, icon: Icons.swap_horiz, tags: ['hex', 'hexadecimal', 'encode'], isAvailable: true, routePath: '/category/encodeDecode/hex_tool'),
    ToolModel(id: 'url_encode_tool', name: 'URL Encode / Decode', description: 'Percent-encode and decode URLs for safe transmission.', category: ToolCategory.encodeDecode, icon: Icons.link, tags: ['url', 'percent', 'encode'], isAvailable: true, routePath: '/category/encodeDecode/url_encode_tool'),
    ToolModel(id: 'rot_tool', name: 'ROT13 / ROT47', description: 'Apply ROT13 and ROT47 Caesar substitution ciphers.', category: ToolCategory.encodeDecode, icon: Icons.rotate_right, tags: ['rot13', 'rot47', 'cipher'], isAvailable: true, routePath: '/category/encodeDecode/rot_tool'),
    ToolModel(id: 'morse_tool', name: 'Morse Code', description: 'Encode text to Morse code and decode Morse code to text.', category: ToolCategory.encodeDecode, icon: Icons.graphic_eq, tags: ['morse', 'code', 'telegraph'], isAvailable: true, routePath: '/category/encodeDecode/morse_tool'),
    ToolModel(id: 'binary_octal_tool', name: 'Binary / Octal / ASCII', description: 'Convert between binary, octal, decimal, and ASCII representations.', category: ToolCategory.encodeDecode, icon: Icons.computer, tags: ['binary', 'octal', 'ascii', 'decimal'], isAvailable: true, routePath: '/category/encodeDecode/binary_octal_tool'),
    ToolModel(id: 'html_entities', name: 'HTML Entities', description: 'Encode and decode HTML special characters and entities.', category: ToolCategory.encodeDecode, icon: Icons.html, tags: ['html', 'entities', 'encode'], isAvailable: false),
    ToolModel(id: 'unicode_escape', name: 'Unicode Escape', description: 'Encode and decode Unicode escape sequences (\\uXXXX format).', category: ToolCategory.encodeDecode, icon: Icons.abc, tags: ['unicode', 'escape', 'encode'], isAvailable: false),
    ToolModel(id: 'punycode_tool', name: 'Punycode (IDN)', description: 'Encode international domain names using Punycode.', category: ToolCategory.encodeDecode, icon: Icons.language, tags: ['punycode', 'idn', 'domain'], isAvailable: false),
    ToolModel(id: 'base58_tool', name: 'Base58 Encode / Decode', description: 'Base58 encoding used in Bitcoin addresses and IPFS.', category: ToolCategory.encodeDecode, icon: Icons.swap_horiz, tags: ['base58', 'bitcoin', 'encode'], isAvailable: false),
    ToolModel(id: 'base85_tool', name: 'Base85 (Ascii85)', description: 'Base85 / Ascii85 encoding for compact binary-to-text conversion.', category: ToolCategory.encodeDecode, icon: Icons.swap_horiz, tags: ['base85', 'ascii85', 'encode'], isAvailable: false),
    ToolModel(id: 'xor_tool', name: 'XOR Encode / Decode', description: 'XOR encode/decode strings with a custom key.', category: ToolCategory.encodeDecode, icon: Icons.code, tags: ['xor', 'encode', 'bitwise'], isAvailable: false),
    ToolModel(id: 'nato_alphabet', name: 'NATO Phonetic Alphabet', description: 'Convert text to NATO phonetic alphabet representation.', category: ToolCategory.encodeDecode, icon: Icons.military_tech_outlined, tags: ['nato', 'phonetic', 'alphabet'], isAvailable: false),
    ToolModel(id: 'atbash_cipher', name: 'Atbash Cipher', description: 'Apply the Atbash mirror substitution cipher to text.', category: ToolCategory.encodeDecode, icon: Icons.abc, tags: ['atbash', 'cipher', 'substitution'], isAvailable: false),
    ToolModel(id: 'bacon_cipher', name: 'Bacon Cipher', description: 'Encode messages using Francis Bacon\'s steganographic cipher.', category: ToolCategory.encodeDecode, icon: Icons.format_bold, tags: ['bacon', 'cipher', 'steganography'], isAvailable: false),
    ToolModel(id: 'braille_tool', name: 'Braille Encoding', description: 'Convert text to Unicode Braille representation.', category: ToolCategory.encodeDecode, icon: Icons.accessibility_outlined, tags: ['braille', 'unicode', 'accessibility'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 4. FILE SECURITY
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'file_hash', name: 'File Hash Calculator', description: 'Compute MD5, SHA1, SHA256, SHA512 hashes for any file.', category: ToolCategory.fileSecurity, icon: Icons.folder_outlined, tags: ['file', 'hash', 'md5', 'sha256', 'integrity'], isAvailable: false),
    ToolModel(id: 'file_hash_compare', name: 'File Hash Comparator', description: 'Verify file integrity by comparing computed hash against expected value.', category: ToolCategory.fileSecurity, icon: Icons.compare, tags: ['file', 'hash', 'compare', 'verify'], isAvailable: false),
    ToolModel(id: 'magic_bytes', name: 'File Signature Analyzer', description: 'Detect file type from magic bytes (file header) — real MIME detection.', category: ToolCategory.fileSecurity, icon: Icons.code, tags: ['magic', 'bytes', 'mime', 'file', 'header'], isAvailable: false),
    ToolModel(id: 'integrity_report', name: 'Integrity Report Generator', description: 'Generate a full hash report for a directory of files.', category: ToolCategory.fileSecurity, icon: Icons.summarize, tags: ['report', 'integrity', 'hash'], isAvailable: false),
    ToolModel(id: 'entropy_analyzer_file', name: 'File Entropy Analysis', description: 'Analyze file entropy byte-by-byte to detect encrypted or compressed sections.', category: ToolCategory.fileSecurity, icon: Icons.bar_chart, tags: ['entropy', 'file', 'analysis', 'crypto'], isAvailable: false),
    ToolModel(id: 'pe_header_analyzer', name: 'PE Header Analyzer', description: 'Analyze PE (Portable Executable) headers of Windows EXE/DLL files.', category: ToolCategory.fileSecurity, icon: Icons.memory, tags: ['pe', 'exe', 'windows', 'header', 'malware'], isAvailable: false),
    ToolModel(id: 'elf_header_analyzer', name: 'ELF Header Analyzer', description: 'Inspect ELF binary headers for Linux executables and shared libraries.', category: ToolCategory.fileSecurity, icon: Icons.memory, tags: ['elf', 'linux', 'binary', 'header'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 5. NETWORK TOOLS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'ping_tool', name: 'Ping', description: 'Send ICMP echo requests to test host reachability and measure latency.', category: ToolCategory.network, icon: Icons.wifi_tethering, tags: ['ping', 'icmp', 'latency', 'network'], isAvailable: false, requiresNetwork: true),
    ToolModel(id: 'dns_lookup', name: 'DNS Lookup', description: 'Query DNS records: A, AAAA, MX, TXT, CNAME, NS, SOA, CAA.', category: ToolCategory.network, icon: Icons.dns_outlined, tags: ['dns', 'lookup', 'a', 'mx', 'txt'], isAvailable: false, requiresNetwork: true),
    ToolModel(id: 'port_scanner', name: 'Port Scanner', description: 'Scan common or custom port ranges on a target host.', category: ToolCategory.network, icon: Icons.radar, tags: ['port', 'scan', 'nmap', 'network'], isAvailable: false, requiresNetwork: true),
    ToolModel(id: 'cidr_calculator', name: 'CIDR Calculator', description: 'Calculate network address, broadcast, host range, and subnets from CIDR notation.', category: ToolCategory.network, icon: Icons.calculate, tags: ['cidr', 'subnet', 'network', 'ip'], isAvailable: false),
    ToolModel(id: 'ip_converter', name: 'IP Address Converter', description: 'Convert IPv4 addresses between decimal, hex, octal, binary, and IPv6.', category: ToolCategory.network, icon: Icons.swap_horiz, tags: ['ip', 'ipv4', 'ipv6', 'convert', 'hex'], isAvailable: false),
    ToolModel(id: 'firewall_rules', name: 'Firewall Rule Generator', description: 'Generate iptables, nftables, UFW, and Windows Firewall rules.', category: ToolCategory.network, icon: Icons.security, tags: ['firewall', 'iptables', 'ufw', 'rules'], isAvailable: false),
    ToolModel(id: 'http_headers', name: 'HTTP Headers Analyzer', description: 'Analyze and score HTTP security headers (CSP, HSTS, X-Frame-Options).', category: ToolCategory.network, icon: Icons.http, tags: ['http', 'headers', 'security', 'csp', 'hsts'], isAvailable: false),
    ToolModel(id: 'ssl_analyzer', name: 'SSL/TLS Analyzer', description: 'Analyze SSL/TLS certificates, cipher suites, and protocol support.', category: ToolCategory.network, icon: Icons.https_outlined, tags: ['ssl', 'tls', 'certificate', 'cipher'], isAvailable: false, requiresNetwork: true),
    ToolModel(id: 'wake_on_lan', name: 'Wake-on-LAN', description: 'Send Wake-on-LAN magic packets to wake network devices.', category: ToolCategory.network, icon: Icons.power_settings_new, tags: ['wol', 'wake', 'magic-packet', 'lan'], isAvailable: false),
    ToolModel(id: 'reverse_dns', name: 'Reverse DNS Lookup', description: 'Look up PTR records to resolve IP addresses to hostnames.', category: ToolCategory.network, icon: Icons.find_replace, tags: ['rdns', 'ptr', 'reverse', 'dns'], isAvailable: false, requiresNetwork: true),
    ToolModel(id: 'traceroute', name: 'Traceroute', description: 'Trace the network path to a destination host with hop analysis.', category: ToolCategory.network, icon: Icons.route, tags: ['traceroute', 'hop', 'network', 'trace'], isAvailable: false, requiresNetwork: true),

    // ═══════════════════════════════════════════════════════
    // 6. WIFI TOOLS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'wifi_scanner', name: 'WiFi Scanner', description: 'Scan nearby WiFi networks with signal strength, channel, and security info.', category: ToolCategory.wifi, icon: Icons.wifi_find, tags: ['wifi', 'scan', 'rssi', 'network'], isAvailable: false),
    ToolModel(id: 'wifi_qr', name: 'WiFi QR Generator', description: 'Generate WiFi QR codes for easy network sharing.', category: ToolCategory.wifi, icon: Icons.qr_code, tags: ['wifi', 'qr', 'share', 'network'], isAvailable: false),
    ToolModel(id: 'wifi_config_gen', name: 'WPA3 Config Generator', description: 'Generate WPA3 configuration templates for access points.', category: ToolCategory.wifi, icon: Icons.router_outlined, tags: ['wpa3', 'wifi', 'config', 'security'], isAvailable: false),
    ToolModel(id: 'wifi_channel_calc', name: 'Channel Optimizer', description: 'Calculate optimal WiFi channel based on nearby networks and interference.', category: ToolCategory.wifi, icon: Icons.tune, tags: ['wifi', 'channel', '2.4ghz', '5ghz'], isAvailable: false),
    ToolModel(id: 'wifi_range_calc', name: 'WiFi Range Calculator', description: 'Estimate WiFi coverage range using the Friis transmission model.', category: ToolCategory.wifi, icon: Icons.signal_cellular_alt, tags: ['wifi', 'range', 'friis', 'signal'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 7. DEVELOPER TOOLS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'json_tool', name: 'JSON Formatter', description: 'Format, validate, beautify, and minify JSON data with syntax highlighting.', category: ToolCategory.developer, icon: Icons.data_object, tags: ['json', 'format', 'validate', 'beautify', 'minify'], isAvailable: true, routePath: '/category/developer/json_tool'),
    ToolModel(id: 'json_yaml_tool', name: 'JSON ↔ YAML Converter', description: 'Convert between JSON and YAML formats bidirectionally.', category: ToolCategory.developer, icon: Icons.compare_arrows, tags: ['json', 'yaml', 'convert'], isAvailable: true, routePath: '/category/developer/json_yaml_tool'),
    ToolModel(id: 'jwt_decoder', name: 'JWT Decoder', description: 'Decode and inspect JWT tokens — header, payload, signature analysis.', category: ToolCategory.developer, icon: Icons.verified_user_outlined, tags: ['jwt', 'token', 'decode', 'auth'], isAvailable: true, routePath: '/category/developer/jwt_decoder'),
    ToolModel(id: 'regex_tester', name: 'Regex Tester', description: 'Test regular expressions with live match highlighting and group extraction.', category: ToolCategory.developer, icon: Icons.search, tags: ['regex', 'regexp', 'test', 'match'], isAvailable: true, routePath: '/category/developer/regex_tester'),
    ToolModel(id: 'diff_tool', name: 'Diff Tool', description: 'Compare two text blocks side-by-side with unified diff highlighting.', category: ToolCategory.developer, icon: Icons.difference, tags: ['diff', 'compare', 'text', 'patch'], isAvailable: true, routePath: '/category/developer/diff_tool'),
    ToolModel(id: 'cron_tool', name: 'CRON Explainer', description: 'Parse cron expressions and preview their next execution times.', category: ToolCategory.developer, icon: Icons.schedule, tags: ['cron', 'schedule', 'task', 'explain'], isAvailable: true, routePath: '/category/developer/cron_tool'),
    ToolModel(id: 'timestamp_tool', name: 'Timestamp Converter', description: 'Convert between Unix timestamps and human-readable date/time formats.', category: ToolCategory.developer, icon: Icons.access_time, tags: ['timestamp', 'unix', 'date', 'time', 'epoch'], isAvailable: true, routePath: '/category/developer/timestamp_tool'),
    ToolModel(id: 'uuid_generator', name: 'UUID Generator', description: 'Generate UUID v1, v4, and v7 universally unique identifiers.', category: ToolCategory.developer, icon: Icons.tag, tags: ['uuid', 'guid', 'v4', 'unique', 'id'], isAvailable: true, routePath: '/category/developer/uuid_generator'),
    ToolModel(id: 'color_converter', name: 'Color Converter', description: 'Convert colors between HEX, RGB, HSL, HSV, and CMYK with palette generation.', category: ToolCategory.developer, icon: Icons.color_lens_outlined, tags: ['color', 'hex', 'rgb', 'hsl', 'palette'], isAvailable: true, routePath: '/category/developer/color_converter'),
    ToolModel(id: 'markdown_preview', name: 'Markdown Previewer', description: 'Preview and edit Markdown with real-time rendering (GFM support).', category: ToolCategory.developer, icon: Icons.description_outlined, tags: ['markdown', 'preview', 'gfm', 'md'], isAvailable: false),
    ToolModel(id: 'sql_formatter', name: 'SQL Formatter', description: 'Format and beautify SQL queries with syntax highlighting.', category: ToolCategory.developer, icon: Icons.storage, tags: ['sql', 'format', 'database', 'query'], isAvailable: false),
    ToolModel(id: 'http_status', name: 'HTTP Status Reference', description: 'Complete reference of HTTP status codes with descriptions and use cases.', category: ToolCategory.developer, icon: Icons.http, tags: ['http', 'status', 'codes', 'reference'], isAvailable: false),
    ToolModel(id: 'lorem_ipsum', name: 'Lorem Ipsum Generator', description: 'Generate lorem ipsum placeholder text in paragraphs, sentences, or words.', category: ToolCategory.developer, icon: Icons.text_fields, tags: ['lorem', 'ipsum', 'placeholder', 'text'], isAvailable: false),
    ToolModel(id: 'fake_data_gen', name: 'Fake Data Generator', description: 'Generate realistic fake names, emails, addresses, and other synthetic data.', category: ToolCategory.developer, icon: Icons.person_outlined, tags: ['fake', 'data', 'test', 'mock'], isAvailable: false),
    ToolModel(id: 'gitignore_gen', name: '.gitignore Generator', description: 'Generate .gitignore files for common languages and IDEs.', category: ToolCategory.developer, icon: Icons.block_outlined, tags: ['git', 'gitignore', 'generate'], isAvailable: false),
    ToolModel(id: 'json_csv_tool', name: 'JSON ↔ CSV Converter', description: 'Convert JSON arrays to CSV and vice versa.', category: ToolCategory.developer, icon: Icons.table_chart_outlined, tags: ['json', 'csv', 'convert', 'table'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 8. ENCODING UTILITIES
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'uuid_utils', name: 'UUID Generator (All)', description: 'Generate UUID v1, v3, v4, v5, v7 with decoding and timestamp extraction.', category: ToolCategory.encodingUtils, icon: Icons.tag, tags: ['uuid', 'guid', 'ulid', 'nanoid'], isAvailable: false),
    ToolModel(id: 'token_generator', name: 'API Token Generator', description: 'Generate API tokens in various formats: Base62, Base64URL, Hex, Bearer.', category: ToolCategory.encodingUtils, icon: Icons.token, tags: ['token', 'api', 'secret', 'bearer'], isAvailable: false),
    ToolModel(id: 'ssh_key_gen', name: 'SSH Key Generator', description: 'Generate RSA, ECDSA, and Ed25519 SSH key pairs (offline).', category: ToolCategory.encodingUtils, icon: Icons.terminal, tags: ['ssh', 'key', 'rsa', 'ed25519'], isAvailable: false),
    ToolModel(id: 'totp_tool', name: 'TOTP Generator', description: 'Generate TOTP (Time-based One-Time Password) codes from a secret seed.', category: ToolCategory.encodingUtils, icon: Icons.lock_clock, tags: ['totp', 'otp', '2fa', 'authenticator'], isAvailable: false),
    ToolModel(id: 'pem_der_converter', name: 'PEM ↔ DER Converter', description: 'Convert cryptographic keys and certificates between PEM and DER formats.', category: ToolCategory.encodingUtils, icon: Icons.compare_arrows, tags: ['pem', 'der', 'jwk', 'convert', 'key'], isAvailable: false),
    ToolModel(id: 'csprng', name: 'Secure Random Generator', description: 'Generate cryptographically secure random bytes, numbers, and strings.', category: ToolCategory.encodingUtils, icon: Icons.casino, tags: ['random', 'csprng', 'secure', 'bytes'], isAvailable: false),
    ToolModel(id: 'oauth_secret_gen', name: 'OAuth Secret Generator', description: 'Generate OAuth client secrets and HMAC signing secrets.', category: ToolCategory.encodingUtils, icon: Icons.key, tags: ['oauth', 'secret', 'hmac', 'api'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 9. FORENSICS TOOLS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'exif_extractor', name: 'EXIF Data Extractor', description: 'Extract EXIF metadata from images including GPS, camera model, and timestamps.', category: ToolCategory.forensics, icon: Icons.photo_camera_outlined, tags: ['exif', 'metadata', 'gps', 'image'], isAvailable: false),
    ToolModel(id: 'exif_remover', name: 'EXIF Metadata Remover', description: 'Strip EXIF and metadata from images to protect privacy.', category: ToolCategory.forensics, icon: Icons.no_photography_outlined, tags: ['exif', 'metadata', 'remove', 'privacy'], isAvailable: false),
    ToolModel(id: 'hex_dump', name: 'Hex Dump Viewer', description: 'View file content as a hex dump with ASCII sidebar.', category: ToolCategory.forensics, icon: Icons.memory, tags: ['hex', 'dump', 'binary', 'viewer'], isAvailable: false),
    ToolModel(id: 'strings_extractor', name: 'Strings Extractor', description: 'Extract readable ASCII and Unicode strings from binary files.', category: ToolCategory.forensics, icon: Icons.text_snippet_outlined, tags: ['strings', 'binary', 'extract', 'forensics'], isAvailable: false),
    ToolModel(id: 'file_entropy', name: 'File Entropy Visualizer', description: 'Visualize entropy of file sections to detect encrypted/packed content.', category: ToolCategory.forensics, icon: Icons.bar_chart, tags: ['entropy', 'file', 'encryption', 'detect'], isAvailable: false),
    ToolModel(id: 'lsb_detector', name: 'LSB Steganography Detector', description: 'Detect least-significant-bit steganography in images.', category: ToolCategory.forensics, icon: Icons.image_search, tags: ['lsb', 'steganography', 'detect', 'image'], isAvailable: false),
    ToolModel(id: 'log_analyzer', name: 'Log Analyzer', description: 'Parse and analyze syslog, Apache, Nginx, and SSH auth logs.', category: ToolCategory.forensics, icon: Icons.list_alt_outlined, tags: ['log', 'analyze', 'syslog', 'apache', 'nginx'], isAvailable: false),
    ToolModel(id: 'timeline_builder', name: 'Timeline Builder', description: 'Build a chronological event timeline from log files.', category: ToolCategory.forensics, icon: Icons.timeline, tags: ['timeline', 'events', 'forensics', 'log'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 10. SYSTEM TOOLS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'system_info', name: 'System Information', description: 'View OS, CPU, RAM, storage, and hardware details.', category: ToolCategory.systemTools, icon: Icons.info_outline, tags: ['system', 'os', 'cpu', 'ram', 'info'], isAvailable: false),
    ToolModel(id: 'network_info', name: 'Network Information', description: 'View network interfaces, local IP, MAC address, and routing table.', category: ToolCategory.systemTools, icon: Icons.network_check, tags: ['network', 'ip', 'mac', 'interface'], isAvailable: false),
    ToolModel(id: 'env_variables', name: 'Environment Variables', description: 'Read, search, and export system environment variables.', category: ToolCategory.systemTools, icon: Icons.settings_suggest_outlined, tags: ['env', 'environment', 'variables', 'system'], isAvailable: false),
    ToolModel(id: 'cpu_monitor', name: 'CPU & RAM Monitor', description: 'Real-time CPU usage and RAM consumption monitoring with graphs.', category: ToolCategory.systemTools, icon: Icons.monitor_heart_outlined, tags: ['cpu', 'ram', 'monitor', 'performance'], isAvailable: false),
    ToolModel(id: 'security_audit', name: 'System Security Audit', description: 'Check open ports, SUID files, service analysis, and SSH config audit.', category: ToolCategory.systemTools, icon: Icons.security_update_good, tags: ['audit', 'security', 'suid', 'ssh', 'ports'], isAvailable: false),
    ToolModel(id: 'system_report', name: 'System Report Generator', description: 'Generate a comprehensive system report and export as JSON or PDF.', category: ToolCategory.systemTools, icon: Icons.summarize_outlined, tags: ['report', 'system', 'export', 'json'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 11. OSINT TOOLS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'google_dorks', name: 'Google Dorks Generator', description: 'Generate advanced Google search operators for OSINT investigations.', category: ToolCategory.osint, icon: Icons.travel_explore, tags: ['google', 'dork', 'osint', 'search', 'recon'], isAvailable: false),
    ToolModel(id: 'email_extractor', name: 'Data Extractor', description: 'Extract emails, IPs, domains, URLs, phone numbers, and API keys from text.', category: ToolCategory.osint, icon: Icons.content_paste_search, tags: ['extract', 'email', 'ip', 'domain', 'regex'], isAvailable: false),
    ToolModel(id: 'phone_analyzer', name: 'Phone Number Analyzer', description: 'Parse, format, and identify carrier/country from phone numbers.', category: ToolCategory.osint, icon: Icons.phone_outlined, tags: ['phone', 'number', 'carrier', 'country'], isAvailable: false),
    ToolModel(id: 'wordlist_gen', name: 'Wordlist Generator', description: 'Generate custom wordlists with mutations (leet speak, case variations).', category: ToolCategory.osint, icon: Icons.list, tags: ['wordlist', 'password', 'bruteforce', 'mutation'], isAvailable: false),
    ToolModel(id: 'username_tools', name: 'Username Analyzer', description: 'Generate username variations and platform lookup templates.', category: ToolCategory.osint, icon: Icons.person_search, tags: ['username', 'osint', 'social', 'recon'], isAvailable: false),
    ToolModel(id: 'subdomain_enum', name: 'Subdomain Permutation', description: 'Generate subdomain permutations and typosquatting variants.', category: ToolCategory.osint, icon: Icons.domain, tags: ['subdomain', 'domain', 'permutation', 'osint'], isAvailable: false),
    ToolModel(id: 'url_tracker_cleaner', name: 'URL Tracker Cleaner', description: 'Remove tracking parameters (UTM, fbclid, etc.) from URLs.', category: ToolCategory.osint, icon: Icons.link_off, tags: ['url', 'tracking', 'clean', 'utm', 'privacy'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 12. STEGANOGRAPHY STUDIO
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'lsb_encode', name: 'LSB Text Encoder', description: 'Hide secret text inside an image using LSB steganography.', category: ToolCategory.steganography, icon: Icons.hide_image_outlined, tags: ['lsb', 'steganography', 'encode', 'hide', 'image'], isAvailable: false),
    ToolModel(id: 'lsb_decode', name: 'LSB Text Decoder', description: 'Extract hidden text from an image encoded with LSB steganography.', category: ToolCategory.steganography, icon: Icons.image_search, tags: ['lsb', 'steganography', 'decode', 'extract'], isAvailable: false),
    ToolModel(id: 'lsb_password', name: 'LSB + AES Encoder', description: 'Encode a message into an image with password-based AES encryption.', category: ToolCategory.steganography, icon: Icons.lock_outlined, tags: ['lsb', 'aes', 'encrypt', 'steganography'], isAvailable: false),
    ToolModel(id: 'bit_planes', name: 'Bit Plane Visualizer', description: 'Visualize each bit plane of an image for steganographic analysis.', category: ToolCategory.steganography, icon: Icons.layers_outlined, tags: ['bit', 'planes', 'visualize', 'steganalysis'], isAvailable: false),
    ToolModel(id: 'chi_square_test', name: 'Chi-Square Steganalysis', description: 'Perform chi-square test to detect LSB steganography in images.', category: ToolCategory.steganography, icon: Icons.analytics_outlined, tags: ['chi-square', 'steganalysis', 'detection'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 13. CODE ANALYSIS
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'secret_detector', name: 'Secret Detector', description: 'Detect hardcoded API keys, passwords, and credentials in source code.', category: ToolCategory.codeAnalysis, icon: Icons.manage_search, tags: ['secrets', 'api-key', 'credentials', 'scan', 'security'], isAvailable: false),
    ToolModel(id: 'xss_sqli_detector', name: 'Vulnerability Pattern Detector', description: 'Detect common SQL injection, XSS, and security anti-patterns in code.', category: ToolCategory.codeAnalysis, icon: Icons.bug_report_outlined, tags: ['xss', 'sqli', 'vulnerability', 'pattern', 'sast'], isAvailable: false),
    ToolModel(id: 'dep_analyzer', name: 'Dependency Analyzer', description: 'Analyze package.json and requirements.txt for known CVE-affected versions.', category: ToolCategory.codeAnalysis, icon: Icons.account_tree_outlined, tags: ['dependency', 'cve', 'npm', 'pip', 'vulnerability'], isAvailable: false),
    ToolModel(id: 'js_deobfuscator', name: 'JS Deobfuscator', description: 'Basic JavaScript deobfuscation and readable code extraction.', category: ToolCategory.codeAnalysis, icon: Icons.code_off, tags: ['javascript', 'deobfuscate', 'obfuscation'], isAvailable: false),
    ToolModel(id: 'dockerfile_gen', name: 'Dockerfile Generator', description: 'Generate Dockerfile templates for common tech stacks.', category: ToolCategory.codeAnalysis, icon: Icons.layers, tags: ['docker', 'dockerfile', 'container', 'generate'], isAvailable: false),
    ToolModel(id: 'cicd_gen', name: 'CI/CD Pipeline Generator', description: 'Generate GitHub Actions and GitLab CI pipeline configurations.', category: ToolCategory.codeAnalysis, icon: Icons.merge_type, tags: ['cicd', 'github-actions', 'pipeline', 'devops'], isAvailable: false),
    ToolModel(id: 'nginx_gen', name: 'Nginx Config Generator', description: 'Generate Nginx server block configurations with SSL and security headers.', category: ToolCategory.codeAnalysis, icon: Icons.web, tags: ['nginx', 'apache', 'server', 'config', 'generate'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 14. QR CODE & BARCODE
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'qr_generator', name: 'QR Code Generator', description: 'Generate QR codes for text, URLs, email, WiFi, and vCard contacts.', category: ToolCategory.qrBarcode, icon: Icons.qr_code_2, tags: ['qr', 'code', 'generate', 'url', 'wifi', 'vcard'], isAvailable: true, routePath: '/category/qrBarcode/qr_generator'),
    ToolModel(id: 'barcode_gen', name: 'Barcode Generator', description: 'Generate Code128, EAN-13, EAN-8, and Code39 barcodes.', category: ToolCategory.qrBarcode, icon: Icons.view_week_outlined, tags: ['barcode', 'code128', 'ean13', 'generate'], isAvailable: false),
    ToolModel(id: 'qr_analyzer', name: 'QR Content Analyzer', description: 'Analyze QR code content to detect phishing URLs and malicious data.', category: ToolCategory.qrBarcode, icon: Icons.policy_outlined, tags: ['qr', 'analyze', 'phishing', 'security', 'detect'], isAvailable: false),
    ToolModel(id: 'qr_custom', name: 'Custom QR Designer', description: 'Create QR codes with custom colors, logos, and styles.', category: ToolCategory.qrBarcode, icon: Icons.palette_outlined, tags: ['qr', 'custom', 'design', 'logo', 'color'], isAvailable: false),
    ToolModel(id: 'qr_batch', name: 'Batch QR Generator', description: 'Generate multiple QR codes at once from a CSV or text list.', category: ToolCategory.qrBarcode, icon: Icons.dynamic_feed, tags: ['qr', 'batch', 'bulk', 'generate'], isAvailable: false),

    // ═══════════════════════════════════════════════════════
    // 15. PRIVACY & ANTI-TRACKING
    // ═══════════════════════════════════════════════════════

    ToolModel(id: 'fake_identity', name: 'Fake Identity Generator', description: 'Generate realistic fake identities with name, email, and address (offline).', category: ToolCategory.privacy, icon: Icons.person_outlined, tags: ['fake', 'identity', 'privacy', 'anonymous'], isAvailable: false),
    ToolModel(id: 'pii_masker', name: 'PII Masker / Tokenizer', description: 'Detect and mask personally identifiable information in text.', category: ToolCategory.privacy, icon: Icons.blur_on, tags: ['pii', 'mask', 'privacy', 'tokenize'], isAvailable: false),
    ToolModel(id: 'url_tracker_strip', name: 'URL Tracking Stripper', description: 'Remove UTM parameters, fbclid, and other tracking fragments from URLs.', category: ToolCategory.privacy, icon: Icons.privacy_tip_outlined, tags: ['url', 'tracker', 'utm', 'privacy', 'clean'], isAvailable: false),
    ToolModel(id: 'luhn_card_gen', name: 'Luhn Card Number Generator', description: 'Generate Luhn-valid card numbers for testing payment integrations.', category: ToolCategory.privacy, icon: Icons.credit_card_outlined, tags: ['luhn', 'card', 'credit', 'testing'], isAvailable: false),
    ToolModel(id: 'fingerprint_ref', name: 'Browser Fingerprint Reference', description: 'Reference guide for browser fingerprinting techniques and defenses.', category: ToolCategory.privacy, icon: Icons.fingerprint, tags: ['fingerprint', 'browser', 'tracking', 'reference'], isAvailable: false),
    ToolModel(id: 'useragent_gen', name: 'User-Agent Generator', description: 'Generate random valid User-Agent strings for various browsers and OS.', category: ToolCategory.privacy, icon: Icons.devices_outlined, tags: ['useragent', 'browser', 'spoof', 'privacy'], isAvailable: false),
  ];

  static List<ToolModel> byCategory(ToolCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  static List<ToolModel> available() {
    return all.where((t) => t.isAvailable).toList();
  }

  static List<ToolModel> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    return all.where((t) {
      return t.name.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q) ||
          t.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  static int countByCategory(ToolCategory category) {
    return all.where((t) => t.category == category).length;
  }

  static int countAvailableByCategory(ToolCategory category) {
    return all.where((t) => t.category == category && t.isAvailable).length;
  }
}
