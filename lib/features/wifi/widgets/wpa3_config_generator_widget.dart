import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class WPA3ConfigGeneratorWidget extends ConsumerStatefulWidget {
  const WPA3ConfigGeneratorWidget({super.key});

  @override
  ConsumerState<WPA3ConfigGeneratorWidget> createState() =>
      _WPA3ConfigGeneratorWidgetState();
}

class _WPA3ConfigGeneratorWidgetState
    extends ConsumerState<WPA3ConfigGeneratorWidget> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  String _encryptionType = 'WPA3-Personal';
  bool _generateConfig = false;

  String get _configTemplate {
    final ssid = _ssidController.text.trim().isEmpty
        ? 'YourNetworkName'
        : _ssidController.text.trim();
    final password = _passwordController.text.trim().isEmpty
        ? 'YourStrongPassword'
        : _passwordController.text.trim();

    if (_encryptionType == 'WPA3-Personal') {
      return '''# WPA3-Personal Configuration
# For modern routers supporting WPA3

interface=wlan0
driver=nl80211
ssid=$ssid
hw_mode=g
channel=6
wmm_enabled=1
ieee80211n=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]

# WPA3 Configuration
wpa=3
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP
wpa_psk=${_generatePSK(ssid, password)}

# WPA3 Transition Mode (for backward compatibility)
transition_disable=0

# Management Frame Protection
ieee80211w=2

# Beacon interval and DTIM period
beacon_int=100
dtim_period=2

# Maximum number of stations
max_num_sta=255

# Disassociation timeout
disassoc_low_ack=1
''';
    } else if (_encryptionType == 'WPA3-Enterprise') {
      return '''# WPA3-Enterprise Configuration
# For enterprise deployments with RADIUS server

interface=wlan0
driver=nl80211
ssid=$ssid
hw_mode=a
channel=36
ieee80211ac=1
wmm_enabled=1

# WPA3-Enterprise
wpa=3
key_mgmt=WPA-EAP-SHA256
pairwise=GCMP-256
group=GCMP-256

# RADIUS Server Configuration
auth_server_addr=192.168.1.100
auth_server_port=1812
auth_server_shared_secret=your_radius_secret

# EAP Configuration
eap_server=1
eap_user_file=/etc/hostapd/eap_user
ca_cert=/etc/hostapd/ca.pem
server_cert=/etc/hostapd/server.pem
private_key=/etc/hostapd/server.prv

# PMKID caching
okc=1
pmk_cache_lifetime=86400
''';
    }
    return '';
  }

  String _generatePSK(String ssid, String password) {
    // Simplified PSK generation (in production, use proper PBKDF2)
    final combined = '$ssid$password';
    return combined.codeUnits
        .fold<String>(
          '',
          (prev, curr) => prev + curr.toRadixString(16).padLeft(2, '0'),
        )
        .substring(0, 64);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _configTemplate));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuration copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'WPA3 Config Generator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'WPA3 Configuration Generator',
              subtitle: 'Generate hostapd configuration for WPA3',
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: _ssidController,
              labelText: 'Network Name (SSID)',
              hintText: 'Enter your network name',
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter WPA3 passphrase (min 8 chars)',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _encryptionType,
              decoration: InputDecoration(
                labelText: 'Encryption Type',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.bgSurface,
              ),
              items: [
                'WPA3-Personal',
                'WPA3-Enterprise',
              ]
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _encryptionType = value!),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Generate Configuration',
              onPressed: () => setState(() => _generateConfig = true),
            ),
            if (_generateConfig) ...[
              const SizedBox(height: 24),
              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'hostapd.conf',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: _copyToClipboard,
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      SelectableText(
                        _configTemplate,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Copy Configuration',
                onPressed: _copyToClipboard,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
