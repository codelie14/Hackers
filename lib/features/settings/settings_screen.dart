import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../shared/widgets/app_scaffold.dart';

/// Settings screen with app configuration options
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SETTINGS',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionTitle('APPEARANCE'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Dark (Coming Soon)',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.format_size,
              title: 'Font Size',
              subtitle: 'Medium (Coming Soon)',
              onTap: () {},
            ),
          ]),
          
          const SizedBox(height: 24),
          
          // Privacy & Security
          _buildSectionTitle('PRIVACY & SECURITY'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'App Lock',
              subtitle: 'Disabled (Coming Soon)',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.visibility_off_outlined,
              title: 'Incognito Mode',
              subtitle: 'Off (Coming Soon)',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.delete_outline,
              title: 'Clear History',
              subtitle: 'Delete all tool usage history',
              onTap: () => _showClearHistoryDialog(context),
            ),
          ]),
          
          const SizedBox(height: 24),
          
          // Data & Storage
          _buildSectionTitle('DATA & STORAGE'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.folder_outlined,
              title: 'Storage Location',
              subtitle: 'Internal Storage',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.backup_outlined,
              title: 'Backup & Restore',
              subtitle: 'Coming Soon',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.download_outlined,
              title: 'Download Additional Tools',
              subtitle: 'All tools installed',
              onTap: () {},
            ),
          ]),
          
          const SizedBox(height: 24),
          
          // About
          _buildSectionTitle('ABOUT'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: 'Licenses',
              subtitle: 'View open source licenses',
              onTap: () => showLicensePage(context: context),
            ),
            _buildSettingItem(
              icon: Icons.code_outlined,
              title: 'Source Code',
              subtitle: 'View on GitHub',
              onTap: () {},
            ),
          ]),
          
          const SizedBox(height: 32),
          
          // Reset button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showResetDialog(context),
              icon: const Icon(Icons.refresh_outlined),
              label: const Text('RESET ALL SETTINGS'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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

  Widget _buildSettingsCard(List<Widget> children) {
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.textSecondary,
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
                    subtitle,
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

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Clear History?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will delete all your tool usage history. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Clear history logic
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Reset All Settings?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will reset all app settings to their default values.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Reset settings logic
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }
}
