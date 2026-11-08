import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/top_toast.dart';
import 'canva_connection.dart';
import 'canva_dialog_shell.dart';

enum CanvaStatusResult { connect, connected }

/// Light dialog showing whether Canva is linked, with a re-check button.
class CanvaStatusDialog extends StatefulWidget {
  const CanvaStatusDialog({super.key, required this.connection});

  final CanvaConnection connection;

  @override
  State<CanvaStatusDialog> createState() => _CanvaStatusDialogState();
}

class _CanvaStatusDialogState extends State<CanvaStatusDialog> {
  static const _palette = CanvaPalette.dark;
  bool _checking = false;

  Future<void> _check() async {
    setState(() => _checking = true);
    final connected = await widget.connection.check();
    if (!mounted) return;
    setState(() => _checking = false);
    if (connected) {
      Navigator.of(context).pop(CanvaStatusResult.connected);
    } else {
      showTopToast(
        context,
        message: 'Canva belum terhubung, hubungkan dulu ya.',
        icon: Icons.link_off_rounded,
        iconColor: AppColors.amber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CanvaDialogShell(
      palette: _palette,
      title: 'Status koneksi Canva',
      description:
          'Periksa koneksi MCP Canva sebelum mulai menggunakan desain di '
          'ruang kerjamu.',
      onClose: () => Navigator.of(context).pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _palette.panel,
              border: Border.all(color: _palette.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: _palette.closeBackground,
                        border: Border.all(color: _palette.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.power_outlined,
                        size: 18,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MCP Canva',
                            style: TextStyle(
                              color: _palette.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Integrasi ruang kerja',
                            style: TextStyle(
                              color: _palette.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 132),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: AppColors.amber,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Belum terhubung',
                                style: TextStyle(
                                  color: AppColors.amber,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: _palette.border),
                const SizedBox(height: 12),
                _StatusRow(label: 'Akun Canva', value: 'Belum ditautkan'),
                const SizedBox(height: 10),
                _StatusRow(label: 'Otorisasi', value: 'Diperlukan'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.07),
              border: Border.all(
                color: AppColors.amber.withValues(alpha: 0.25),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.link_off_rounded,
                    size: 18,
                    color: AppColors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Canva belum siap digunakan',
                        style: TextStyle(
                          color: _palette.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hubungkan akun untuk mengakses desain melalui '
                        'MCP. Kalau sudah memberi izin, periksa lagi '
                        'koneksinya.',
                        style: TextStyle(
                          color: _palette.muted,
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _checking ? null : _check,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _palette.text,
                  backgroundColor: _palette.closeBackground,
                  side: BorderSide(color: _palette.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _checking
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _palette.muted,
                        ),
                      )
                    : const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Periksa lagi',
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(CanvaStatusResult.connect),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Hubungkan Canva'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    const palette = CanvaPalette.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: palette.muted, fontSize: 12.5)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: palette.text,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
