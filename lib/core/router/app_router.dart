import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/tool_model.dart';

// ── Screens
import '../../features/home/home_screen.dart';
import '../../features/category/category_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/help/help_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/favorites/favorites_screen.dart';

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
import '../../features/password/widgets/batch_password_generator_widget.dart';

// ── Encode/Decode tools
import '../../features/encode_decode/widgets/base64_widget.dart';
import '../../features/encode_decode/widgets/encode_decode_widgets.dart';
import '../../features/encode_decode/widgets/html_entities_widget.dart';
import '../../features/encode_decode/widgets/unicode_escape_widget.dart';
import '../../features/encode_decode/widgets/base58_widget.dart';
import '../../features/encode_decode/widgets/xor_cipher_widget.dart';
import '../../features/encode_decode/widgets/punycode_widget.dart';
import '../../features/encode_decode/widgets/base85_widget.dart';
import '../../features/encode_decode/widgets/nato_phonetic_widget.dart';
import '../../features/encode_decode/widgets/atbash_cipher_widget.dart';

// ── Developer tools
import '../../features/developer/widgets/developer_widgets.dart';
import '../../features/developer/widgets/yaml_json_converter_widget.dart';
import '../../features/developer/widgets/jwt_decoder_widget.dart';
import '../../features/developer/widgets/sql_formatter_widget.dart';
import '../../features/developer/widgets/http_status_widget.dart';
import '../../features/developer/widgets/markdown_preview_widget.dart';
import '../../features/developer/widgets/regex_tester_widget.dart';
import '../../features/developer/widgets/diff_tool_widget.dart';
import '../../features/developer/widgets/cron_explainer_widget.dart';
import '../../features/developer/widgets/timestamp_converter_widget.dart';
import '../../features/developer/widgets/color_converter_widget.dart';
import '../../features/developer/widgets/lorem_ipsum_widget.dart';
import '../../features/developer/widgets/fake_data_generator_widget.dart';
import '../../features/developer/widgets/gitignore_generator_widget.dart';
import '../../features/developer/widgets/json_csv_converter_widget.dart';

// ── QR tools
import '../../features/qr_barcode/widgets/qr_generator_widget.dart';
import '../../features/qr_barcode/widgets/qr_analyzer_widget.dart';
import '../../features/qr_barcode/widgets/custom_qr_designer_widget.dart';

// ── WiFi tools
import '../../features/wifi/widgets/wifi_scanner_widget.dart';
import '../../features/wifi/widgets/wifi_qr_generator_widget.dart';
import '../../features/wifi/widgets/wifi_channel_optimizer_widget.dart';
import '../../features/wifi/widgets/wifi_range_calculator_widget.dart';
import '../../features/wifi/widgets/wpa3_config_generator_widget.dart';

// ── Network tools
import '../../features/network/widgets/ping_widget.dart';
import '../../features/network/widgets/dns_lookup_widget.dart';
import '../../features/network/widgets/cidr_calculator_widget.dart';
import '../../features/network/widgets/ip_converter_widget.dart';
import '../../features/network/widgets/firewall_rules_widget.dart';
import '../../features/network/widgets/wake_on_lan_widget.dart';
import '../../features/network/widgets/traceroute_widget.dart';
import '../../features/network/widgets/reverse_dns_lookup_widget.dart';
import '../../features/network/widgets/port_scanner_widget.dart';
import '../../features/network/widgets/http_headers_analyzer_widget.dart';
import '../../features/network/widgets/ssl_tls_analyzer_widget.dart';

// ── System tools
import '../../features/system/widgets/system_info_widget.dart';
import '../../features/system/widgets/network_information_widget.dart';
import '../../features/system/widgets/environment_variables_widget.dart';
import '../../features/system/widgets/cpu_ram_monitor_widget.dart';
import '../../features/system/widgets/security_audit_widget.dart';
import '../../features/system/widgets/system_report_generator_widget.dart';

// Splash screen
import '../../features/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: [
    // Splash
    GoRoute(path: '/splash', builder: (ctx, _) => const SplashScreen()),

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

    // ── Navigation Routes
    GoRoute(path: '/search', builder: (ctx, _) => const SearchScreen()),
    GoRoute(path: '/settings', builder: (ctx, _) => const SettingsScreen()),
    GoRoute(path: '/help', builder: (ctx, _) => const HelpScreen()),
    GoRoute(path: '/history', builder: (ctx, _) => const HistoryScreen()),
    GoRoute(path: '/favorites', builder: (ctx, _) => const FavoritesScreen()),

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
    GoRoute(
        path: '/password/batch',
        builder: (_, __) => const BatchPasswordGeneratorWidget()),

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
    GoRoute(
        path: '/encode/html-entities',
        builder: (_, __) => const HtmlEntitiesWidget()),
    GoRoute(
        path: '/encode/unicode',
        builder: (_, __) => const UnicodeEscapeWidget()),
    GoRoute(path: '/encode/base58', builder: (_, __) => const Base58Widget()),
    GoRoute(path: '/encode/xor', builder: (_, __) => const XorCipherWidget()),
    GoRoute(
        path: '/encode/punycode', builder: (_, __) => const PunycodeWidget()),
    GoRoute(path: '/encode/base85', builder: (_, __) => const Base85Widget()),
    GoRoute(
        path: '/encode/nato-phonetic',
        builder: (_, __) => const NatoPhoneticWidget()),
    GoRoute(
        path: '/encode/atbash', builder: (_, __) => const AtbashCipherWidget()),

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
    GoRoute(
        path: '/developer/regex-tester',
        builder: (_, __) => const RegexTesterWidget()),
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
        path: '/developer/diff', builder: (_, __) => const DiffToolWidget()),
    GoRoute(
        path: '/developer/cron',
        builder: (_, __) => const CronExplainerWidget()),
    GoRoute(
        path: '/developer/timestamp',
        builder: (_, __) => const TimestampConverterWidget()),
    GoRoute(
        path: '/developer/color',
        builder: (_, __) => const ColorConverterWidget()),
    GoRoute(
        path: '/developer/lorem-ipsum',
        builder: (_, __) => const LoremIpsumGeneratorWidget()),
    GoRoute(
        path: '/developer/fake-data',
        builder: (_, __) => const FakeDataGeneratorWidget()),
    GoRoute(
        path: '/developer/gitignore',
        builder: (_, __) => const GitignoreGeneratorWidget()),
    GoRoute(
        path: '/developer/json-csv',
        builder: (_, __) => const JsonCsvConverterWidget()),

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
    GoRoute(
        path: '/wifi/qr-generator',
        builder: (_, __) => const WiFiQRGeneratorWidget()),
    GoRoute(
        path: '/wifi/channel-optimizer',
        builder: (_, __) => const WiFiChannelOptimizerWidget()),
    GoRoute(
        path: '/wifi/range-calculator',
        builder: (_, __) => const WiFiRangeCalculatorWidget()),
    GoRoute(
        path: '/wifi/wpa3-config',
        builder: (_, __) => const WPA3ConfigGeneratorWidget()),

    // ── Network routes
    GoRoute(path: '/network/ping', builder: (_, __) => const PingToolWidget()),
    GoRoute(path: '/network/dns', builder: (_, __) => const DnsLookupWidget()),
    GoRoute(
        path: '/network/cidr',
        builder: (_, __) => const CidrCalculatorWidget()),
    GoRoute(
        path: '/network/ip-converter',
        builder: (_, __) => const IpConverterWidget()),
    GoRoute(
        path: '/network/firewall',
        builder: (_, __) => const FirewallRulesWidget()),
    GoRoute(
        path: '/network/wake-on-lan',
        builder: (_, __) => const WakeOnLanWidget()),
    GoRoute(
        path: '/network/traceroute',
        builder: (_, __) => const TracerouteWidget()),
    GoRoute(
        path: '/network/reverse-dns',
        builder: (_, __) => const ReverseDnsLookupWidget()),
    GoRoute(
        path: '/network/port-scanner',
        builder: (_, __) => const PortScannerWidget()),
    GoRoute(
        path: '/network/http-headers',
        builder: (_, __) => const HttpHeadersAnalyzerWidget()),
    GoRoute(
        path: '/network/ssl-tls',
        builder: (_, __) => const SSLTLSAnalyzerWidget()),

    // ── System routes
    GoRoute(path: '/system/info', builder: (_, __) => const SystemInfoWidget()),
    GoRoute(
        path: '/system/network-info',
        builder: (_, __) => const NetworkInformationWidget()),
    GoRoute(
        path: '/system/env-variables',
        builder: (_, __) => const EnvironmentVariablesWidget()),
    GoRoute(
        path: '/system/cpu-monitor',
        builder: (_, __) => const CPURAMMonitorWidget()),
    GoRoute(
        path: '/system/security-audit',
        builder: (_, __) => const SecurityAuditWidget()),
    GoRoute(
        path: '/system/report',
        builder: (_, __) => const SystemReportGeneratorWidget()),
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
