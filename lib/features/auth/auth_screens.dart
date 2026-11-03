import 'package:flutter/material.dart';

import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_page.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/brand_logo.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/show_demo_message.dart';
import '../onboarding/setup_brand_screen.dart';
import '../shell/home_shell.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _signIn() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeShell(controller: widget.controller),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandLogo(),
              const SizedBox(height: 60),
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your next great idea is waiting.',
                style: TextStyle(color: AppColors.muted, fontSize: 17),
              ),
              const SizedBox(height: 8),
              const Text(
                'Demo mode · use any valid email and password',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 38),
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 19),
              AppTextField(
                label: 'Password',
                hint: 'Enter your password',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signIn(),
                suffix: IconButton(
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Password is required'
                    : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => showDemoMessage(
                    context,
                    'Password reset is available when an account service is connected.',
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ),
              ),
              PrimaryButton(label: 'Sign In', onPressed: _signIn),
              const SizedBox(height: 26),
              const _OrDivider(),
              const SizedBox(height: 18),
              _SocialAuthButton(
                label: 'Continue with Facebook',
                icon: Icons.facebook_rounded,
                onPressed: () => showDemoMessage(
                  context,
                  'Facebook sign-in needs an account provider.',
                ),
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  Expanded(
                    child: _SocialAuthButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: () => showDemoMessage(
                        context,
                        'Google sign-in needs an account provider.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: _SocialAuthButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      onPressed: () => showDemoMessage(
                        context,
                        'Apple sign-in needs an account provider.',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.muted),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              SignUpScreen(controller: widget.controller),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      showDemoMessage(
        context,
        'Please accept the Terms of Service to continue.',
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SetupBrandScreen(
          controller: widget.controller,
          initialBrandName: _nameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandLogo(),
              const SizedBox(height: 38),
              Text(
                'Create your account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'A little intelligence for every post.',
                style: TextStyle(color: AppColors.muted, fontSize: 17),
              ),
              const SizedBox(height: 28),
              AppTextField(
                label: 'Name',
                hint: 'Your full name',
                controller: _nameController,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),
              const SizedBox(height: 17),
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 17),
              AppTextField(
                label: 'Password',
                hint: 'Create a strong password',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                suffix: IconButton(
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 8) return 'Use at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 6),
              CheckboxListTile(
                value: _acceptedTerms,
                onChanged: (value) =>
                    setState(() => _acceptedTerms = value ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.accent,
                title: const Text(
                  'I agree to the Terms of Service and Privacy Policy',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(label: 'Sign Up', onPressed: _createAccount),
              const SizedBox(height: 22),
              const _OrDivider(),
              const SizedBox(height: 16),
              _SocialAuthButton(
                label: 'Continue with Facebook',
                icon: Icons.facebook_rounded,
                onPressed: () => showDemoMessage(
                  context,
                  'Facebook sign-in needs an account provider.',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _SocialAuthButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: () => showDemoMessage(
                        context,
                        'Google sign-in needs an account provider.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SocialAuthButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      onPressed: () => showDemoMessage(
                        context,
                        'Apple sign-in needs an account provider.',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.9),
              fontSize: 13,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
    return 'Enter a valid email address';
  }
  return null;
}
