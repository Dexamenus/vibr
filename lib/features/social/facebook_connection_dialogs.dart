import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/top_toast.dart';
import 'facebook_demo_connection.dart';

Future<bool> ensureFacebookConnected(
  BuildContext context,
  FacebookDemoConnection connection,
) async {
  await connection.load();
  if (!context.mounted) return false;
  if (connection.connected) return true;

  final shouldConnect = await showDialog<bool>(
    context: context,
    builder: (_) => const _FacebookStatusDialog(),
  );
  if (shouldConnect != true || !context.mounted) return false;

  final authorized = await showDialog<bool>(
    context: context,
    builder: (_) => const _FacebookConnectDialog(),
  );
  if (authorized != true || !context.mounted) return false;

  final connected = await connection.authorize();
  if (!connected) {
    if (context.mounted) {
      showTopToast(
        context,
        title: 'Koneksi belum tersimpan',
        message: 'Coba hubungkan Halaman Facebook kembali.',
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.red,
      );
    }
    return false;
  }

  if (context.mounted) {
    showTopToast(
      context,
      title: 'Facebook berhasil terhubung',
      message: 'Halaman demo ${connection.account} siap digunakan.',
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.teal,
    );
  }
  return true;
}

class _FacebookStatusDialog extends StatelessWidget {
  const _FacebookStatusDialog();

  @override
  Widget build(BuildContext context) {
    return _FacebookDialogShell(
      title: 'Status koneksi Facebook',
      description:
          'Hubungkan Halaman Facebook ke ruang kerjamu untuk mengelola '
          'konten merek.',
      onClose: () => Navigator.of(context).pop(false),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const _FacebookIcon(size: 38),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halaman Facebook',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Koneksi akun sosial',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const _FacebookStatusBadge(),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                const _InfoRow(
                  label: 'Halaman Facebook',
                  value: 'Belum ditautkan',
                ),
                const SizedBox(height: 9),
                const _InfoRow(label: 'Otorisasi', value: 'Simulasi demo'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _DemoNotice(
            message:
                'Koneksi ini hanya simulasi. Tidak ada akun Facebook sungguhan '
                'yang diakses atau kata sandi yang diminta.',
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: _SecondaryButton(
              label: 'Nanti',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: FilledButton(
              key: const ValueKey('facebook-status-connect'),
              onPressed: () => Navigator.of(context).pop(true),
              style: _primaryButtonStyle(),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Hubungkan Facebook'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacebookConnectDialog extends StatelessWidget {
  const _FacebookConnectDialog();

  @override
  Widget build(BuildContext context) {
    return _FacebookDialogShell(
      title: 'Hubungkan Halaman Facebook',
      description:
          'Ikuti langkah berikut untuk menautkan Halaman Facebook demo '
          'ke ruang kerjamu.',
      onClose: () => Navigator.of(context).pop(false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _AuthorizationStep(
            number: 1,
            title: 'Masuk ke akun Facebook',
            subtitle: 'Pada integrasi asli, kamu akan diarahkan ke Facebook.',
          ),
          _AuthorizationStep(
            number: 2,
            title: 'Pilih Halaman Facebook',
            subtitle: 'Pilih Halaman yang mewakili merek atau bisnismu.',
          ),
          _AuthorizationStep(
            number: 3,
            title: 'Tinjau dan berikan izin',
            subtitle: 'Setujui akses yang diperlukan untuk mengelola konten.',
          ),
          _AuthorizationStep(
            number: 4,
            title: 'Kembali ke ruang kerja',
            subtitle: 'Status koneksi akan diperbarui setelah selesai.',
            isLast: true,
          ),
          SizedBox(height: 8),
          _DemoNotice(
            message:
                'Mode demo: tombol di bawah hanya menandai Halaman '
                '“Zahira Studio” sebagai terhubung di perangkat ini.',
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: _SecondaryButton(
              key: const ValueKey('facebook-connect-cancel'),
              label: 'Batal',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: FilledButton(
              key: const ValueKey('facebook-authorize-demo'),
              onPressed: () => Navigator.of(context).pop(true),
              style: _primaryButtonStyle(),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Simulasikan koneksi'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacebookDialogShell extends StatelessWidget {
  const _FacebookDialogShell({
    required this.title,
    required this.description,
    required this.body,
    required this.footer,
    required this.onClose,
  });

  final String title;
  final String description;
  final Widget body;
  final Widget footer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 700),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF111016),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1877F2),
                          Color(0xFF5B5BF0),
                          Color(0xFF8057FF),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const _FacebookIcon(size: 38),
                            const SizedBox(width: 11),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Koneksi akun sosial',
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              key: const ValueKey('facebook-dialog-close'),
                              onPressed: onClose,
                              tooltip: 'Tutup',
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.muted,
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          description,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 17),
                        body,
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                Padding(padding: const EdgeInsets.all(16), child: footer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FacebookIcon extends StatelessWidget {
  const _FacebookIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.facebook_rounded,
        color: const Color(0xFF6EA8FF),
        size: size * 0.62,
      ),
    );
  }
}

class _FacebookStatusBadge extends StatelessWidget {
  const _FacebookStatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: AppColors.amber),
          SizedBox(width: 6),
          Text(
            'Belum terhubung',
            style: TextStyle(
              color: AppColors.amber,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.07),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.amber,
            size: 17,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorizationStep extends StatelessWidget {
  const _AuthorizationStep({
    required this.number,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  final int number;
  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 12 : 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Color(0xFFD8CCFF),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        key: key,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.surfaceRaised,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

ButtonStyle _primaryButtonStyle() => FilledButton.styleFrom(
  backgroundColor: AppColors.accent,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
