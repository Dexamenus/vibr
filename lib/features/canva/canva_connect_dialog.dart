import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'canva_connection.dart';
import 'canva_dialog_shell.dart';

/// Dark dialog that walks through linking a Canva account.
/// Pops `true` once the account is authorized, `false`/null when cancelled.
class CanvaConnectDialog extends StatefulWidget {
  const CanvaConnectDialog({super.key, required this.connection});

  final CanvaConnection connection;

  @override
  State<CanvaConnectDialog> createState() => _CanvaConnectDialogState();
}

class _CanvaConnectDialogState extends State<CanvaConnectDialog> {
  static const _palette = CanvaPalette.dark;
  bool _authorizing = false;

  Future<void> _continue() async {
    setState(() => _authorizing = true);
    await widget.connection.authorize();
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return CanvaDialogShell(
      palette: _palette,
      title: 'Hubungkan Canva',
      description:
          'Tautkan akun Canva ke ruang kerjamu dengan otorisasi akun yang '
          'aman.',
      onClose: () => Navigator.of(context).pop(false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _palette.panel,
              border: Border.all(color: _palette.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Otorisasi melalui Canva',
                        style: TextStyle(
                          color: _palette.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tanpa membagikan kata sandi atau API key.',
                        style: TextStyle(color: _palette.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _Step(
            number: 1,
            title: 'Masuk ke akun Canva',
            subtitle: 'Lanjutkan ke Canva melalui jendela otorisasi.',
          ),
          const _Step(
            number: 2,
            title: 'Tinjau dan berikan izin',
            subtitle: 'Pilih akun yang tepat dan setujui akses di Canva.',
          ),
          const _Step(
            number: 3,
            title: 'Kembali ke ruang kerja',
            subtitle: 'Koneksi diperbarui setelah otorisasi berhasil.',
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _palette.panel,
              border: Border.all(color: _palette.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kamu tetap mengendalikan akses',
                  style: TextStyle(
                    color: _palette.text,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Izin yang diminta ditampilkan di Canva sebelum kamu '
                  'menyetujui. Akses bisa dicabut lewat pengaturan akun '
                  'Canva.',
                  style: TextStyle(
                    color: _palette.muted,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      footer: Row(
        children: [
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _authorizing
                  ? null
                  : () => Navigator.of(context).pop(false),
              style: FilledButton.styleFrom(
                backgroundColor: _palette.closeBackground,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _palette.closeBackground,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _authorizing ? null : _continue,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.accent.withValues(
                    alpha: 0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _authorizing
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Lanjutkan ke Canva'),
                            SizedBox(width: 6),
                            Icon(Icons.north_east_rounded, size: 15),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final int number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    const palette = CanvaPalette.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentSoft,
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: palette.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: palette.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
