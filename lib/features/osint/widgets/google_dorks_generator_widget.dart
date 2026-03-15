import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';

class GoogleDorksGeneratorWidget extends ConsumerStatefulWidget {
  const GoogleDorksGeneratorWidget({super.key});

  @override
  ConsumerState<GoogleDorksGeneratorWidget> createState() =>
      _GoogleDorksGeneratorWidgetState();
}

class _GoogleDorksGeneratorWidgetState
    extends ConsumerState<GoogleDorksGeneratorWidget> {
  final _queryController = TextEditingController();
  String _selectedCategory = 'General';
  List<String> _generatedDorks = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  static const _historyKey = 'dorks_search_history';

  final Map<String, List<Map<String, String>>> _dorkTemplates = {
    'General': [
      {
        'operator': 'site:',
        'description': 'Recherche sur un site spécifique',
        'example': ''
      },
      {
        'operator': 'filetype:',
        'description': 'Recherche par type de fichier',
        'example': ''
      },
      {
        'operator': 'intitle:',
        'description': 'Recherche dans le titre',
        'example': ''
      },
      {
        'operator': 'inurl:',
        'description': 'Recherche dans l\'URL',
        'example': ''
      },
      {
        'operator': 'intext:',
        'description': 'Recherche dans le contenu',
        'example': ''
      },
      {
        'operator': 'cache:',
        'description': 'Version en cache Google',
        'example': ''
      },
    ],
    'Sensitive Files': [
      {
        'operator': 'ext:sql OR ext:dbf OR ext:mdb',
        'description': 'Fichiers de base de données',
        'example': ''
      },
      {'operator': 'ext:log', 'description': 'Fichiers de logs', 'example': ''},
      {
        'operator': 'ext:env OR ext:config',
        'description': 'Fichiers de configuration',
        'example': ''
      },
      {
        'operator': 'intext:"password" filetype:xls',
        'description': 'Fichiers contenant des mots de passe',
        'example': ''
      },
      {
        'operator': 'filetype:pem OR filetype:key',
        'description': 'Clés privées exposées',
        'example': ''
      },
    ],
    'Login Pages': [
      {
        'operator': 'inurl:login OR inurl:signin',
        'description': 'Pages de connexion',
        'example': ''
      },
      {
        'operator': 'intitle:"admin" inurl:admin',
        'description': 'Panneaux d\'administration',
        'example': ''
      },
      {
        'operator': 'inurl:wp-login.php',
        'description': 'Login WordPress',
        'example': ''
      },
      {
        'operator': 'inurl:"/cgi-bin/login"',
        'description': 'Login CGI',
        'example': ''
      },
    ],
    'APIs & Endpoints': [
      {
        'operator': 'inurl:"/api/v1/" OR inurl:"/api/v2/"',
        'description': 'Endpoints d\'API exposés',
        'example': ''
      },
      {
        'operator': 'inurl:swagger OR inurl:api-docs',
        'description': 'Documentation Swagger',
        'example': ''
      },
      {
        'operator': 'intext:"api_key" OR intext:"api_secret" filetype:json',
        'description': 'Clés d\'API exposées',
        'example': ''
      },
    ],
    'Cloud Storage': [
      {
        'operator': 'site:s3.amazonaws.com',
        'description': 'Buckets AWS S3 publics',
        'example': 'site:s3.amazonaws.com'
      },
      {
        'operator': 'site:storage.googleapis.com',
        'description': 'Buckets Google Cloud',
        'example': 'site:storage.googleapis.com'
      },
      {
        'operator': 'site:blob.core.windows.net',
        'description': 'Blobs Azure publics',
        'example': 'site:blob.core.windows.net'
      },
    ],
    'Webcams': [
      {
        'operator': 'inurl:view/index.shtml',
        'description': 'Webcams en direct',
        'example': 'inurl:view/index.shtml'
      },
      {
        'operator': 'inurl:ViewerFrame?mode=',
        'description': 'Visionneuses de caméras',
        'example': 'inurl:ViewerFrame?mode='
      },
      {
        'operator': 'intitle:"Live View / - AXIS"',
        'description': 'Caméras AXIS',
        'example': 'intitle:"Live View / - AXIS"'
      },
    ],
    'Vulnerabilities': [
      {
        'operator': 'inurl:prod_details.php?id=',
        'description': 'Cibles d\'injection SQL',
        'example': 'inurl:prod_details.php?id='
      },
      {
        'operator': 'ext:php intitle:phpinfo "published by the PHP Group"',
        'description': 'Pages phpinfo exposées',
        'example': 'ext:php intitle:phpinfo "published by the PHP Group"'
      },
      {
        'operator': 'inurl:/wp-content/plugins/',
        'description': 'Plugins WordPress',
        'example': 'inurl:/wp-content/plugins/'
      },
      {
        'operator': 'inurl:"/.git" intitle:"index of"',
        'description': 'Dépôts Git exposés',
        'example': 'inurl:"/.git" intitle:"index of"'
      },
    ],
    'IoT Devices': [
      {
        'operator': 'intitle:"RouterOS" inurl:"/winbox/"',
        'description': 'Routeurs MikroTik',
        'example': 'intitle:"RouterOS" inurl:"/winbox/"'
      },
      {
        'operator': 'intitle:"Hikvision" inurl:doc/page',
        'description': 'Caméras Hikvision',
        'example': ''
      },
      {
        'operator': 'inurl:8080 intitle:"Home Assistant"',
        'description': 'Domotique exposée',
        'example': ''
      },
    ],
    'Social OSINT': [
      {
        'operator': 'site:linkedin.com/in/',
        'description': 'Profils LinkedIn',
        'example': ''
      },
      {
        'operator': 'site:twitter.com OR site:x.com',
        'description': 'Profils Twitter/X',
        'example': ''
      },
      {
        'operator': 'site:github.com',
        'description': 'Profils GitHub',
        'example': ''
      },
    ],
    'Public Records': [
      {
        'operator': 'intitle:obituary OR obit',
        'description': 'Avis de décès',
        'example': ''
      },
      {
        'operator': 'site:gov filetype:pdf',
        'description': 'Documents gouvernementaux PDF',
        'example': ''
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw != null) {
      setState(() {
        _searchHistory = List<String>.from(jsonDecode(raw));
      });
    }
  }

  Future<void> _saveHistory(String query) async {
    if (query.isEmpty || _searchHistory.contains(query)) return;
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 10)
      _searchHistory = _searchHistory.sublist(0, 10);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(_searchHistory));
  }

  void _generateDorks() {
    final query = _queryController.text.trim();
    setState(() => _errorMessage = null);

    if (query.isEmpty) {
      setState(
          () => _errorMessage = 'Veuillez entrer un mot-clé ou un domaine.');
      return;
    }

    final templates = _dorkTemplates[_selectedCategory]!;
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _generatedDorks = templates.map((template) {
          if (template['example']!.isNotEmpty) return template['example']!;
          return '${template['operator']}$query';
        }).toList();
        _isLoading = false;
      });
      _saveHistory(query);
    });
  }

  void _copyDork(String dork) {
    Clipboard.setData(ClipboardData(text: dork));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copié : $dork'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyAll() {
    final all = _generatedDorks.join('\n');
    Clipboard.setData(ClipboardData(text: all));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tous les dorks copiés !'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _searchWithDork(String dork) async {
    final encoded = Uri.encodeComponent(dork);
    final url = Uri.parse('https://www.google.com/search?q=$encoded');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir le navigateur.')),
        );
      }
    }
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    setState(() => _searchHistory = []);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Google Dorks Generator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Google Dorks Generator',
              subtitle: 'Opérateurs de recherche avancés pour l\'OSINT',
            ),
            const SizedBox(height: 12),

            // Disclaimer légal
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningDim,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Usage éthique uniquement. Ces opérateurs sont destinés à la recherche OSINT légale et aux audits de sécurité autorisés.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Query Input
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: 'Mot-clé / Domaine cible',
                hintText: 'ex: github.com, password, admin',
                errorText: _errorMessage,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.bgSurface,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _queryController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _queryController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _generateDorks(),
            ),

            // Historique
            if (_searchHistory.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Récent :',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _searchHistory.take(5).map((h) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ActionChip(
                              label:
                                  Text(h, style: const TextStyle(fontSize: 11)),
                              onPressed: () {
                                _queryController.text = h;
                                setState(() {});
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Effacer l\'historique',
                    onPressed: _clearHistory,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Category Selector
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Catégorie',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.bgSurface,
              ),
              items: _dorkTemplates.keys.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(_categoryIcon(cat),
                          size: 16, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text(cat),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Générer les dorks',
              onPressed: _generateDorks,
              icon: Icons.auto_awesome,
            ),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],

            if (_generatedDorks.isNotEmpty && !_isLoading) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dorks générés (${_generatedDorks.length})',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 16,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.copy_all, size: 16),
                    label: const Text('Tout copier'),
                    onPressed: _copyAll,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._generatedDorks.asMap().entries.map((entry) {
                final index = entry.key;
                final dork = entry.value;
                final template = _dorkTemplates[_selectedCategory]![index];

                return Card(
                  color: AppColors.bgSurface,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.label_outline,
                                size: 14, color: AppColors.accent),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                template['description']!,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 12,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.infoDim,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.info),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                  dork,
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                onPressed: () => _copyDork(dork),
                                color: AppColors.accent,
                                tooltip: 'Copier',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                              IconButton(
                                icon: const Icon(Icons.open_in_new, size: 18),
                                onPressed: () => _searchWithDork(dork),
                                color: AppColors.success,
                                tooltip: 'Ouvrir dans Google',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            if (_generatedDorks.isEmpty && !_isLoading) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.travel_explore_outlined,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Entrez un mot-clé et sélectionnez\nune catégorie pour générer des dorks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'General' => Icons.search,
      'Sensitive Files' => Icons.insert_drive_file,
      'Login Pages' => Icons.lock_outline,
      'APIs & Endpoints' => Icons.code,
      'Cloud Storage' => Icons.cloud_outlined,
      'Webcams' => Icons.videocam_outlined,
      'Vulnerabilities' => Icons.bug_report_outlined,
      'IoT Devices' => Icons.devices_other,
      'Social OSINT' => Icons.people_outline,
      'Public Records' => Icons.article_outlined,
      _ => Icons.category_outlined,
    };
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
}
