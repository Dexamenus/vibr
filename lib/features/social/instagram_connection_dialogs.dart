import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/top_toast.dart';
import 'instagram_demo_connection.dart';

Future<bool> ensureInstagramConnected(
  BuildContext context,
  InstagramDemoConnection connection,
) async {
  await connection.load();
  if (!context.mounted) return false;
  if (connection.connected) return true;

  final shouldConnect = await showDialog<bool>(
    context: context,
    builder: (_) => const _InstagramStatusDialog(),
  );
  if (shouldConnect != true || !context.mounted) return false;

  final authorized = await showDialog<bool>(
    context: context,
    builder: (_) => const _InstagramConnectDialog(),
  );
  if (authorized != true || !context.mounted) return false;

  final connected = await connection.authorize();
  if (!connected) {
    if (context.mounted) {
      showTopToast(
        context,
        title: 'Koneksi belum tersimpan',
        message: 'Coba hubungkan Instagram kembali.',
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.red,
      );
    }
    return false;
  }

  if (context.mounted) {
    showTopToast(
      context,
      title: 'Instagram berhasil terhubung',
      message: 'Akun demo ${connection.account} siap digunakan.',
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.teal,
    );
  }
  return true;
}

class _InstagramStatusDialog extends StatelessWidget {
  const _InstagramStatusDialog();

  @override
  Widget build(BuildContext context) {
    return _InstagramDialogShell(
      title: 'Status koneksi Instagram',
      description:
          'Hubungkan akun Instagram profesional ke ruang kerjamu untuk '
          'mengelola konten.',
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
                    const _InstagramIcon(size: 38),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instagram',
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
                    _ConnectionBadge(
                      label: 'Belum terhubung',
                      color: AppColors.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                const _InfoRow(
                  label: 'Akun Instagram',
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
                'Koneksi ini hanya simulasi. Tidak ada akun Instagram sungguhan '
                'yang diakses atau kata sandi yang diminta.',
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.surfaceRaised,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Nanti'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 46,
              child: FilledButton(
                key: const ValueKey('instagram-status-connect'),
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Hubungkan Instagram'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstagramConnectDialog extends StatelessWidget {
  const _InstagramConnectDialog();

  @override
  Widget build(BuildContext context) {
    return _InstagramDialogShell(
      title: 'Hubungkan Instagram',
      description:
          'Ikuti langkah berikut untuk menautkan akun demo Instagram ke '
          'ruang kerjamu.',
      onClose: () => Navigator.of(context).pop(false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _AuthorizationStep(
            number: 1,
            title: 'Masuk ke akun Instagram',
            subtitle: 'Pada integrasi asli, kamu akan diarahkan ke Instagram.',
          ),
          _AuthorizationStep(
            number: 2,
            title: 'Pilih akun profesional',
            subtitle: 'Pilih akun yang ingin digunakan untuk merekmu.',
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
                'Mode demo: tombol di bawah hanya menandai akun '
                '@zahira.studio sebagai terhubung di perangkat ini.',
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: OutlinedButton(
                key: const ValueKey('instagram-connect-cancel'),
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.surfaceRaised,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 46,
              child: FilledButton(
                key: const ValueKey('instagram-authorize-demo'),
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Simulasikan koneksi'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstagramDialogShell extends StatelessWidget {
  const _InstagramDialogShell({
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
                          Color(0xFFFFB347),
                          Color(0xFFE1306C),
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
                            const _InstagramIcon(size: 38),
                            const SizedBox(width: 11),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Instagram',
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
                              key: const ValueKey('instagram-dialog-close'),
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

class _InstagramIcon extends StatelessWidget {
  const _InstagramIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFFFB347), Color(0xFFE1306C), Color(0xFF8057FF)],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
        size: size * 0.52,
      ),
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
