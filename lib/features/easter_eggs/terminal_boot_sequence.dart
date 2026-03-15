import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

/// Konami code easter egg - Terminal boot sequence
class TerminalBootOverlay extends StatefulWidget {
  final Widget child;

  const TerminalBootOverlay({
    super.key,
    required this.child,
  });

  @override
  State<TerminalBootOverlay> createState() => _TerminalBootOverlayState();
}

class _TerminalBootOverlayState extends State<TerminalBootOverlay> {
  bool _showTerminal = false;
  final List<String> _bootMessages = [];
  Timer? _typingTimer;

  final List<String> _messages = [
    'HACKERS v1.0.0',
    'Initializing offline security toolkit...',
    '',
    '[OK] Loading cryptographic modules',
    '[OK] Initializing password generators',
    '[OK] Preparing encoding/decoding tools',
    '[OK] Setting up network utilities',
    '[OK] Loading developer tools',
    '',
    'SYSTEM READY',
    '',
    'Welcome to HACKERS',
    'Offline Security Toolkit',
    '',
    'Type "help" for available commands...',
  ];

  void _startBootSequence() {
    setState(() => _showTerminal = true);
    _typeMessage(0);
  }

  void _typeMessage(int index) {
    if (index >= _messages.length) {
      Timer(const Duration(seconds: 2), () {
        setState(() => _showTerminal = false);
      });
      return;
    }

    setState(() {
      _bootMessages.add(_messages[index]);
    });

    _typingTimer = Timer(const Duration(milliseconds: 300), () {
      _typeMessage(index + 1);
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  // Call this method to trigger the easter egg
  void triggerEasterEgg() {
    _startBootSequence();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showTerminal) ...[
          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ..._bootMessages.map((msg) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          msg,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                            color: AppColors.accent,
                          ),
                        ),
                      )),
                  const Spacer(),
                  const Text(
                    '_',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Secret trigger button (can be placed anywhere in the app)
class EasterEggTrigger extends StatelessWidget {
  final VoidCallback onTrigger;

  const EasterEggTrigger({
    super.key,
    required this.onTrigger,
  });

  @override
  Widget build(BuildContext context) {
    // Invisible button in corner for testing
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTrigger,
        child: Container(
          width: 50,
          height: 50,
          color: Colors.transparent,
        ),
      ),
    );
  }
}
