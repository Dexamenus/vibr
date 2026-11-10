import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'auth_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _slides = [
    _OnboardingSlide(
      image: 'assets/img/Product illustration.png',
      title: 'Buat konten menarik dengan AI',
      description: 'Buat gambar dan caption untuk Instagram dan Facebook dalam hitungan detik.',
    ),
    _OnboardingSlide(
      image: 'assets/img/Product illustration (1).png',
      title: 'Jadwalkan dan otomatisasi postingan',
      description: 'Rencanakan postingan Instagram dan Facebook. Terbitkan di waktu yang tepat.',
    ),
    _OnboardingSlide(
      image: 'assets/img/Brand identity.png',
      title: 'Pahami audiensmu',
      description: 'Lihat yang disukai audiens. Gunakan wawasan langsung untuk ide berikutnya.',
    ),
  ];

  late final PageController _pageController;
  Timer? _splashTimer;
  int _currentPage = 0;
  bool _showSplash = true;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _splashTimer = Timer(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _advance() async {
    if (_isCompleting) return;
    if (_currentPage < _slides.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
      return;
    }
    await _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isCompleting = true);
    try {
      await widget.onComplete();
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const _BrandSplashScreen();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 14, 0),
                  child: Row(
                    children: [
                      const Expanded(child: AuthBrand()),
                      TextButton(
                        key: const ValueKey('onboarding-skip'),
                        onPressed: _isCompleting ? null : _finishOnboarding,
                        child: const Text('Lewati'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(22, 8, 22, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.asset(
                                slide.image,
                                key: ValueKey('onboarding-image-$index'),
                                fit: BoxFit.contain,
                                semanticLabel: slide.title,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              slide.title,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontSize: 22,
                                    height: 1.2,
                                    letterSpacing: -0.3,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              slide.description,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var index = 0; index < _slides.length; index++)
                            AnimatedContainer(
                              key: ValueKey('onboarding-dot-$index'),
                              duration: const Duration(milliseconds: 180),
                              width: index == _currentPage ? 7 : 5,
                              height: index == _currentPage ? 7 : 5,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: index == _currentPage
                                    ? AppColors.accent
                                    : AppColors.border,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AuthPrimaryButton(
                        key: const ValueKey('onboarding-next'),
                        label: _currentPage == _slides.length - 1
                            ? 'Mulai'
                            : 'Lanjut',
                        isLoading: _isCompleting,
                        onPressed: _advance,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandSplashScreen extends StatelessWidget {
  const _BrandSplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logofull.png',
                width: 178,
                height: 210,
                fit: BoxFit.contain,
                semanticLabel: 'Vibr, Intelligent by design',
              ),
              const SizedBox(height: 88),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SplashDot(delay: 0),
                  SizedBox(width: 6),
                  _SplashDot(delay: 150),
                  SizedBox(width: 6),
                  _SplashDot(delay: 300),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashDot extends StatelessWidget {
  const _SplashDot({required this.delay});

  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('splash-dot-$delay'),
      tween: Tween(begin: 0.3, end: 1),
      duration: Duration(milliseconds: 550 + delay),
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
        ),
        child: SizedBox.square(dimension: 4),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
