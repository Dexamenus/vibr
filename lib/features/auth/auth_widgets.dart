import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/top_toast.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.content,
    required this.footer,
  });

  final Widget content;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 36,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthBrand(),
                        const SizedBox(height: 34),
                        content,
                        const Spacer(),
                        const SizedBox(height: 28),
                        footer,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBrand extends StatelessWidget {
  const AuthBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/img/tekslogo.png',
        width: 82,
        height: 28,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        semanticLabel: 'Vibr',
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.suffix,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'atau lanjutkan dengan',
            style: TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        label: const Text('Google'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.surfaceRaised,
          side: const BorderSide(color: AppColors.surfaceRaised),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class AuthDemoNotice extends StatelessWidget {
  const AuthDemoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Mode demo: autentikasi belum terhubung ke server.',
      textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.muted, fontSize: 10),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.description,
    required this.label,
    required this.onPressed,
  });

  final String description;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          description,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

void showAuthDemoMessage(BuildContext context, String message) {
  showTopToast(
    context,
    title: 'Informasi',
    message: message,
    icon: Icons.info_outline_rounded,
    iconColor: AppColors.accent,
  );
}
