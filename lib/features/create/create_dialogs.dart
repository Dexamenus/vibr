part of 'create_screen.dart';

enum _PublishAction { postNow, schedule }

class _CaptionPromptDialog extends StatefulWidget {
  const _CaptionPromptDialog();

  @override
  State<_CaptionPromptDialog> createState() => _CaptionPromptDialogState();
}

class _CaptionPromptDialogState extends State<_CaptionPromptDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) {
      setState(() => _error = 'Masukkan topik atau ide untuk melanjutkan.');
      return;
    }
    Navigator.of(context).pop(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceRaised,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Jelaskan ide caption',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Caption ini ingin membahas apa?',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextField(
              key: const ValueKey('caption-prompt-field'),
              controller: _controller,
              autofocus: true,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Contoh: koleksi musim semi terbaru',
                errorText: _error,
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
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const ValueKey('generate-from-prompt'),
                  onPressed: _submit,
                  child: const Text('Buat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PublishOptionsDialog extends StatelessWidget {
  const _PublishOptionsDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceRaised,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Terbitkan sekarang atau jadwalkan?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Tutup',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 4),
            PrimaryButton(
              label: 'Terbitkan sekarang',
              showIcon: false,
              onPressed: () => Navigator.pop(context, _PublishAction.postNow),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () =>
                    Navigator.pop(context, _PublishAction.schedule),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Jadwalkan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
