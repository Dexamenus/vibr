import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onSignIn,
  });

  final Future<void> Function(String name, String email, String password)
  onRegister;
  final VoidCallback onSignIn;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!_agreedToTerms) {
      setState(
        () => _termsError = 'Setujui Syarat & Privasi untuk melanjutkan.',
      );
    }
    if (!isValid || !_agreedToTerms) return;

    setState(() => _isLoading = true);
    try {
      await widget.onRegister(
        _nameController.text.trim(),
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
              'Buat akunmu',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontSize: 23, letterSpacing: -0.4),
            ),
            const SizedBox(height: 7),
            const Text(
              'Sedikit kecerdasan untuk setiap postingan.',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            AuthField(
              label: 'Nama',
              hint: 'Nama lengkapmu',
              controller: _nameController,
              validator: (value) => (value?.trim().isNotEmpty ?? false)
                  ? null
                  : 'Nama wajib diisi.',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            AuthField(
              label: 'Email',
              hint: 'nama@contoh.com',
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            AuthField(
              label: 'Kata sandi',
              hint: 'Buat kata sandi minimal 8 karakter',
              controller: _passwordController,
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'Gunakan minimal 8 karakter.';
                }
                return null;
              },
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
            const SizedBox(height: 10),
            AuthField(
              key: const ValueKey('register-confirm-password-field'),
              label: 'Konfirmasi kata sandi',
              hint: 'Masukkan ulang kata sandi',
              controller: _confirmPasswordController,
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Konfirmasi kata sandi wajib diisi.';
                }
                if (value != _passwordController.text) {
                  return 'Konfirmasi kata sandi tidak cocok.';
                }
                return null;
              },
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  key: const ValueKey('register-terms-checkbox'),
                  value: _agreedToTerms,
                  onChanged: (value) => setState(() {
                    _agreedToTerms = value ?? false;
                    _termsError = null;
                  }),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Saya setuju dengan Syarat & Privasi.',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            if (_termsError case final error?) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 8),
                child: Text(
                  error,
                  style: const TextStyle(color: AppColors.red, fontSize: 11),
                ),
              ),
            ],
            AuthPrimaryButton(
              key: const ValueKey('register-submit'),
              label: 'Daftar',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
            const AuthDivider(),
            const SizedBox(height: 14),
            AuthGoogleButton(
              onPressed: () => showAuthDemoMessage(
                context,
                'Pendaftaran dengan Google belum tersedia.',
              ),
            ),
            const SizedBox(height: 14),
            const AuthDemoNotice(),
          ],
        ),
      ),
      footer: AuthFooterLink(
        description: 'Sudah punya akun?',
        label: 'Masuk',
        onPressed: widget.onSignIn,
      ),
    );
  }
}
