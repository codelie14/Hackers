import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class HttpStatusWidget extends ConsumerStatefulWidget {
  const HttpStatusWidget({super.key});

  @override
  ConsumerState<HttpStatusWidget> createState() => _HttpStatusWidgetState();
}

class _HttpStatusWidgetState extends ConsumerState<HttpStatusWidget> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  static final Map<int, HttpCodeInfo> _codes = {
    100: const HttpCodeInfo('Continue', 'Informational',
        'The server has received the request headers'),
    101: const HttpCodeInfo(
        'Switching Protocols', 'Informational', 'Protocol is being switched'),
    102: const HttpCodeInfo(
        'Processing', 'Informational', 'Request is being processed'),
    200: const HttpCodeInfo('OK', 'Success', 'Request succeeded successfully'),
    201: const HttpCodeInfo('Created', 'Success', 'Resource was created'),
    202: const HttpCodeInfo(
        'Accepted', 'Success', 'Request accepted for processing'),
    204: const HttpCodeInfo(
        'No Content', 'Success', 'Request succeeded with no content'),
    206: const HttpCodeInfo(
        'Partial Content', 'Success', 'Partial GET request succeeded'),
    300: const HttpCodeInfo(
        'Multiple Choices', 'Redirection', 'Multiple options for the resource'),
    301: const HttpCodeInfo(
        'Moved Permanently', 'Redirection', 'Resource moved permanently'),
    302: const HttpCodeInfo(
        'Found', 'Redirection', 'Resource temporarily moved'),
    304: const HttpCodeInfo(
        'Not Modified', 'Redirection', 'Resource not modified (cached)'),
    307: const HttpCodeInfo(
        'Temporary Redirect', 'Redirection', 'Temporary redirect'),
    308: const HttpCodeInfo(
        'Permanent Redirect', 'Redirection', 'Permanent redirect'),
    400: const HttpCodeInfo(
        'Bad Request', 'Client Error', 'Server cannot process the request'),
    401: const HttpCodeInfo(
        'Unauthorized', 'Client Error', 'Authentication required'),
    403: const HttpCodeInfo('Forbidden', 'Client Error', 'Access denied'),
    404: const HttpCodeInfo('Not Found', 'Client Error', 'Resource not found'),
    405: const HttpCodeInfo(
        'Method Not Allowed', 'Client Error', 'HTTP method not allowed'),
    408: const HttpCodeInfo(
        'Request Timeout', 'Client Error', 'Server timed out waiting'),
    409: const HttpCodeInfo(
        'Conflict', 'Client Error', 'Request conflicts with current state'),
    415: const HttpCodeInfo(
        'Unsupported Media Type', 'Client Error', 'Media format not supported'),
    429: const HttpCodeInfo(
        'Too Many Requests', 'Client Error', 'Rate limit exceeded'),
    500: const HttpCodeInfo(
        'Internal Server Error', 'Server Error', 'Generic server error'),
    501: const HttpCodeInfo(
        'Not Implemented', 'Server Error', 'Feature not supported'),
    502: const HttpCodeInfo(
        'Bad Gateway', 'Server Error', 'Invalid response from upstream'),
    503: const HttpCodeInfo('Service Unavailable', 'Server Error',
        'Server temporarily unavailable'),
    504: const HttpCodeInfo(
        'Gateway Timeout', 'Server Error', 'Upstream server timeout'),
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MapEntry<int, HttpCodeInfo>> _filterCodes() {
    final query = _searchController.text.toLowerCase().trim();
    final category = _selectedCategory;

    return _codes.entries.where((entry) {
      final code = entry.key;
      final info = entry.value;

      if (category != 'All' && info.category != category) return false;
      if (query.isEmpty) return true;

      return code.toString().contains(query) ||
          info.name.toLowerCase().contains(query) ||
          info.description.toLowerCase().contains(query);
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Informational':
        return AppColors.info;
      case 'Success':
        return AppColors.success;
      case 'Redirection':
        return AppColors.warning;
      case 'Client Error':
        return AppColors.danger;
      case 'Server Error':
        return AppColors.danger;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCodes = _filterCodes();
    final categories = [
      'All',
      'Informational',
      'Success',
      'Redirection',
      'Client Error',
      'Server Error'
    ];

    return AppScaffold(
      title: 'HTTP STATUS CODES',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'SEARCH'),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by code, name, or description...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'CATEGORY'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: 'CODES (${filteredCodes.length})'),
            const SizedBox(height: 12),
            ...filteredCodes.map((entry) {
              final code = entry.key;
              final info = entry.value;
              final color = _getCategoryColor(info.category);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  border: Border.all(color: color.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '$code',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    info.name,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${info.category}',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.05),
                        border: Border(
                          top: BorderSide(color: color.withOpacity(0.2)),
                        ),
                      ),
                      child: Text(
                        info.description,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class HttpCodeInfo {
  final String name;
  final String category;
  final String description;

  const HttpCodeInfo(this.name, this.category, this.description);
}
