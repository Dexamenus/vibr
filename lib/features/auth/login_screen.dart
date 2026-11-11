import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onSignIn,
    required this.onRegister,
  });

  final Future<void> Function(String email, String password) onSignIn;
  final VoidCallback onRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await widget.onSignIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Masukkan alamat email yang valid.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selamat datang kembali',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontSize: 23, letterSpacing: -0.4),
            ),
            const SizedBox(height: 7),
            const Text(
              'Ide hebat berikutnya sedang menantimu.',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 28),
            AuthField(
              key: const ValueKey('login-email-field'),
              label: 'Email',
              hint: 'nama@contoh.com',
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            AuthField(
              key: const ValueKey('login-password-field'),
              label: 'Kata sandi',
              hint: 'Masukkan kata sandi',
              controller: _passwordController,
              validator: (value) =>
                  (value ?? '').isEmpty ? 'Kata sandi wajib diisi.' : null,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              suffix: IconButton(
                tooltip: _obscurePassword
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const ValueKey('forgot-password'),
                onPressed: () => showAuthDemoMessage(
                  context,
                  'Fitur reset kata sandi belum tersedia.',
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Lupa kata sandi?'),
              ),
            ),
            const SizedBox(height: 8),
            AuthPrimaryButton(
              key: const ValueKey('login-submit'),
              label: 'Masuk',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 22),
            const AuthDivider(),
            const SizedBox(height: 14),
            AuthGoogleButton(
              onPressed: () => showAuthDemoMessage(
                context,
                'Masuk dengan Google belum tersedia.',
              ),
            ),
            const SizedBox(height: 14),
            const AuthDemoNotice(),
          ],
        ),
      ),
      footer: AuthFooterLink(
        description: 'Belum punya akun?',
        label: 'Daftar',
        onPressed: widget.onRegister,
      ),
    );
  }
}
