import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// PASSWORD TOOLKIT TOOLS
/// Password Generation, Analysis & Management
/// ────────────────────────────────────────────────────────────

class PasswordTools {
  PasswordTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'password_generator',
      name: 'Password Generator',
      description:
          'Generate strong passwords with custom length, charset, and exclusion rules.',
      category: ToolCategory.password,
      icon: Icons.password,
      tags: ['password', 'generate', 'secure'],
      isAvailable: true,
      routePath: '/password/generator',
    ),
    ToolModel(
      id: 'entropy_analyzer',
      name: 'Entropy Analyzer',
      description:
          'Analyze password strength with entropy score and brute-force time estimate.',
      category: ToolCategory.password,
      icon: Icons.analytics,
      tags: ['entropy', 'strength', 'password', 'security'],
      isAvailable: true,
      routePath: '/password/entropy',
    ),
    ToolModel(
      id: 'passphrase_diceware',
      name: 'Passphrase Diceware',
      description:
          'Generate memorable passphrases using the EFF Diceware wordlist (offline).',
      category: ToolCategory.password,
      icon: Icons.casino_outlined,
      tags: ['passphrase', 'diceware', 'eff', 'wordlist'],
      isAvailable: true,
      routePath: '/password/diceware',
    ),
    ToolModel(
      id: 'pin_generator',
      name: 'PIN Generator',
      description:
          'Generate cryptographically secure PINs from 4 to 12 digits.',
      category: ToolCategory.password,
      icon: Icons.pin,
      tags: ['pin', 'numeric', 'secure'],
      isAvailable: true,
      routePath: '/password/pin',
    ),
    ToolModel(
      id: 'pronounceable_pwd',
      name: 'Pronounceable Password',
      description:
          'Generate passwords that are easier to remember while staying secure.',
      category: ToolCategory.password,
      icon: Icons.record_voice_over_outlined,
      tags: ['password', 'pronounceable', 'memorable'],
      isAvailable: true,
      routePath: '/password/pronounceable',
    ),
    ToolModel(
      id: 'batch_password_gen',
      name: 'Batch Password Generator',
      description:
          'Generate multiple passwords at once with configurable options.',
      category: ToolCategory.password,
      icon: Icons.format_list_bulleted,
      tags: ['batch', 'password', 'bulk'],
      isAvailable: true,
      routePath: '/password/batch',
    ),
    ToolModel(
      id: 'mnemonic_generator',
      name: 'Mnemonic Generator',
      description: 'Generate memorable acronym-based mnemonics from text.',
      category: ToolCategory.password,
      icon: Icons.memory_outlined,
      tags: ['mnemonic', 'acronym', 'memory'],
      isAvailable: true,
      routePath: '/password/mnemonic',
    ),
    ToolModel(
      id: 'password_history',
      name: 'Password History',
      description:
          'View, manage, and securely clear your local password generation history.',
      category: ToolCategory.password,
      icon: Icons.history,
      tags: ['history', 'password', 'storage'],
      isAvailable: true,
      routePath: '/password/history',
    ),
  ];
}
