import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import 'brand_setup_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({
    super.key,
    required this.controller,
    required this.appBuilder,
  });

  static const setupCompletePreferenceKey = 'vibr.brand_setup_complete';
  static const signedInPreferenceKey = 'vibr.signed_in';
  static const onboardingCompletePreferenceKey = 'vibr.onboarding_complete';
  static const brandNamePreferenceKey = 'vibr.brand_name';
  static const brandIndustryPreferenceKey = 'vibr.brand_industry';

  final AppController controller;
  final Widget Function(Future<void> Function() onSignOut) appBuilder;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  late Future<void> _loadPreferences;
  bool _isReady = false;
  bool _showOnboarding = false;
  bool _showRegister = false;
  bool _showBrandSetup = false;
  bool _showApp = false;
  String? _storageError;

  @override
  void initState() {
    super.initState();
    _loadPreferences = _initialize();
  }

  Future<void> _initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final setupComplete =
        preferences.getBool(AuthFlow.setupCompletePreferenceKey) ?? false;
    final signedIn =
        preferences.getBool(AuthFlow.signedInPreferenceKey) ?? setupComplete;
    final onboardingComplete =
        preferences.getBool(AuthFlow.onboardingCompletePreferenceKey) ?? false;
    final brandName = preferences.getString(AuthFlow.brandNamePreferenceKey);
    final brandIndustry = preferences.getString(
      AuthFlow.brandIndustryPreferenceKey,
    );

    if (brandName != null && brandIndustry != null) {
      widget.controller.updateBrandProfile(
        name: brandName,
        industry: brandIndustry,
      );
    }

    if (!mounted) return;
    setState(() {
      _isReady = true;
      _showApp = setupComplete && signedIn;
      _showOnboarding = !setupComplete && !onboardingComplete;
    });
  }

  Future<void> _completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setBool(
      AuthFlow.onboardingCompletePreferenceKey,
      true,
    );
    if (!saved) {
      if (!mounted) return;
      setState(
        () => _storageError = 'Pengenalan aplikasi tidak dapat disimpan.',
      );
      return;
    }
    if (!mounted) return;
    setState(() {
      _showOnboarding = false;
      _storageError = null;
    });
  }

  Future<void> _signIn(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    final setupComplete =
        preferences.getBool(AuthFlow.setupCompletePreferenceKey) ?? false;
    final saved = await preferences.setBool(
      AuthFlow.signedInPreferenceKey,
      true,
    );
    if (!saved) {
      if (!mounted) return;
      setState(() => _storageError = 'Sesi masuk tidak dapat disimpan.');
      return;
    }
    if (!mounted) return;
    setState(() {
      _showApp = setupComplete;
      _showBrandSetup = !setupComplete;
      _showRegister = false;
      _storageError = null;
    });
  }

  Future<void> _signOut() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setBool(
      AuthFlow.signedInPreferenceKey,
      false,
    );
    if (!saved) {
      if (!mounted) return;
      setState(() => _storageError = 'Anda belum keluar. Silakan coba lagi.');
      return;
    }
    if (!mounted) return;
    setState(() {
      _showApp = false;
      _showBrandSetup = false;
      _showRegister = false;
      _storageError = null;
    });
  }

  Future<void> _register(String name, String email, String password) async {
    if (!mounted) return;
    setState(() {
      _showRegister = false;
      _showBrandSetup = false;
      _storageError = null;
    });
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('account-created-dialog'),
        backgroundColor: AppColors.surface,
        icon: const Icon(Icons.check_circle_outline, color: AppColors.accent),
        title: const Text(
          'Akun berhasil dibuat',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Silakan masuk dengan akun barumu untuk melanjutkan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            key: const ValueKey('account-created-confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Ke halaman Masuk'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBrandSetup({
    String? name,
    String? industry,
    Uint8List? imageBytes,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    if (name != null && industry != null) {
      final savedName = await preferences.setString(
        AuthFlow.brandNamePreferenceKey,
        name,
      );
      final savedIndustry = await preferences.setString(
        AuthFlow.brandIndustryPreferenceKey,
        industry,
      );
      if (!savedName || !savedIndustry) {
        if (!mounted) return;
        setState(() => _storageError = 'Profil merek tidak dapat disimpan.');
        return;
      }
    }

    final saved = await preferences.setBool(
      AuthFlow.setupCompletePreferenceKey,
      true,
    );
    if (!saved) {
      if (!mounted) return;
      setState(() => _storageError = 'Pengaturan awal tidak dapat disimpan.');
      return;
    }
    final savedSession = await preferences.setBool(
      AuthFlow.signedInPreferenceKey,
      true,
    );
    if (!savedSession) {
      if (!mounted) return;
      setState(() => _storageError = 'Sesi masuk tidak dapat disimpan.');
      return;
    }
    if (!mounted) return;
    if (name != null && industry != null) {
      widget.controller.updateBrandProfile(
        name: name,
        industry: industry,
        imageBytes: imageBytes,
      );
    }
    setState(() {
      _showBrandSetup = false;
      _showApp = true;
      _storageError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadPreferences,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _AuthLoadingError(
            message: 'Data aplikasi tidak dapat dibaca: ${snapshot.error}',
            onRetry: () {
              setState(() {
                _isReady = false;
                _loadPreferences = _initialize();
              });
            },
          );
        }
        if (!_isReady) {
          return const _AuthLoadingScreen();
        }
        if (_showApp) return widget.appBuilder(_signOut);

        final Widget screen;
        if (_showOnboarding) {
          screen = OnboardingScreen(
            key: const ValueKey('onboarding-screen'),
            onComplete: _completeOnboarding,
          );
        } else if (_showBrandSetup) {
          screen = BrandSetupScreen(
            key: const ValueKey('brand-setup-screen'),
            onSkip: () => _saveBrandSetup(),
            onContinue: (brandName, industry, imageBytes) async {
              await _saveBrandSetup(
                name: brandName,
                industry: industry,
                imageBytes: imageBytes,
              );
            },
          );
        } else if (_showRegister) {
          screen = RegisterScreen(
            key: const ValueKey('register-screen'),
            onRegister: _register,
            onSignIn: () => setState(() => _showRegister = false),
          );
        } else {
          screen = LoginScreen(
            key: const ValueKey('login-screen'),
            onSignIn: _signIn,
            onRegister: () => setState(() => _showRegister = true),
          );
        }

        return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: screen,
            ),
            if (_storageError != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: SafeArea(
                  child: Material(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _storageError!,
                        style: const TextStyle(
                          color: AppColors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}

class _AuthLoadingError extends StatelessWidget {
  const _AuthLoadingError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
            ],
          ),
        ),
      ),
    );
  }
}
