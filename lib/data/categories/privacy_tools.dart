import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// PRIVACY & ANTI-TRACKING TOOLS
/// Protect Your Digital Privacy
/// ────────────────────────────────────────────────────────────

class PrivacyTools {
  PrivacyTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'fake_identity',
      name: 'Fake Identity Generator',
      description:
          'Generate realistic fake identities with name, email, and address (offline).',
      category: ToolCategory.privacy,
      icon: Icons.person_outlined,
      tags: ['fake', 'identity', 'privacy', 'anonymous'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'pii_masker',
      name: 'PII Masker / Tokenizer',
      description:
          'Detect and mask personally identifiable information in text.',
      category: ToolCategory.privacy,
      icon: Icons.blur_on,
      tags: ['pii', 'mask', 'privacy', 'tokenize'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'url_tracker_strip',
      name: 'URL Tracking Stripper',
      description:
          'Remove UTM parameters, fbclid, and other tracking fragments from URLs.',
      category: ToolCategory.privacy,
      icon: Icons.privacy_tip_outlined,
      tags: ['url', 'tracker', 'utm', 'privacy', 'clean'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'luhn_card_gen',
      name: 'Luhn Card Number Generator',
      description:
          'Generate Luhn-valid card numbers for testing payment integrations.',
      category: ToolCategory.privacy,
      icon: Icons.credit_card_outlined,
      tags: ['luhn', 'card', 'credit', 'testing'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'fingerprint_ref',
      name: 'Browser Fingerprint Reference',
      description:
          'Reference guide for browser fingerprinting techniques and defenses.',
      category: ToolCategory.privacy,
      icon: Icons.fingerprint,
      tags: ['fingerprint', 'browser', 'tracking', 'reference'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'useragent_gen',
      name: 'User-Agent Generator',
      description:
          'Generate random valid User-Agent strings for various browsers and OS.',
      category: ToolCategory.privacy,
      icon: Icons.devices_outlined,
      tags: ['useragent', 'browser', 'spoof', 'privacy'],
      isAvailable: false,
    ),
  ];
}
