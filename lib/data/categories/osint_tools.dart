import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// OSINT TOOLS
/// Open Source Intelligence Gathering
/// ────────────────────────────────────────────────────────────

class OsintTools {
  OsintTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'google_dorks',
      name: 'Google Dorks Generator',
      description:
          'Generate advanced Google search operators for OSINT investigations.',
      category: ToolCategory.osint,
      icon: Icons.travel_explore,
      tags: ['google', 'dork', 'osint', 'search', 'recon'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'email_extractor',
      name: 'Data Extractor',
      description:
          'Extract emails, IPs, domains, URLs, phone numbers, and API keys from text.',
      category: ToolCategory.osint,
      icon: Icons.content_paste_search,
      tags: ['extract', 'email', 'ip', 'domain', 'regex'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'phone_analyzer',
      name: 'Phone Number Analyzer',
      description:
          'Parse, format, and identify carrier/country from phone numbers.',
      category: ToolCategory.osint,
      icon: Icons.phone_outlined,
      tags: ['phone', 'number', 'carrier', 'country'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'wordlist_gen',
      name: 'Wordlist Generator',
      description:
          'Generate custom wordlists with mutations (leet speak, case variations).',
      category: ToolCategory.osint,
      icon: Icons.list,
      tags: ['wordlist', 'password', 'bruteforce', 'mutation'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'username_tools',
      name: 'Username Analyzer',
      description:
          'Generate username variations and platform lookup templates.',
      category: ToolCategory.osint,
      icon: Icons.person_search,
      tags: ['username', 'osint', 'social', 'recon'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'subdomain_enum',
      name: 'Subdomain Permutation',
      description:
          'Generate subdomain permutations and typosquatting variants.',
      category: ToolCategory.osint,
      icon: Icons.domain,
      tags: ['subdomain', 'domain', 'permutation', 'osint'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'url_tracker_cleaner',
      name: 'URL Tracker Cleaner',
      description: 'Remove tracking parameters (UTM, fbclid, etc.) from URLs.',
      category: ToolCategory.osint,
      icon: Icons.link_off,
      tags: ['url', 'tracking', 'clean', 'utm', 'privacy'],
      isAvailable: false,
    ),
  ];
}
