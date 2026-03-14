import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class PasswordHistoryWidget extends ConsumerStatefulWidget {
  const PasswordHistoryWidget({super.key});

  @override
  ConsumerState<PasswordHistoryWidget> createState() =>
      _PasswordHistoryWidgetState();
}

class _PasswordHistoryWidgetState extends ConsumerState<PasswordHistoryWidget> {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device),
    mOptions: MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device),
    lOptions: LinuxOptions(),
    wOptions: WindowsOptions(),
  );

  static const String _storageKey = 'password_history_encrypted';
  List<PasswordEntry> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final encryptedData = await _storage.read(key: _storageKey);

      if (encryptedData != null && encryptedData.isNotEmpty) {
        // For MVP, we'll store as plain JSON (in production, encrypt this)
        final data = jsonDecode(encryptedData) as Map<String, dynamic>;
        final entries = data['entries'] as List<dynamic>;

        setState(() {
          _history = entries.map((e) => PasswordEntry.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _history = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load history: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveHistory() async {
    try {
      final data = {
        'entries': _history.map((e) => e.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // In production, encrypt this JSON before storing
      final encryptedData = jsonEncode(data);
      await _storage.write(key: _storageKey, value: encryptedData);
    } catch (e) {
      throw Exception('Failed to save history: ${e.toString()}');
    }
  }

  Future<void> _addEntry(String password, {String? note}) async {
    try {
      final entry = PasswordEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        password: password,
        createdAt: DateTime.now(),
        note: note,
      );

      setState(() {
        _history.insert(0, entry); // Add to top
        if (_history.length > 50) {
          _history = _history.sublist(0, 50); // Keep last 50
        }
      });

      await _saveHistory();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _deleteEntry(String id) async {
    try {
      setState(() {
        _history.removeWhere((entry) => entry.id == id);
      });
      await _saveHistory();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _clearHistory() async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgSurface,
          title: const Text(
            'Clear All History?',
            style: TextStyle(
                fontFamily: 'JetBrainsMono', color: AppColors.textPrimary),
          ),
          content: const Text(
            'This will permanently delete all saved passwords. This action cannot be undone.',
            style: TextStyle(
                fontFamily: 'JetBrainsMono', color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('CLEAR ALL',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        setState(() => _history = []);
        await _storage.delete(key: _storageKey);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('History cleared',
                  style: TextStyle(fontFamily: 'JetBrainsMono')),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _exportHistory() async {
    try {
      final data = {
        'exportedAt': DateTime.now().toIso8601String(),
        'count': _history.length,
        'entries': _history.map((e) => e.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${_history.length} passwords (check logs)',
                style: const TextStyle(fontFamily: 'JetBrainsMono')),
            backgroundColor: AppColors.info,
            duration: const Duration(seconds: 3),
          ),
        );

        // In production, use file_picker to save to file
        debugPrint('EXPORTED PASSWORD HISTORY:\n$jsonString');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'PASSWORD HISTORY',
      activeCategory: ToolCategory.password,
      showBackButton: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      border:
                          Border.all(color: AppColors.accent.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ENCRYPTED STORAGE',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_history.length} passwords stored securely',
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'EXPORT',
                          icon: Icons.download_outlined,
                          onPressed: _history.isEmpty ? null : _exportHistory,
                          variant: AppButtonVariant.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          label: 'CLEAR ALL',
                          icon: Icons.delete_outline,
                          onPressed: _history.isEmpty ? null : _clearHistory,
                          variant: AppButtonVariant.danger,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  SectionHeader(title: 'HISTORY (${_history.length})'),
                  const SizedBox(height: 12),

                  // Error Display
                  if (_error != null) ...[
                    ResultBox(content: _error!, isError: true),
                    const SizedBox(height: 16),
                  ],

                  // Empty State
                  if (_history.isEmpty && _error == null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.history,
                              size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text(
                            'No Password History',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Passwords you generate will appear here',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Password List
                  if (_history.isNotEmpty) ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final entry = _history[index];
                        return _PasswordHistoryCard(
                          entry: entry,
                          onDelete: () => _deleteEntry(entry.id),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _PasswordHistoryCard extends StatelessWidget {
  final PasswordEntry entry;
  final VoidCallback onDelete;

  const _PasswordHistoryCard({
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool showPassword = false;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.lock, color: AppColors.accent, size: 16),
            ),
            title: Text(
              'Password ••••••••',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  _formatDate(entry.createdAt),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (entry.note != null && entry.note!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.note!,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  size: 18, color: AppColors.textSecondary),
              color: AppColors.bgSurface,
              onSelected: (value) {
                if (value == 'copy') {
                  // Copy functionality would go here
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy,
                          size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text('Copy',
                          style: TextStyle(
                              fontFamily: 'JetBrainsMono', fontSize: 11)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: AppColors.danger),
                      SizedBox(width: 8),
                      Text('Delete',
                          style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.danger)),
                    ],
                  ),
                ),
              ],
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgBase,
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'PASSWORD:',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            showPassword = !showPassword;
                            setLocalState(() {});
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      showPassword
                          ? entry.password
                          : '•' * entry.password.length,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (entry.note != null && entry.note!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'NOTE:',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.note!,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class PasswordEntry {
  final String id;
  final String password;
  final DateTime createdAt;
  final String? note;

  PasswordEntry({
    required this.id,
    required this.password,
    required this.createdAt,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );
  }
}
