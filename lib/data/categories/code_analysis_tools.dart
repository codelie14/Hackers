import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// CODE ANALYSIS TOOLS
/// Source Code Security & Vulnerability Detection
/// ────────────────────────────────────────────────────────────

class CodeAnalysisTools {
  CodeAnalysisTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'secret_detector',
      name: 'Secret Detector',
      description:
          'Detect hardcoded API keys, passwords, and credentials in source code.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.manage_search,
      tags: ['secrets', 'api-key', 'credentials', 'scan', 'security'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'xss_sqli_detector',
      name: 'Vulnerability Pattern Detector',
      description:
          'Detect common SQL injection, XSS, and security anti-patterns in code.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.bug_report_outlined,
      tags: ['xss', 'sqli', 'vulnerability', 'pattern', 'sast'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'dep_analyzer',
      name: 'Dependency Analyzer',
      description:
          'Analyze package.json and requirements.txt for known CVE-affected versions.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.account_tree_outlined,
      tags: ['dependency', 'cve', 'npm', 'pip', 'vulnerability'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'js_deobfuscator',
      name: 'JS Deobfuscator',
      description:
          'Basic JavaScript deobfuscation and readable code extraction.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.code_off,
      tags: ['javascript', 'deobfuscate', 'obfuscation'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'dockerfile_gen',
      name: 'Dockerfile Generator',
      description: 'Generate Dockerfile templates for common tech stacks.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.layers,
      tags: ['docker', 'dockerfile', 'container', 'generate'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'cicd_gen',
      name: 'CI/CD Pipeline Generator',
      description:
          'Generate GitHub Actions and GitLab CI pipeline configurations.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.merge_type,
      tags: ['cicd', 'github-actions', 'pipeline', 'devops'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'nginx_gen',
      name: 'Nginx Config Generator',
      description:
          'Generate Nginx server block configurations with SSL and security headers.',
      category: ToolCategory.codeAnalysis,
      icon: Icons.web,
      tags: ['nginx', 'apache', 'server', 'config', 'generate'],
      isAvailable: false,
    ),
  ];
}
