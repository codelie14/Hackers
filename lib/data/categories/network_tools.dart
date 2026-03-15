import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// NETWORK TOOLS
/// Network Analysis, Scanning & Diagnostics
/// ────────────────────────────────────────────────────────────

class NetworkTools {
  NetworkTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'ping_tool',
      name: 'Ping',
      description:
          'Send ICMP echo requests to test host reachability and measure latency.',
      category: ToolCategory.network,
      icon: Icons.wifi_tethering,
      tags: ['ping', 'icmp', 'latency', 'network'],
      isAvailable: true,
      routePath: '/network/ping',
      requiresNetwork: true,
    ),
    ToolModel(
      id: 'dns_lookup',
      name: 'DNS Lookup',
      description: 'Query DNS records: A, AAAA, MX, TXT, CNAME, NS, SOA, CAA.',
      category: ToolCategory.network,
      icon: Icons.dns_outlined,
      tags: ['dns', 'lookup', 'a', 'mx', 'txt'],
      isAvailable: true,
      routePath: '/network/dns',
      requiresNetwork: true,
    ),
    ToolModel(
      id: 'cidr_calculator',
      name: 'CIDR Calculator',
      description:
          'Calculate network address, broadcast, host range, and subnets from CIDR notation.',
      category: ToolCategory.network,
      icon: Icons.calculate,
      tags: ['cidr', 'subnet', 'network', 'ip'],
      isAvailable: true,
      routePath: '/network/cidr',
    ),
    ToolModel(
      id: 'port_scanner',
      name: 'Port Scanner',
      description: 'Scan common or custom port ranges on a target host.',
      category: ToolCategory.network,
      icon: Icons.radar,
      tags: ['port', 'scan', 'nmap', 'network'],
      isAvailable: false,
      requiresNetwork: true,
    ),
    ToolModel(
      id: 'ip_converter',
      name: 'IP Address Converter',
      description:
          'Convert IPv4 addresses between decimal, hex, octal, binary, and IPv6.',
      category: ToolCategory.network,
      icon: Icons.swap_horiz,
      tags: ['ip', 'ipv4', 'ipv6', 'convert', 'hex'],
      isAvailable: true,
      routePath: '/network/ip-converter',
    ),
    ToolModel(
      id: 'firewall_rules',
      name: 'Firewall Rule Generator',
      description:
          'Generate iptables, nftables, UFW, and Windows Firewall rules.',
      category: ToolCategory.network,
      icon: Icons.security,
      tags: ['firewall', 'iptables', 'ufw', 'rules'],
      isAvailable: true,
      routePath: '/network/firewall',
    ),
    ToolModel(
      id: 'http_headers',
      name: 'HTTP Headers Analyzer',
      description:
          'Analyze and score HTTP security headers (CSP, HSTS, X-Frame-Options).',
      category: ToolCategory.network,
      icon: Icons.http,
      tags: ['http', 'headers', 'security', 'csp', 'hsts'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'ssl_analyzer',
      name: 'SSL/TLS Analyzer',
      description:
          'Analyze SSL/TLS certificates, cipher suites, and protocol support.',
      category: ToolCategory.network,
      icon: Icons.https_outlined,
      tags: ['ssl', 'tls', 'certificate', 'cipher'],
      isAvailable: false,
      requiresNetwork: true,
    ),
    ToolModel(
      id: 'wake_on_lan',
      name: 'Wake-on-LAN',
      description: 'Send Wake-on-LAN magic packets to wake network devices.',
      category: ToolCategory.network,
      icon: Icons.power_settings_new,
      tags: ['wol', 'wake', 'magic-packet', 'lan'],
      isAvailable: true,
      routePath: '/network/wake-on-lan',
    ),
    ToolModel(
      id: 'reverse_dns',
      name: 'Reverse DNS Lookup',
      description: 'Look up PTR records to resolve IP addresses to hostnames.',
      category: ToolCategory.network,
      icon: Icons.find_replace,
      tags: ['rdns', 'ptr', 'reverse', 'dns'],
      isAvailable: false,
      requiresNetwork: true,
    ),
    ToolModel(
      id: 'traceroute',
      name: 'Traceroute',
      description:
          'Trace the network path to a destination host with hop analysis.',
      category: ToolCategory.network,
      icon: Icons.route,
      tags: ['traceroute', 'hop', 'network', 'trace'],
      isAvailable: false,
      requiresNetwork: true,
    ),
  ];
}
