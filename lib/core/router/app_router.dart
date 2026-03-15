import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/tool_model.dart';

// ── Screens
import '../../features/home/home_screen.dart';
import '../../features/category/category_screen.dart';

// ── Crypto tools
import '../../features/crypto/widgets/hash_generator_widget.dart';
import '../../features/crypto/widgets/hmac_generator_widget.dart';
import '../../features/crypto/widgets/hash_comparator_widget.dart';
import '../../features/crypto/widgets/aes_tool_widget.dart';
import '../../features/crypto/widgets/rsa_tool_widget.dart';
import '../../features/crypto/widgets/pbkdf2_widget.dart';
import '../../features/crypto/widgets/bcrypt_hash_widget.dart';
import '../../features/crypto/widgets/chacha20_widget.dart';
import '../../features/crypto/widgets/salt_generator_widget.dart';
import '../../features/crypto/widgets/random_key_generator_widget.dart';
import '../../features/crypto/widgets/crc_checksum_widget.dart';
import '../../features/crypto/widgets/blake2_widget.dart';
import '../../features/crypto/widgets/argon2_widget.dart';
import '../../features/crypto/widgets/blake2s_widget.dart';
import '../../features/crypto/widgets/ripemd160_widget.dart';
import '../../features/crypto/widgets/keccak256_widget.dart';
import '../../features/crypto/widgets/caesar_cipher_widget.dart';
import '../../features/crypto/widgets/vigenere_cipher_widget.dart';
import '../../features/crypto/widgets/adler32_widget.dart';
import '../../features/crypto/widgets/one_time_pad_widget.dart';
import '../../features/crypto/widgets/hkdf_widget.dart';
import '../../features/crypto/widgets/rsa_encrypt_widget.dart';
import '../../features/crypto/widgets/triple_des_widget.dart';
import '../../features/crypto/widgets/blowfish_widget.dart';
import '../../features/crypto/widgets/ecdsa_keys_widget.dart';
import '../../features/crypto/widgets/ed25519_keys_widget.dart';
import '../../features/crypto/widgets/x509_analyzer_widget.dart';
import '../../features/crypto/widgets/message_signer_widget.dart';
import '../../features/crypto/widgets/csr_generator_widget.dart';

// ── Password tools
import '../../features/password/widgets/password_generator_widget.dart';
import '../../features/password/widgets/entropy_analyzer_widget.dart';
import '../../features/password/widgets/passphrase_diceware_widget.dart';
import '../../features/password/widgets/pin_generator_widget.dart';
import '../../features/password/widgets/pronounceable_password_widget.dart';
import '../../features/password/widgets/mnemonic_generator_widget.dart';
import '../../features/password/widgets/password_history_widget.dart';

// ── Encode/Decode tools
import '../../features/encode_decode/widgets/base64_widget.dart';
import '../../features/encode_decode/widgets/encode_decode_widgets.dart';
import '../../features/encode_decode/widgets/html_entities_widget.dart';
import '../../features/encode_decode/widgets/unicode_escape_widget.dart';
import '../../features/encode_decode/widgets/base58_widget.dart';
import '../../features/encode_decode/widgets/xor_cipher_widget.dart';

// ── Developer tools
import '../../features/developer/widgets/developer_widgets.dart';
import '../../features/developer/widgets/yaml_json_converter_widget.dart';
import '../../features/developer/widgets/jwt_decoder_widget.dart';
import '../../features/developer/widgets/sql_formatter_widget.dart';
import '../../features/developer/widgets/http_status_widget.dart';
import '../../features/developer/widgets/markdown_preview_widget.dart';
import '../../features/developer/widgets/regex_tester_widget.dart';

// ── QR tools
import '../../features/qr_barcode/widgets/qr_generator_widget.dart';
import '../../features/qr_barcode/widgets/qr_analyzer_widget.dart';
import '../../features/qr_barcode/widgets/custom_qr_designer_widget.dart';

// ── WiFi tools
import '../../features/wifi/widgets/wifi_scanner_widget.dart';

// ── Network tools
import '../../features/network/widgets/network_tools_widget.dart';

// ── System tools
import '../../features/system/widgets/system_info_widget.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    // ── Home
    GoRoute(path: '/', builder: (ctx, _) => const HomeScreen()),

    // ── Category
    GoRoute(
      path: '/category/:catId',
      builder: (ctx, state) {
        final catId = state.pathParameters['catId']!;
        final cat = ToolCategory.values.firstWhere(
          (c) => c.name == catId,
          orElse: () => ToolCategory.crypto,
        );
        return CategoryScreen(category: cat);
      },
    ),

    // ── Crypto routes
    GoRoute(
        path: '/crypto/hash-generator',
        builder: (_, __) => const HashGeneratorWidget()),
    GoRoute(
        path: '/crypto/hmac', builder: (_, __) => const HmacGeneratorWidget()),
    GoRoute(
        path: '/crypto/hash-comparator',
        builder: (_, __) => const HashComparatorWidget()),
    GoRoute(path: '/crypto/aes', builder: (_, __) => const AesToolWidget()),
    GoRoute(
        path: '/crypto/rsa-keygen', builder: (_, __) => const RsaToolWidget()),
    GoRoute(path: '/crypto/pbkdf2', builder: (_, __) => const Pbkdf2Widget()),
    GoRoute(
        path: '/crypto/bcrypt', builder: (_, __) => const BcryptHashWidget()),
    GoRoute(
        path: '/crypto/chacha20', builder: (_, __) => const ChaCha20Widget()),
    GoRoute(
        path: '/crypto/salt', builder: (_, __) => const SaltGeneratorWidget()),

    // ── Password routes
    GoRoute(
        path: '/password/generator',
        builder: (_, __) => const PasswordGeneratorWidget()),
    GoRoute(
        path: '/password/entropy',
        builder: (_, __) => const EntropyAnalyzerWidget()),
    GoRoute(
        path: '/password/diceware',
        builder: (_, __) => const PassphraseDicewareWidget()),
    GoRoute(
        path: '/password/pin', builder: (_, __) => const PinGeneratorWidget()),
    GoRoute(
        path: '/password/pronounceable',
        builder: (_, __) => const PronounceablePasswordWidget()),

    // ── Encode/Decode routes
    GoRoute(path: '/encode/base64', builder: (_, __) => const Base64Widget()),
    GoRoute(path: '/encode/base32', builder: (_, __) => const Base32Widget()),
    GoRoute(path: '/encode/hex', builder: (_, __) => const HexWidget()),
    GoRoute(path: '/encode/url', builder: (_, __) => const UrlEncodeWidget()),
    GoRoute(path: '/encode/rot', builder: (_, __) => const RotWidget()),
    GoRoute(path: '/encode/morse', builder: (_, __) => const MorseWidget()),
    GoRoute(
        path: '/encode/binary-octal-ascii',
        builder: (_, __) => const BinaryOctalAsciiWidget()),

    // ── Developer routes
    GoRoute(
        path: '/developer/json-formatter',
        builder: (_, __) => const JsonFormatterWidget()),
    GoRoute(
        path: '/developer/uuid',
        builder: (_, __) => const UuidGeneratorWidget()),
    GoRoute(
        path: '/developer/json-yaml',
        builder: (_, __) => const YamlJsonConverterWidget()),
    GoRoute(
        path: '/developer/jwt', builder: (_, __) => const JwtDecoderWidget()),

    // ── QR routes
    GoRoute(
        path: '/qr/generator', builder: (_, __) => const QrGeneratorWidget()),
    GoRoute(path: '/qr/analyzer', builder: (_, __) => const QrAnalyzerWidget()),
    GoRoute(
        path: '/qr/custom', builder: (_, __) => const CustomQrDesignerWidget()),

    // ── Crypto routes (new tools)
    GoRoute(
        path: '/crypto/random-key',
        builder: (_, __) => const RandomKeyGeneratorWidget()),
    GoRoute(path: '/crypto/crc', builder: (_, __) => const CrcChecksumWidget()),
    GoRoute(
        path: '/crypto/blake2', builder: (_, __) => const Blake2HashWidget()),
    GoRoute(path: '/crypto/argon2', builder: (_, __) => const Argon2Widget()),
    GoRoute(
        path: '/crypto/blake2s', builder: (_, __) => const Blake2sHashWidget()),
    GoRoute(
        path: '/crypto/ripemd160',
        builder: (_, __) => const Ripemd160HashWidget()),
    GoRoute(
        path: '/crypto/keccak256',
        builder: (_, __) => const Keccak256HashWidget()),
    GoRoute(
        path: '/crypto/caesar', builder: (_, __) => const CaesarCipherWidget()),
    GoRoute(
        path: '/crypto/vigenere',
        builder: (_, __) => const VigenereCipherWidget()),
    GoRoute(
        path: '/crypto/adler32',
        builder: (_, __) => const Adler32ChecksumWidget()),
    GoRoute(path: '/crypto/otp', builder: (_, __) => const OneTimePadWidget()),
    GoRoute(path: '/crypto/hkdf', builder: (_, __) => const HkdfToolWidget()),
    GoRoute(
        path: '/crypto/rsa-encrypt',
        builder: (_, __) => const RsaEncryptWidget()),
    GoRoute(path: '/crypto/3des', builder: (_, __) => const TripleDesWidget()),
    GoRoute(
        path: '/crypto/blowfish', builder: (_, __) => const BlowfishWidget()),
    GoRoute(path: '/crypto/ecdsa', builder: (_, __) => const EcdsaKeysWidget()),
    GoRoute(
        path: '/crypto/ed25519', builder: (_, __) => const Ed25519KeysWidget()),
    GoRoute(
        path: '/crypto/x509', builder: (_, __) => const X509AnalyzerWidget()),
    GoRoute(
        path: '/crypto/message-signer',
        builder: (_, __) => const MessageSignerWidget()),
    GoRoute(
        path: '/crypto/csr', builder: (_, __) => const CsrGeneratorWidget()),

    // ── Password routes (new tools)
    GoRoute(
        path: '/password/mnemonic',
        builder: (_, __) => const MnemonicGeneratorWidget()),
    GoRoute(
        path: '/password/history',
        builder: (_, __) => const PasswordHistoryWidget()),

    // ── Encode/Decode routes (new tools)
    GoRoute(
        path: '/encode/html-entities',
        builder: (_, __) => const HtmlEntitiesWidget()),
    GoRoute(
        path: '/encode/unicode',
        builder: (_, __) => const UnicodeEscapeWidget()),
    GoRoute(path: '/encode/base58', builder: (_, __) => const Base58Widget()),
    GoRoute(path: '/encode/xor', builder: (_, __) => const XorCipherWidget()),

    // ── Developer routes (new tools)
    GoRoute(
        path: '/developer/sql-formatter',
        builder: (_, __) => const SqlFormatterWidget()),
    GoRoute(
        path: '/developer/http-status',
        builder: (_, __) => const HttpStatusWidget()),
    GoRoute(
        path: '/developer/markdown',
        builder: (_, __) => const MarkdownPreviewWidget()),
    GoRoute(
        path: '/developer/regex-tester',
        builder: (_, __) => const RegexTesterWidget()),

    // ── WiFi routes
    GoRoute(
        path: '/wifi/scanner', builder: (_, __) => const WifiScannerWidget()),

    // ── Network routes
    GoRoute(
        path: '/network/ping', builder: (_, __) => const NetworkToolsWidget()),
    GoRoute(
        path: '/network/dns', builder: (_, __) => const NetworkToolsWidget()),

    // ── System routes
    GoRoute(path: '/system/info', builder: (_, __) => const SystemInfoWidget()),
  ],
  errorBuilder: (ctx, state) => Scaffold(
    backgroundColor: const Color(0xFF0A0F1E),
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('404',
            style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 72,
                color: Color(0xFF00FF88),
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('ROUTE NOT FOUND',
            style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                color: Color(0xFF8892A4),
                letterSpacing: 3)),
        const SizedBox(height: 24),
        TextButton(
            onPressed: () => ctx.go('/'),
            child: const Text('← GO HOME',
                style: TextStyle(
                    fontFamily: 'JetBrainsMono', color: Color(0xFF00FF88)))),
      ]),
    ),
  ),
);
