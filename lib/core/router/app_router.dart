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

// ── Password tools
import '../../features/password/widgets/password_generator_widget.dart';
import '../../features/password/widgets/entropy_analyzer_widget.dart';
import '../../features/password/widgets/passphrase_diceware_widget.dart';
import '../../features/password/widgets/pin_generator_widget.dart';

// ── Encode/Decode tools
import '../../features/encode_decode/widgets/base64_widget.dart';
import '../../features/encode_decode/widgets/encode_decode_widgets.dart';

// ── Developer tools
import '../../features/developer/widgets/developer_widgets.dart';

// ── QR tools
import '../../features/qr_barcode/widgets/qr_generator_widget.dart';

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
    GoRoute(path: '/crypto/hash-generator', builder: (_, __) => const HashGeneratorWidget()),
    GoRoute(path: '/crypto/hmac', builder: (_, __) => const HmacGeneratorWidget()),
    GoRoute(path: '/crypto/hash-comparator', builder: (_, __) => const HashComparatorWidget()),
    GoRoute(path: '/crypto/aes', builder: (_, __) => const AesToolWidget()),
    GoRoute(path: '/crypto/rsa-keygen', builder: (_, __) => const RsaToolWidget()),
    GoRoute(path: '/crypto/pbkdf2', builder: (_, __) => const Pbkdf2Widget()),

    // ── Password routes
    GoRoute(path: '/password/generator', builder: (_, __) => const PasswordGeneratorWidget()),
    GoRoute(path: '/password/entropy', builder: (_, __) => const EntropyAnalyzerWidget()),
    GoRoute(path: '/password/diceware', builder: (_, __) => const PassphraseDicewareWidget()),
    GoRoute(path: '/password/pin', builder: (_, __) => const PinGeneratorWidget()),

    // ── Encode/Decode routes
    GoRoute(path: '/encode/base64', builder: (_, __) => const Base64Widget()),
    GoRoute(path: '/encode/base32', builder: (_, __) => const Base32Widget()),
    GoRoute(path: '/encode/hex', builder: (_, __) => const HexWidget()),
    GoRoute(path: '/encode/url', builder: (_, __) => const UrlEncodeWidget()),
    GoRoute(path: '/encode/rot', builder: (_, __) => const RotWidget()),
    GoRoute(path: '/encode/morse', builder: (_, __) => const MorseWidget()),
    GoRoute(path: '/encode/binary-octal-ascii', builder: (_, __) => const BinaryOctalAsciiWidget()),

    // ── Developer routes
    GoRoute(path: '/developer/json-formatter', builder: (_, __) => const JsonFormatterWidget()),
    GoRoute(path: '/developer/uuid', builder: (_, __) => const UuidGeneratorWidget()),

    // ── QR routes
    GoRoute(path: '/qr/generator', builder: (_, __) => const QrGeneratorWidget()),
  ],
  errorBuilder: (ctx, state) => Scaffold(
    backgroundColor: const Color(0xFF0A0F1E),
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('404', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 72, color: Color(0xFF00FF88), fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('ROUTE NOT FOUND', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14, color: Color(0xFF8892A4), letterSpacing: 3)),
        const SizedBox(height: 24),
        TextButton(onPressed: () => ctx.go('/'), child: const Text('← GO HOME', style: TextStyle(fontFamily: 'JetBrainsMono', color: Color(0xFF00FF88)))),
      ]),
    ),
  ),
);
