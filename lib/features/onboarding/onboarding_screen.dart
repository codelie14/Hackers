import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/button_animations.dart';

// ═══════════════════════════════════════════════════════════════
// DATA MODEL
// ═══════════════════════════════════════════════════════════════

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final List<String> bullets;
  final String? statLabel;
  final String? statValue;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    this.bullets = const [],
    this.statLabel,
    this.statValue,
  });
}

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  late final PageController _pageController;
  late final AnimationController _bgController;
  late final AnimationController _contentController;
  late final AnimationController _particleController;
  late final AnimationController _logoController;
  late final AnimationController _pulseController;

  // ── Animations ───────────────────────────────────────────────
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _pulseAnim;

  int _currentPage = 0;
  bool _isTransitioning = false;

  // ── Particles ─────────────────────────────────────────────────
  final List<_Particle> _particles = [];
  final Random _random = Random();

  // ── Pages ─────────────────────────────────────────────────────
  static const List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.terminal,
      title: 'HACKERS',
      subtitle: 'Offline Security Toolkit',
      description:
          'The ultimate privacy-focused toolkit for security professionals, '
          'developers, and enthusiasts. Everything offline. Everything local.',
      color: AppColors.accent,
      statLabel: 'TOOLS',
      statValue: '350+',
      bullets: [],
    ),
    OnboardingPage(
      icon: Icons.wifi_off,
      title: '100% OFFLINE',
      subtitle: 'Air-gapped. Zero network. Full power.',
      description: 'Every single tool runs entirely on your device. '
          'No API calls, no telemetry, no cloud dependencies.',
      color: AppColors.catPassword,
      bullets: [
        'Works on air-gapped systems',
        'No data ever leaves your device',
        'No account required — ever',
        'Perfect for secure environments',
      ],
    ),
    OnboardingPage(
      icon: Icons.grid_view_rounded,
      title: '15 CATEGORIES',
      subtitle: 'From crypto to forensics',
      description:
          'A complete professional arsenal, organized and always ready.',
      color: AppColors.catNetwork,
      statLabel: 'CATEGORIES',
      statValue: '15',
      bullets: [
        'Cryptography & Hashing',
        'Network & Port Scanner',
        'Password Toolkit',
        'Forensics & Steganography',
        'Developer Tools & JWT',
        'OSINT & Code Analysis',
      ],
    ),
    OnboardingPage(
      icon: Icons.lock_outline,
      title: 'PRIVACY FIRST',
      subtitle: 'Built with zero trust.',
      description: 'No analytics, no tracking, no data collection. '
          'Open source, auditable, and built for people who know what that means.',
      color: AppColors.catPrivacy,
      bullets: [
        'Zero analytics or telemetry',
        'AES-256 encrypted local storage',
        'No account, no email, no cloud',
        'Open source — verify it yourself',
      ],
    ),
    OnboardingPage(
      icon: Icons.rocket_launch_outlined,
      title: 'READY?',
      subtitle: 'Your toolkit awaits.',
      description:
          'Join security professionals who trust Hackers for their daily ops. '
          'No setup. No fluff. Just tools.',
      color: AppColors.success,
      statLabel: 'BUILD',
      statValue: 'v2.0',
      bullets: [],
    ),
  ];

  // ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeOut));

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0, 0.4, curve: Curves.easeOut)),
    );
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _generateParticles();
    _logoController.forward();
    _contentController.forward();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 35; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.5 + 0.5,
        speed: _random.nextDouble() * 0.012 + 0.003,
        opacity: _random.nextDouble() * 0.5 + 0.1,
        drift: (_random.nextDouble() - 0.5) * 0.006,
      ));
    }
  }

  void _onPageChanged(int index) {
    if (_isTransitioning) return;
    _isTransitioning = true;

    _contentController.reset();

    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      setState(() => _currentPage = index);
      _contentController.forward().then((_) => _isTransitioning = false);
    });
  }

  Future<void> _nextPage() async {
    if (_currentPage == _pages.length - 1) {
      await _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    context.go('/');
  }

  Color get _currentColor => _pages[_currentPage].color;

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // ── Animated radial background ───────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  _currentColor.withOpacity(0.08),
                  AppColors.bgBase,
                ],
                center: const Alignment(0, -0.3),
                radius: 1.2,
              ),
            ),
          ),

          // ── Grid ─────────────────────────────────────────────
          CustomPaint(
            size: size,
            painter: _GridPainter(accentColor: _currentColor),
          ),

          // ── Particles ────────────────────────────────────────
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _ParticlePainter(
                particles: _particles,
                progress: _particleController.value,
                color: _currentColor,
              ),
            ),
          ),

          // ── Corner decorations ───────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            child: _CornerBracket(color: _currentColor, flip: false),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _CornerBracket(color: _currentColor, flip: true),
          ),

          // ── Main content ─────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Skip
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      // Step counter
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: _currentColor.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${_currentPage + 1} / ${_pages.length}',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            color: _currentColor,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Skip
                      if (_currentPage < _pages.length - 1)
                        PressScaleAnimation(
                          onTap: _completeOnboarding,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'SKIP →',
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) => _buildPage(index),
                  ),
                ),

                // Indicators + button
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Page builder ─────────────────────────────────────────────
  Widget _buildPage(int index) {
    final page = _pages[index];
    final isFirst = index == 0;
    final isLast = index == _pages.length - 1;

    return FadeTransition(
      opacity: index == _currentPage
          ? _contentFade
          : const AlwaysStoppedAnimation(1),
      child: SlideTransition(
        position: index == _currentPage
            ? _contentSlide
            : const AlwaysStoppedAnimation(Offset.zero),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo on first page, icon on others ───────────
              if (isFirst)
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child:
                        _LogoWidget(pulseAnim: _pulseAnim, color: page.color),
                  ),
                )
              else
                _IconWidget(icon: page.icon, color: page.color),

              const SizedBox(height: 32),

              // ── Title ─────────────────────────────────────────
              if (isFirst)
                Column(children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                      letterSpacing: 6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '[ IndraLabs ]',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textMuted,
                      letterSpacing: 3,
                    ),
                  ),
                ])
              else
                Text(
                  page.title,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 8),

              // ── Subtitle ──────────────────────────────────────
              Text(
                page.subtitle,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: page.color,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // ── Description ───────────────────────────────────
              Text(
                page.description,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),

              // ── Stat badge ────────────────────────────────────
              if (page.statLabel != null) ...[
                const SizedBox(height: 24),
                _StatBadge(
                  label: page.statLabel!,
                  value: page.statValue!,
                  color: page.color,
                ),
              ],

              // ── Bullets ───────────────────────────────────────
              if (page.bullets.isNotEmpty) ...[
                const SizedBox(height: 24),
                ...page.bullets.asMap().entries.map(
                      (e) => _BulletItem(
                        text: e.value,
                        color: page.color,
                        delay: Duration(milliseconds: 100 + e.key * 80),
                        parentController: _contentController,
                      ),
                    ),
              ],

              // ── Last page terminal block ───────────────────────
              if (isLast) ...[
                const SizedBox(height: 24),
                _TerminalBlock(color: page.color),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom bar ───────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (i) => GestureDetector(
                onTap: () => _pageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? _currentColor : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: _currentPage == i
                        ? [
                            BoxShadow(
                              color: _currentColor.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Next / Get Started button
          PressScaleAnimation(
            onTap: _nextPage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _currentColor.withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _pages.length - 1
                        ? 'LAUNCH HACKERS'
                        : 'NEXT',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    _currentPage == _pages.length - 1
                        ? Icons.terminal
                        : Icons.arrow_forward_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    _contentController.dispose();
    _particleController.dispose();
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════
// SUB-WIDGETS
// ═══════════════════════════════════════════════════════════════

class _LogoWidget extends StatelessWidget {
  final Animation<double> pulseAnim;
  final Color color;

  const _LogoWidget({required this.pulseAnim, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (_, __) => Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: color.withOpacity(0.2 * pulseAnim.value + 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15 * pulseAnim.value),
              blurRadius: 40 * pulseAnim.value,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SvgPicture.asset(
            'assets/logo/hackers_logo.svg',
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconWidget({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Icon(icon, size: 56, color: color),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 2,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: color.withOpacity(0.7),
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;
  final Duration delay;
  final AnimationController parentController;

  const _BulletItem({
    required this.text,
    required this.color,
    required this.delay,
    required this.parentController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.6), blurRadius: 6),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalBlock extends StatefulWidget {
  final Color color;
  const _TerminalBlock({required this.color});

  @override
  State<_TerminalBlock> createState() => _TerminalBlockState();
}

class _TerminalBlockState extends State<_TerminalBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _blink;

  static const List<String> _lines = [
    '> initializing toolkit...',
    '> loading 350+ tools... [OK]',
    '> checking encryption... [OK]',
    '> no network requests... [OK]',
    '> privacy mode........... [ON]',
    '> ready.',
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _blink = Tween<double>(begin: 0, end: 1).animate(_blinkController);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal title bar
          Row(children: [
            Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(5))),
            const SizedBox(width: 6),
            Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(5))),
            const SizedBox(width: 6),
            Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(5))),
            const SizedBox(width: 12),
            Text('hackers@indralabs:~',
                style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textMuted,
                    letterSpacing: 1)),
          ]),
          const SizedBox(height: 12),
          // Lines
          ..._lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: line.contains('[OK]')
                        ? AppColors.success
                        : line.contains('[ON]')
                            ? widget.color
                            : line == '> ready.'
                                ? widget.color
                                : AppColors.textSecondary,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
                ),
              )),
          // Blinking cursor
          AnimatedBuilder(
            animation: _blink,
            builder: (_, __) => Text(
              '█',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: widget.color.withOpacity(_blink.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Color color;
  final bool flip;
  const _CornerBracket({required this.color, required this.flip});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: flip,
      child: CustomPaint(
        size: const Size(40, 40),
        painter: _BracketPainter(color: color),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAINTERS
// ═══════════════════════════════════════════════════════════════

class _GridPainter extends CustomPainter {
  final Color accentColor;
  const _GridPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    const gridSize = 48.0;

    // Background grid
    final bgPaint = Paint()
      ..color = AppColors.border.withOpacity(0.04)
      ..strokeWidth = 0.5;

    for (var x = 0.0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), bgPaint);
    }
    for (var y = 0.0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), bgPaint);
    }

    // Accent cross-hairs at intersections (sparse)
    final dotPaint = Paint()
      ..color = accentColor.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    for (var x = gridSize; x < size.width; x += gridSize * 3) {
      for (var y = gridSize; y < size.height; y += gridSize * 3) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.accentColor != accentColor;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  const _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y - p.speed * progress) % 1.0;
      final x = (p.x + p.drift * progress) % 1.0;
      final paint = Paint()
        ..color = color.withOpacity(
            p.opacity * (0.5 + 0.5 * sin(progress * pi * 2 + p.x * 10)))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.progress != progress || old.color != color;
}

class _BracketPainter extends CustomPainter {
  final Color color;
  const _BracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.25)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final path = Path()
      ..moveTo(size.width * 0.7, 4)
      ..lineTo(4, 4)
      ..lineTo(4, size.height * 0.7);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => old.color != color;
}

// ═══════════════════════════════════════════════════════════════
// PARTICLE MODEL
// ═══════════════════════════════════════════════════════════════

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double drift;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
  });
}
