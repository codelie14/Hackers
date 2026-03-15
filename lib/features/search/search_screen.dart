import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/widgets/search_overlay.dart';
import '../../shared/widgets/app_scaffold.dart';

/// Search screen with full-screen search overlay
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Auto-open search on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSearchOverlay();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchOverlay() {
    setState(() => _isSearching = true);
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => SearchOverlay(
        onDismiss: () {
          setState(() => _isSearching = false);
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SEARCH',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppGradients.accent,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'SEARCH TOOLS',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Subtitle
            Text(
              'Find tools by name, category, or function',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Search button
            ElevatedButton.icon(
              onPressed: _showSearchOverlay,
              icon: const Icon(Icons.search_rounded),
              label: const Text('OPEN SEARCH'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
