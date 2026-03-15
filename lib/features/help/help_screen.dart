import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../shared/widgets/app_scaffold.dart';

/// Help screen with tutorials and documentation
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HELP & TUTORIALS',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          _buildWelcomeCard(),

          const SizedBox(height: 24),

          // Getting Started Section
          _buildSectionTitle('GETTING STARTED'),
          _buildHelpCard([
            _buildHelpItem(
              icon: Icons.play_arrow_rounded,
              title: 'Quick Start Guide',
              description: 'Learn the basics in 5 minutes',
              color: AppColors.accent,
              onTap: () {},
            ),
            _buildHelpItem(
              icon: Icons.explore_outlined,
              title: 'App Navigation',
              description: 'How to navigate through tools',
              color: Colors.blue,
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // Tool Categories
          _buildSectionTitle('TOOL CATEGORIES'),
          _buildHelpCard([
            _buildHelpItem(
              icon: Icons.vpn_key_outlined,
              title: 'Password Tools',
              description: 'Generate and analyze passwords',
              color: Colors.purple,
              onTap: () {},
            ),
            _buildHelpItem(
              icon: Icons.security_outlined,
              title: 'Crypto Tools',
              description: 'Encrypt and decrypt data',
              color: Colors.orange,
              onTap: () {},
            ),
            _buildHelpItem(
              icon: Icons.code_outlined,
              title: 'Encode/Decode',
              description: 'Various encoding formats',
              color: Colors.green,
              onTap: () {},
            ),
            _buildHelpItem(
              icon: Icons.wifi_outlined,
              title: 'Network Tools',
              description: 'Network analysis utilities',
              color: Colors.cyan,
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // Tutorials
          _buildSectionTitle('TUTORIALS'),
          _buildHelpCard([
            _buildTutorialItem(
              title: 'Creating Strong Passwords',
              duration: '5 min',
              level: 'Beginner',
              onTap: () {},
            ),
            _buildTutorialItem(
              title: 'Understanding Encryption',
              duration: '10 min',
              level: 'Intermediate',
              onTap: () {},
            ),
            _buildTutorialItem(
              title: 'Base64 Encoding Explained',
              duration: '8 min',
              level: 'Beginner',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // FAQ
          _buildSectionTitle('FREQUENTLY ASKED QUESTIONS'),
          _buildHelpCard([
            _buildFAQItem(
              question: 'Is this app completely offline?',
              answer:
                  'Yes! All tools work without internet connection. Your data never leaves your device.',
            ),
            _buildFAQItem(
              question: 'How do I report a bug?',
              answer:
                  'Visit our GitHub repository and create an issue with detailed information about the problem.',
            ),
            _buildFAQItem(
              question: 'Can I suggest new tools?',
              answer:
                  'Absolutely! We welcome suggestions. Check the ROADMAP.md file for planned features.',
            ),
          ]),

          const SizedBox(height: 32),

          // Support Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.accent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite_outline_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Support the Project',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help us keep this app free and open source',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('SUPPORT ON GITHUB'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppGradients.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Hackers!',
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your offline security toolkit',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Explore 350+ cybersecurity tools organized by category. Everything works offline, no internet required.',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildHelpCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialItem({
    required String title,
    required String duration,
    required String level,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildChip(Icons.access_time_rounded, duration),
                      const SizedBox(width: 8),
                      _buildChip(Icons.auto_graph_rounded, level),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_outline_rounded,
              size: 32,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      leading: Icon(
        Icons.help_outline_rounded,
        color: AppColors.accent,
      ),
      title: Text(
        question,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
