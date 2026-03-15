import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

enum PortStatus { open, closed, filtered, timeout }

enum RiskLevel { none, low, medium, high, critical }

class PortResult {
  final int port;
  final PortStatus status;
  final String service;
  final String? banner;
  final int responseMs;
  final RiskLevel risk;
  final String? riskNote;

  const PortResult({
    required this.port,
    required this.status,
    required this.service,
    this.banner,
    required this.responseMs,
    required this.risk,
    this.riskNote,
  });
}

class PortScannerWidget extends ConsumerStatefulWidget {
  const PortScannerWidget({super.key});

  @override
  ConsumerState<PortScannerWidget> createState() => _PortScannerWidgetState();
}

class _PortScannerWidgetState extends ConsumerState<PortScannerWidget> {
  // ── Controllers ──────────────────────────────────────────────
  final _hostController = TextEditingController();
  final _startPortController = TextEditingController(text: '1');
  final _endPortController = TextEditingController(text: '1024');
  final _customPortsController = TextEditingController();

  // ── State ────────────────────────────────────────────────────
  String _result = '';
  bool _isScanning = false;
  bool _cancelled = false;
  int _currentPort = 0;
  int _totalPorts = 0;
  int _scannedPorts = 0;
  String _scanMode = 'RANGE'; // RANGE | PRESET | CUSTOM
  String _selectedPreset = 'COMMON';
  int _timeout = 500; // ms
  int _concurrency = 50;
  bool _grabBanners = false;
  bool _showClosed = false;
  String _outputFormat = 'TABLE'; // TABLE | TEXT | JSON

  final List<PortResult> _openResults = [];

  // ── Port database ─────────────────────────────────────────────
  static const Map<int, Map<String, dynamic>> _portDb = {
    // ── Web / HTTP
    80: {
      'name': 'HTTP',
      'proto': 'TCP',
      'risk': 'low',
      'note': 'Unencrypted web — check for sensitive data exposure'
    },
    443: {'name': 'HTTPS', 'proto': 'TCP', 'risk': 'none', 'note': null},
    8080: {
      'name': 'HTTP-Alt',
      'proto': 'TCP',
      'risk': 'low',
      'note': 'Dev/proxy server — often misconfigured'
    },
    8443: {'name': 'HTTPS-Alt', 'proto': 'TCP', 'risk': 'none', 'note': null},
    8008: {'name': 'HTTP-Alt2', 'proto': 'TCP', 'risk': 'low', 'note': null},
    3000: {
      'name': 'Node/Dev',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Dev server exposed — check auth'
    },
    4200: {
      'name': 'Angular Dev',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Dev server exposed'
    },
    5000: {
      'name': 'Flask/Dev',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Dev server exposed — often no auth'
    },
    // ── Email
    25: {
      'name': 'SMTP',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Open relay risk — test for spam relay'
    },
    465: {'name': 'SMTPS', 'proto': 'TCP', 'risk': 'low', 'note': null},
    587: {'name': 'SMTP-TLS', 'proto': 'TCP', 'risk': 'low', 'note': null},
    110: {
      'name': 'POP3',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Unencrypted — credentials in cleartext'
    },
    995: {'name': 'POP3S', 'proto': 'TCP', 'risk': 'none', 'note': null},
    143: {
      'name': 'IMAP',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Unencrypted — credentials in cleartext'
    },
    993: {'name': 'IMAPS', 'proto': 'TCP', 'risk': 'none', 'note': null},
    // ── File transfer
    20: {
      'name': 'FTP-Data',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Unencrypted file transfer'
    },
    21: {
      'name': 'FTP',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Cleartext auth + anonymous login risk'
    },
    22: {
      'name': 'SSH',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Check for weak passwords / old versions'
    },
    69: {
      'name': 'TFTP',
      'proto': 'UDP',
      'risk': 'high',
      'note': 'No auth — unauthenticated file access'
    },
    // ── Remote access
    23: {
      'name': 'Telnet',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Cleartext protocol — never use on public nets'
    },
    3389: {
      'name': 'RDP',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'BlueKeep, DejaBlue risk — check patch level'
    },
    5900: {
      'name': 'VNC',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Often no auth or weak password'
    },
    5901: {
      'name': 'VNC-1',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'VNC display :1'
    },
    5902: {
      'name': 'VNC-2',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'VNC display :2'
    },
    // ── DNS / Network
    53: {
      'name': 'DNS',
      'proto': 'TCP/UDP',
      'risk': 'medium',
      'note': 'Test for DNS zone transfer (AXFR)'
    },
    67: {
      'name': 'DHCP-Server',
      'proto': 'UDP',
      'risk': 'medium',
      'note': 'Rogue DHCP server risk'
    },
    68: {'name': 'DHCP-Client', 'proto': 'UDP', 'risk': 'low', 'note': null},
    123: {
      'name': 'NTP',
      'proto': 'UDP',
      'risk': 'medium',
      'note': 'NTP amplification DDoS risk'
    },
    161: {
      'name': 'SNMP',
      'proto': 'UDP',
      'risk': 'high',
      'note': 'Default community string "public" — info leak'
    },
    162: {'name': 'SNMP-Trap', 'proto': 'UDP', 'risk': 'medium', 'note': null},
    // ── Directory / Auth
    389: {
      'name': 'LDAP',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Unencrypted directory access'
    },
    636: {'name': 'LDAPS', 'proto': 'TCP', 'risk': 'low', 'note': null},
    88: {
      'name': 'Kerberos',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'AS-REP roasting / Kerberoasting risk'
    },
    // ── Windows / SMB
    135: {
      'name': 'MSRPC',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'EternalBlue pivot — patch immediately'
    },
    137: {
      'name': 'NetBIOS-NS',
      'proto': 'UDP',
      'risk': 'high',
      'note': 'NetBIOS name poisoning risk'
    },
    138: {'name': 'NetBIOS-DGM', 'proto': 'UDP', 'risk': 'high', 'note': null},
    139: {
      'name': 'NetBIOS-SSN',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Legacy SMB — disable if not needed'
    },
    445: {
      'name': 'SMB',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'EternalBlue (MS17-010) — check patch level'
    },
    // ── Databases
    1433: {
      'name': 'MSSQL',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Database exposed — brute force risk'
    },
    1434: {
      'name': 'MSSQL-UDP',
      'proto': 'UDP',
      'risk': 'high',
      'note': 'MSSQL Browser service — info disclosure'
    },
    1521: {
      'name': 'Oracle',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Database exposed'
    },
    3306: {
      'name': 'MySQL',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Database exposed — brute force / CVE risk'
    },
    5432: {
      'name': 'PostgreSQL',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Database exposed'
    },
    5984: {
      'name': 'CouchDB',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Often no auth by default'
    },
    6379: {
      'name': 'Redis',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'No auth by default — RCE via config write'
    },
    27017: {
      'name': 'MongoDB',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'No auth by default — data exposure'
    },
    9042: {
      'name': 'Cassandra',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Database exposed'
    },
    7474: {
      'name': 'Neo4j',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Graph DB — check auth'
    },
    // ── Search / Metrics
    9200: {
      'name': 'Elasticsearch',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'No auth by default — data exfil risk'
    },
    9300: {
      'name': 'ES-Cluster',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Elasticsearch cluster comms'
    },
    5601: {
      'name': 'Kibana',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Kibana UI — check auth'
    },
    8086: {
      'name': 'InfluxDB',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Time-series DB — check auth'
    },
    3000: {
      'name': 'Grafana',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Default creds admin/admin'
    },
    // ── Message queues / Cache
    5672: {
      'name': 'RabbitMQ',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Default creds guest/guest'
    },
    15672: {
      'name': 'RabbitMQ-UI',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Management UI — default creds'
    },
    9092: {
      'name': 'Kafka',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'No auth by default'
    },
    11211: {
      'name': 'Memcached',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'No auth — data leak + DDoS amplifier'
    },
    // ── Container / Cloud
    2375: {
      'name': 'Docker',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Unauthenticated Docker daemon — full RCE'
    },
    2376: {
      'name': 'Docker-TLS',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Docker with TLS — check cert validation'
    },
    2379: {
      'name': 'etcd',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Kubernetes secrets store — no auth = disaster'
    },
    2380: {
      'name': 'etcd-peer',
      'proto': 'TCP',
      'risk': 'critical',
      'note': null
    },
    6443: {
      'name': 'K8s API',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Kubernetes API server'
    },
    10250: {
      'name': 'Kubelet',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Kubelet API — exec into pods'
    },
    // ── CI/CD / Dev tools
    8888: {
      'name': 'Jupyter',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'No auth by default — code execution'
    },
    4848: {
      'name': 'GlassFish',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Java app server admin'
    },
    8161: {
      'name': 'ActiveMQ-UI',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Default creds admin/admin'
    },
    9090: {
      'name': 'Prometheus',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Metrics exposure'
    },
    // ── Misc services
    119: {'name': 'NNTP', 'proto': 'TCP', 'risk': 'low', 'note': null},
    514: {
      'name': 'Syslog',
      'proto': 'UDP',
      'risk': 'medium',
      'note': 'Log injection risk'
    },
    631: {
      'name': 'IPP/CUPS',
      'proto': 'TCP',
      'risk': 'medium',
      'note': 'Printer service — info disclosure'
    },
    873: {
      'name': 'rsync',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Unauthenticated rsync = file exfil'
    },
    2049: {
      'name': 'NFS',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'No auth — filesystem exposure'
    },
    3690: {
      'name': 'SVN',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'Source code exposure'
    },
    4444: {
      'name': 'Metasploit',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Common backdoor/C2 port'
    },
    5555: {
      'name': 'ADB',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Android Debug Bridge — full device access'
    },
    8888: {'name': 'HTTP-Dev', 'proto': 'TCP', 'risk': 'medium', 'note': null},
    9999: {'name': 'Urchin', 'proto': 'TCP', 'risk': 'low', 'note': null},
    47808: {
      'name': 'BACnet',
      'proto': 'UDP',
      'risk': 'critical',
      'note': 'Building automation — ICS/SCADA exposure'
    },
    102: {
      'name': 'Siemens S7',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Industrial PLC — SCADA/ICS'
    },
    502: {
      'name': 'Modbus',
      'proto': 'TCP',
      'risk': 'critical',
      'note': 'Industrial protocol — no auth'
    },
    1883: {
      'name': 'MQTT',
      'proto': 'TCP',
      'risk': 'high',
      'note': 'IoT protocol — often no auth'
    },
    8883: {
      'name': 'MQTT-TLS',
      'proto': 'TCP',
      'risk': 'low',
      'note': 'MQTT over TLS'
    },
  };

  // ── Port presets ──────────────────────────────────────────────
  static const Map<String, List<int>> _presets = {
    'COMMON': [
      21,
      22,
      23,
      25,
      53,
      80,
      110,
      111,
      135,
      139,
      143,
      443,
      445,
      993,
      995,
      1723,
      3306,
      3389,
      5900,
      8080
    ],
    'WEB': [
      80,
      443,
      8080,
      8443,
      8008,
      3000,
      4200,
      5000,
      8888,
      9090,
      4848,
      5601,
      15672
    ],
    'DB': [
      1433,
      1434,
      1521,
      3306,
      5432,
      5984,
      6379,
      7474,
      9042,
      9200,
      9300,
      27017
    ],
    'REMOTE': [22, 23, 3389, 5900, 5901, 5902],
    'MAIL': [25, 110, 143, 465, 587, 993, 995],
    'SMB': [135, 137, 138, 139, 445],
    'ICS': [102, 502, 1883, 4840, 8883, 47808],
    'DEVOPS': [2375, 2376, 2379, 2380, 6443, 8080, 9090, 10250],
    'TOP100': [
      21,
      22,
      23,
      25,
      53,
      80,
      110,
      111,
      119,
      123,
      135,
      137,
      138,
      139,
      143,
      161,
      162,
      389,
      443,
      445,
      465,
      514,
      587,
      631,
      636,
      873,
      993,
      995,
      1433,
      1434,
      1521,
      1883,
      2049,
      2375,
      2376,
      2379,
      2380,
      3000,
      3306,
      3389,
      3690,
      4444,
      4848,
      5432,
      5555,
      5672,
      5900,
      5901,
      5984,
      6379,
      6443,
      7474,
      8080,
      8161,
      8443,
      8888,
      9042,
      9090,
      9092,
      9200,
      9300,
      10250,
      11211,
      15672,
      27017,
      47808,
    ],
  };

  // ── Getters ───────────────────────────────────────────────────
  List<int> get _portsToScan {
    switch (_scanMode) {
      case 'PRESET':
        return List.from(_presets[_selectedPreset] ?? _presets['COMMON']!);
      case 'CUSTOM':
        return _parseCustomPorts(_customPortsController.text);
      default: // RANGE
        final start = int.tryParse(_startPortController.text) ?? 1;
        final end = int.tryParse(_endPortController.text) ?? 1024;
        return List.generate(
          (end - start + 1).clamp(0, 65535),
          (i) => start + i,
        );
    }
  }

  List<int> _parseCustomPorts(String input) {
    final ports = <int>{};
    for (final part in input.split(',')) {
      final trimmed = part.trim();
      if (trimmed.contains('-')) {
        final range = trimmed.split('-');
        final s = int.tryParse(range[0].trim());
        final e = int.tryParse(range.length > 1 ? range[1].trim() : '');
        if (s != null && e != null) {
          for (var p = s; p <= e && p <= 65535; p++) ports.add(p);
        }
      } else {
        final p = int.tryParse(trimmed);
        if (p != null && p >= 1 && p <= 65535) ports.add(p);
      }
    }
    return ports.toList()..sort();
  }

  // ── Scanner ───────────────────────────────────────────────────
  Future<void> _scanPorts() async {
    final host = _hostController.text.trim();
    if (host.isEmpty) {
      setState(() => _result = '[ERROR] Please enter a target host.');
      return;
    }

    final ports = _portsToScan;
    if (ports.isEmpty) {
      setState(() => _result = '[ERROR] No valid ports to scan.');
      return;
    }

    setState(() {
      _isScanning = true;
      _cancelled = false;
      _result = '';
      _totalPorts = ports.length;
      _scannedPorts = 0;
      _currentPort = ports.first;
      _openResults.clear();
    });

    final stopwatch = Stopwatch()..start();

    try {
      // Concurrent scan using chunks
      final chunk = _concurrency.clamp(1, 200);
      for (var i = 0; i < ports.length; i += chunk) {
        if (_cancelled) break;
        final batch = ports.sublist(i, (i + chunk).clamp(0, ports.length));
        final futures = batch.map((p) => _scanSinglePort(host, p));
        final results = await Future.wait(futures);
        for (final r in results) {
          if (r != null && r.status == PortStatus.open) {
            setState(() => _openResults.add(r));
          }
        }
        setState(() {
          _scannedPorts = (i + chunk).clamp(0, ports.length);
          _currentPort = batch.last;
        });
        // Yield to UI
        await Future.delayed(const Duration(milliseconds: 1));
      }
    } catch (e) {
      setState(() => _result = '[ERROR] $e');
    }

    stopwatch.stop();

    if (!_cancelled) {
      setState(() {
        _result =
            _buildOutput(host, ports.length, stopwatch.elapsedMilliseconds);
        _isScanning = false;
      });
    } else {
      setState(() {
        _result =
            '[CANCELLED] Scan stopped by user after ${_scannedPorts}/${_totalPorts} ports.';
        _isScanning = false;
      });
    }
  }

  Future<PortResult?> _scanSinglePort(String host, int port) async {
    final sw = Stopwatch()..start();
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: Duration(milliseconds: _timeout),
      );
      sw.stop();

      String? banner;
      if (_grabBanners) {
        try {
          socket.write('\r\n');
          final data =
              await socket.first.timeout(const Duration(milliseconds: 800));
          banner = String.fromCharCodes(data)
              .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), ' ')
              .trim();
          if (banner.length > 120) banner = '${banner.substring(0, 120)}…';
        } catch (_) {}
      }

      socket.destroy();

      final info = _portDb[port];
      final service = info?['name'] as String? ?? 'Unknown';
      final risk = _parseRisk(info?['risk'] as String?);
      final note = info?['note'] as String?;

      return PortResult(
        port: port,
        status: PortStatus.open,
        service: service,
        banner: banner,
        responseMs: sw.elapsedMilliseconds,
        risk: risk,
        riskNote: note,
      );
    } on SocketException {
      sw.stop();
      return PortResult(
        port: port,
        status: PortStatus.closed,
        service: _portDb[port]?['name'] as String? ?? 'Unknown',
        responseMs: sw.elapsedMilliseconds,
        risk: RiskLevel.none,
      );
    } on TimeoutException {
      return PortResult(
        port: port,
        status: PortStatus.timeout,
        service: _portDb[port]?['name'] as String? ?? 'Unknown',
        responseMs: _timeout,
        risk: RiskLevel.none,
      );
    } catch (_) {
      return null;
    }
  }

  RiskLevel _parseRisk(String? s) => switch (s) {
        'critical' => RiskLevel.critical,
        'high' => RiskLevel.high,
        'medium' => RiskLevel.medium,
        'low' => RiskLevel.low,
        _ => RiskLevel.none,
      };

  // ── Output builders ───────────────────────────────────────────
  String _buildOutput(String host, int total, int ms) {
    return switch (_outputFormat) {
      'JSON' => _toJson(host, total, ms),
      'TEXT' => _toText(host, total, ms),
      _ => _toTable(host, total, ms),
    };
  }

  String _toTable(String host, int total, int ms) {
    final b = StringBuffer();
    final open = _openResults;

    b.writeln('PORT SCAN REPORT');
    b.writeln('═══════════════════════════════════════');
    b.writeln('Host     : $host');
    b.writeln(
        'Mode     : $_scanMode${_scanMode == 'PRESET' ? ' [$_selectedPreset]' : ''}');
    b.writeln('Ports    : $total scanned');
    b.writeln('Open     : ${open.length}');
    b.writeln('Duration : ${ms}ms');
    b.writeln('Banners  : ${_grabBanners ? 'YES' : 'NO'}');
    b.writeln('═══════════════════════════════════════\n');

    if (open.isEmpty) {
      b.writeln('No open ports found.\n');
      return b.toString();
    }

    // Risk summary
    final critical = open.where((r) => r.risk == RiskLevel.critical).length;
    final high = open.where((r) => r.risk == RiskLevel.high).length;
    final medium = open.where((r) => r.risk == RiskLevel.medium).length;

    b.writeln('RISK SUMMARY');
    b.writeln('───────────────────────────────────────');
    if (critical > 0) b.writeln('⚠ CRITICAL : $critical port(s)');
    if (high > 0) b.writeln('! HIGH     : $high port(s)');
    if (medium > 0) b.writeln('~ MEDIUM   : $medium port(s)');
    b.writeln();

    // Table header
    b.writeln('OPEN PORTS');
    b.writeln('───────────────────────────────────────');
    b.writeln(
        '${'PORT'.padRight(7)} ${'SERVICE'.padRight(16)} ${'MS'.padLeft(5)}  RISK');
    b.writeln('─────────────────────────────────────────');
    for (final r in open..sort((a, b) => a.port.compareTo(b.port))) {
      final riskStr = switch (r.risk) {
        RiskLevel.critical => '⚠ CRITICAL',
        RiskLevel.high => '! HIGH',
        RiskLevel.medium => '~ MEDIUM',
        RiskLevel.low => '. LOW',
        _ => '  -',
      };
      b.writeln(
          '${r.port.toString().padRight(7)} ${r.service.padRight(16)} ${r.responseMs.toString().padLeft(5)}ms $riskStr');
      if (r.riskNote != null) b.writeln('        ↳ ${r.riskNote}');
      if (r.banner != null && r.banner!.isNotEmpty)
        b.writeln('        BANNER: ${r.banner}');
    }

    // Recommendations
    final critPorts = open.where((r) => r.risk == RiskLevel.critical);
    if (critPorts.isNotEmpty) {
      b.writeln('\nCRITICAL RECOMMENDATIONS');
      b.writeln('───────────────────────────────────────');
      for (final r in critPorts) {
        b.writeln(
            '• Port ${r.port} (${r.service}): ${r.riskNote ?? 'Review immediately'}');
      }
    }

    return b.toString();
  }

  String _toText(String host, int total, int ms) {
    final b = StringBuffer();
    b.writeln('PORT SCAN — $host');
    b.writeln('Scanned: $total  |  Open: ${_openResults.length}  |  ${ms}ms\n');
    for (final r in _openResults..sort((a, b) => a.port.compareTo(b.port))) {
      b.writeln('[OPEN] ${r.port}/tcp  ${r.service}  (${r.responseMs}ms)');
      if (r.riskNote != null) b.writeln('       RISK: ${r.riskNote}');
      if (r.banner != null) b.writeln('       BANNER: ${r.banner}');
    }
    return b.toString();
  }

  String _toJson(String host, int total, int ms) {
    final b = StringBuffer();
    b.writeln('{');
    b.writeln('  "host": "$host",');
    b.writeln('  "total_scanned": $total,');
    b.writeln('  "open_count": ${_openResults.length},');
    b.writeln('  "duration_ms": $ms,');
    b.writeln('  "open_ports": [');
    final sorted = _openResults..sort((a, b) => a.port.compareTo(b.port));
    for (int i = 0; i < sorted.length; i++) {
      final r = sorted[i];
      final comma = i < sorted.length - 1 ? ',' : '';
      b.writeln('    {');
      b.writeln('      "port": ${r.port},');
      b.writeln('      "service": "${r.service}",');
      b.writeln('      "response_ms": ${r.responseMs},');
      b.writeln('      "risk": "${r.risk.name}",');
      if (r.riskNote != null) b.writeln('      "risk_note": "${r.riskNote}",');
      if (r.banner != null)
        b.writeln('      "banner": "${r.banner?.replaceAll('"', '\\"')}",');
      b.writeln('      "protocol": "${_portDb[r.port]?['proto'] ?? 'TCP'}"');
      b.writeln('    }$comma');
    }
    b.writeln('  ]');
    b.writeln('}');
    return b.toString();
  }

  // ── Helpers ───────────────────────────────────────────────────
  Color _riskColor(RiskLevel r) => switch (r) {
        RiskLevel.critical => AppColors.danger,
        RiskLevel.high => AppColors.warning,
        RiskLevel.medium => const Color(0xFFFFDD44),
        RiskLevel.low => AppColors.info,
        _ => AppColors.success,
      };

  Widget _chip(String label, bool selected, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentGhost : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: selected ? AppColors.accent : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              letterSpacing: 1,
              color: selected ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      );

  // ── Build ─────────────────────────────────────────────────────
  @override
  void dispose() {
    _hostController.dispose();
    _startPortController.dispose();
    _endPortController.dispose();
    _customPortsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalPorts > 0 ? _scannedPorts / _totalPorts : 0.0;

    return AppScaffold(
      title: 'PORT SCANNER',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Target ──────────────────────────────────────────
            const SectionHeader(title: 'TARGET'),
            const SizedBox(height: 8),
            AppInput(
              controller: _hostController,
              hintText: '192.168.1.1  or  example.com',
              onChanged: (_) {
                if (!_isScanning) setState(() => _result = '');
              },
            ),

            // ── Scan Mode ────────────────────────────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'SCAN MODE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['RANGE', 'PRESET', 'CUSTOM']
                  .map(
                    (m) => _chip(
                        m, _scanMode == m, () => setState(() => _scanMode = m)),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),

            // RANGE
            if (_scanMode == 'RANGE')
              Row(children: [
                Expanded(
                    child: AppInput(
                  controller: _startPortController,
                  labelText: 'Start',
                  hintText: '1',
                  keyboardType: TextInputType.number,
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('—',
                      style: TextStyle(
                          fontSize: 20, color: AppColors.textSecondary)),
                ),
                Expanded(
                    child: AppInput(
                  controller: _endPortController,
                  labelText: 'End',
                  hintText: '65535',
                  keyboardType: TextInputType.number,
                )),
              ]),

            // PRESET
            if (_scanMode == 'PRESET')
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presets.keys
                    .map(
                      (p) => _chip(p, _selectedPreset == p,
                          () => setState(() => _selectedPreset = p)),
                    )
                    .toList(),
              ),

            // CUSTOM
            if (_scanMode == 'CUSTOM')
              AppInput(
                controller: _customPortsController,
                hintText: 'e.g. 22, 80, 443, 3000-3010, 8080',
                labelText: 'Ports (comma-separated, ranges with -)',
              ),

            // ── Options ──────────────────────────────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'OPTIONS'),
            const SizedBox(height: 12),

            // Timeout
            Row(children: [
              const Text('Timeout (ms)',
                  style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      letterSpacing: 1)),
              const SizedBox(width: 12),
              Expanded(
                  child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.accent,
                  thumbColor: AppColors.accent,
                  inactiveTrackColor: AppColors.border,
                  overlayColor: AppColors.accentGhost,
                  valueIndicatorColor: AppColors.bgElevated,
                  valueIndicatorTextStyle: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.accent),
                ),
                child: Slider(
                  value: _timeout.toDouble(),
                  min: 100,
                  max: 3000,
                  divisions: 29,
                  label: '${_timeout}ms',
                  onChanged: (v) => setState(() => _timeout = v.round()),
                ),
              )),
              SizedBox(
                width: 56,
                child: Text(
                  '${_timeout}ms',
                  style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.accent),
                  textAlign: TextAlign.right,
                ),
              ),
            ]),

            // Concurrency
            Row(children: [
              const Text('Threads   ',
                  style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      letterSpacing: 1)),
              const SizedBox(width: 12),
              Expanded(
                  child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.accent,
                  thumbColor: AppColors.accent,
                  inactiveTrackColor: AppColors.border,
                  overlayColor: AppColors.accentGhost,
                  valueIndicatorColor: AppColors.bgElevated,
                  valueIndicatorTextStyle: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.accent),
                ),
                child: Slider(
                  value: _concurrency.toDouble(),
                  min: 1,
                  max: 200,
                  divisions: 40,
                  label: '$_concurrency',
                  onChanged: (v) => setState(() => _concurrency = v.round()),
                ),
              )),
              SizedBox(
                width: 56,
                child: Text(
                  '$_concurrency',
                  style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.accent),
                  textAlign: TextAlign.right,
                ),
              ),
            ]),

            // Toggles
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip('BANNER GRAB', _grabBanners,
                    () => setState(() => _grabBanners = !_grabBanners)),
                _chip('SHOW CLOSED', _showClosed,
                    () => setState(() => _showClosed = !_showClosed)),
              ],
            ),

            // Output format
            const SizedBox(height: 12),
            Row(children: [
              const Text('OUTPUT  ',
                  style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      letterSpacing: 2)),
              const SizedBox(width: 8),
              Wrap(
                spacing: 6,
                children: ['TABLE', 'TEXT', 'JSON']
                    .map(
                      (f) => _chip(f, _outputFormat == f,
                          () => setState(() => _outputFormat = f)),
                    )
                    .toList(),
              ),
            ]),

            // ── Buttons ──────────────────────────────────────────
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isScanning ? null : _scanPorts,
                  icon: _isScanning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.black))
                      : const Icon(Icons.radar, size: 18),
                  label: Text(_isScanning ? 'SCANNING…' : 'START SCAN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        fontSize: 13),
                  ),
                ),
              ),
              if (_isScanning) ...[
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _cancelled = true),
                  icon: const Icon(Icons.stop, size: 18),
                  label: const Text('STOP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    textStyle: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2),
                  ),
                ),
              ],
            ]),

            // ── Progress ─────────────────────────────────────────
            if (_isScanning) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  color: AppColors.accent,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Text(
                  'Port $_currentPort  •  $_scannedPorts / $_totalPorts',
                  style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textSecondary),
                ),
                const Spacer(),
                Text(
                  '${_openResults.length} open',
                  style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.accent),
                ),
              ]),
              const SizedBox(height: 8),
              // Live open ports
              if (_openResults.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _openResults
                      .map((r) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _riskColor(r.risk).withOpacity(0.15),
                              border: Border.all(
                                  color: _riskColor(r.risk).withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${r.port}/${r.service}',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  color: _riskColor(r.risk)),
                            ),
                          ))
                      .toList(),
                ),
            ],

            // ── Result ───────────────────────────────────────────
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 20),
              ResultBox(
                content: _result,
                label: 'RESULTS [$_outputFormat]',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
