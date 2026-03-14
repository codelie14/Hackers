import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// ENCODING UTILITIES TOOLS
/// Advanced Encoding and Token Generation
/// ────────────────────────────────────────────────────────────

class EncodingUtilsTools {
  EncodingUtilsTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'uuid_utils',
      name: 'UUID Generator (All)',
      description:
          'Generate UUID v1, v3, v4, v5, v7 with decoding and timestamp extraction.',
      category: ToolCategory.encodingUtils,
      icon: Icons.tag,
      tags: ['uuid', 'guid', 'ulid', 'nanoid'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'token_generator',
      name: 'API Token Generator',
      description:
          'Generate API tokens in various formats: Base62, Base64URL, Hex, Bearer.',
      category: ToolCategory.encodingUtils,
      icon: Icons.token,
      tags: ['token', 'api', 'secret', 'bearer'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'ssh_key_gen',
      name: 'SSH Key Generator',
      description: 'Generate RSA, ECDSA, and Ed25519 SSH key pairs (offline).',
      category: ToolCategory.encodingUtils,
      icon: Icons.terminal,
      tags: ['ssh', 'key', 'rsa', 'ed25519'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'totp_tool',
      name: 'TOTP Generator',
      description:
          'Generate TOTP (Time-based One-Time Password) codes from a secret seed.',
      category: ToolCategory.encodingUtils,
      icon: Icons.lock_clock,
      tags: ['totp', 'otp', '2fa', 'authenticator'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'pem_der_converter',
      name: 'PEM ↔ DER Converter',
      description:
          'Convert cryptographic keys and certificates between PEM and DER formats.',
      category: ToolCategory.encodingUtils,
      icon: Icons.compare_arrows,
      tags: ['pem', 'der', 'jwk', 'convert', 'key'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'csprng',
      name: 'Secure Random Generator',
      description:
          'Generate cryptographically secure random bytes, numbers, and strings.',
      category: ToolCategory.encodingUtils,
      icon: Icons.casino,
      tags: ['random', 'csprng', 'secure', 'bytes'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'oauth_secret_gen',
      name: 'OAuth Secret Generator',
      description: 'Generate OAuth client secrets and HMAC signing secrets.',
      category: ToolCategory.encodingUtils,
      icon: Icons.key,
      tags: ['oauth', 'secret', 'hmac', 'api'],
      isAvailable: false,
    ),
  ];
}
