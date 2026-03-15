import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class GitignoreGeneratorWidget extends ConsumerStatefulWidget {
  const GitignoreGeneratorWidget({super.key});

  @override
  ConsumerState<GitignoreGeneratorWidget> createState() =>
      _GitignoreGeneratorWidgetState();
}

class _GitignoreGeneratorWidgetState
    extends ConsumerState<GitignoreGeneratorWidget> {
  final Map<String, bool> _selectedTemplates = {
    'Visual Studio': false,
    'VS Code': false,
    'IntelliJ': false,
    'Flutter': true,
    'Android': false,
    'iOS': false,
    'Node.js': false,
    'Python': false,
    'Java': false,
    'C#': false,
    'Go': false,
    'Rust': false,
    'Ruby': false,
    'PHP': false,
    'Swift': false,
    'React Native': false,
    'Docker': false,
    'Linux': false,
    'macOS': false,
    'Windows': false,
  };

  String _result = '';

  final Map<String, String> _templates = {
    'Visual Studio': '''
## Visual Studio
.vs/
*.user
*.suo
*.userosscache
*.sln.docstates
[Dd]ebug/
[Rr]elease/
x64/
x86/
[Aa][Rr][Mm]/
[Aa][Rr][Mm]64/
bld/
[Bb]in/
[Oo]bj/
[Ll]og/
[Ll]ogs/
''',
    'VS Code': '''
## VS Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.code-workspace
.history/
''',
    'IntelliJ': '''
## IntelliJ IDEA
.idea/
*.iml
*.ipr
*.iws
out/
target/
build/
.gradle/
''',
    'Flutter': '''
## Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/
*.lock
''',
    'Android': '''
## Android
*.iml
.gradle
/local.properties
/.idea/caches
/.idea/libraries
/.idea/modules.xml
/.idea/workspace.xml
/.idea/navEditor.xml
/.idea/assetWizardSettings.xml
.DS_Store
/build
/captures
.externalNativeBuild
.cxx
local.properties
''',
    'iOS': '''
## iOS/Xcode
.DS_Store
**/*.xcworkspace
!*.xcworkspace
**/xcuserdata
DerivedData/
**/Pods/
''',
    'Node.js': '''
## Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm
.yarn
dist/
build/
''',
    'Python': r'''## Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.pytest_cache/
.coverage
htmlcov/
.tox/
.nox/
''',
    'Java': '''
## Java
*.class
*.jar
*.war
*.ear
target/
build/
out/
bin/
gen/
''',
    'C#': '''
## C# / .NET
[Dd]ebug/
[Rr]elease/
x64/
x86/
[Aa][Rr][Mm]/
[Bb]in/
[Oo]bj/
*.dll
*.exe
*.pdb
*.log
''',
    'Go': '''
## Go
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
vendor/
''',
    'Rust': '''
## Rust
/target/
**/*.rs.bk
Cargo.lock
''',
    'Ruby': '''
## Ruby
*.gem
*.rbc
.bundle/
vendor/bundle
Gemfile.lock
.ruby-version
.ruby-gemset
coverage/
spec/reports/
tmp/
''',
    'PHP': '''
## PHP
/vendor/
composer.lock
.phpunit.result.cache
.env
.env.local
''',
    'Swift': '''
## Swift
.DS_Store
.swiftpm/
Packages/
Package.pins
Package.resolved
build/
''',
    'React Native': '''
## React Native
node_modules/
ios/Pods/
android/app/build/
android/.gradle/
*.jks
*.p8
*.p12
*.key
*.mobileprovision
*.orig.*
ios/build/
''',
    'Docker': '''
## Docker
.docker/
docker-compose*.yml
*.dockerfile
''',
    'Linux': '''
## Linux
*~
.fuse_hidden*
.Trash-*
.nfs-*
.directory
.stfolder
''',
    'macOS': '''
## macOS
.DS_Store
.AppleDouble
.LSOverride
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk
''',
    'Windows': r'''## Windows
Thumbs.db
ehthumbs.db
Desktop.ini
$RECYCLE.BIN/
@eaDir/
''',
  };

  void _generateGitignore() {
    final selected = _selectedTemplates.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (selected.isEmpty) {
      setState(() => _result = 'Please select at least one template');
      return;
    }

    try {
      final buffer = StringBuffer();
      buffer.writeln('# Generated .gitignore');
      buffer.writeln('# Created with Hackers App\n');

      for (final template in selected) {
        buffer.writeln(_templates[template]);
      }

      // Add common additions
      buffer.writeln('''
# Common additions
*.log
*.tmp
*.swp
*.swo
*~
.env
.env.local
.env.*.local
*.bak
*.old
''');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedTemplates.values.where((v) => v).length;

    return AppScaffold(
      title: '.GITIGNORE GENERATOR',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'SELECT TEMPLATES'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedTemplates.keys.map((template) {
                final isSelected = _selectedTemplates[template]!;
                return FilterChip(
                  label: Text(template),
                  selected: isSelected,
                  onSelected: (value) {
                    setState(() => _selectedTemplates[template] = value);
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
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateGitignore,
                icon: const Icon(Icons.file_present),
                label: Text('GENERATE .GITIGNORE ($selectedCount selected)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: '.GITIGNORE FILE',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
