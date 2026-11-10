import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/top_toast.dart';

enum _RemovalStage { upload, processing, result }

class RemoveBackgroundScreen extends StatefulWidget {
  const RemoveBackgroundScreen({super.key});

  @override
  State<RemoveBackgroundScreen> createState() => _RemoveBackgroundScreenState();
}

class _RemoveBackgroundScreenState extends State<RemoveBackgroundScreen> {
  Uint8List? _imageBytes;
  String? _imageName;
  _RemovalStage _stage = _RemovalStage.upload;
  bool _isPickingImage = false;
  Timer? _processingTimer;

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );
      if (!mounted || result.isEmpty) return;

      final file = result.first;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      if (bytes.isEmpty) {
        _showMessage('Gambar yang dipilih tidak dapat dibaca.');
        return;
      }
      if (bytes.lengthInBytes > 10 * 1024 * 1024) {
        _showMessage('Ukuran gambar maksimal 10 MB.');
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _imageName = file.name;
        _stage = _RemovalStage.upload;
      });
    } on PlatformException catch (error) {
      if (mounted) {
        _showMessage(error.message ?? 'Tidak dapat membuka pemilih gambar.');
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  void _startRemoval() {
    if (_imageBytes == null) return;
    setState(() => _stage = _RemovalStage.processing);
    _processingTimer?.cancel();
    _processingTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _stage = _RemovalStage.result);
    });
  }

  void _reset() {
    _processingTimer?.cancel();
    setState(() {
      _imageBytes = null;
      _imageName = null;
      _stage = _RemovalStage.upload;
    });
  }

  void _showMessage(String message) {
    showTopToast(
      context,
      title: 'Informasi',
      message: message,
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.accent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_stage) {
      _RemovalStage.upload => 'Hapus BG',
      _RemovalStage.processing => 'Penghapus latar',
      _RemovalStage.result => 'Penghapus Background',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          key: const ValueKey('remove-bg-back'),
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(title, style: const TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            key: const ValueKey('remove-bg-close'),
            tooltip: 'Tutup',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: switch (_stage) {
                  _RemovalStage.upload => _UploadStage(
                    key: const ValueKey('remove-bg-upload-stage'),
                    imageBytes: _imageBytes,
                    imageName: _imageName,
                    isPickingImage: _isPickingImage,
                    onPickImage: _pickImage,
                  ),
                  _RemovalStage.processing => const _ProcessingStage(
                    key: ValueKey('remove-bg-processing-stage'),
                  ),
                  _RemovalStage.result => _ResultStage(
                    key: const ValueKey('remove-bg-result-stage'),
                    imageBytes: _imageBytes!,
                    onChooseAnother: _reset,
                  ),
                },
              ),
            ),
            _BottomAction(
              stage: _stage,
              hasImage: _imageBytes != null,
              onStart: _startRemoval,
              onDownload: () => _showMessage(
                'Pengunduhan tersedia setelah penghapus latar otomatis terhubung.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadStage extends StatelessWidget {
  const _UploadStage({
    super.key,
    required this.imageBytes,
    required this.imageName,
    required this.isPickingImage,
    required this.onPickImage,
  });

  final Uint8List? imageBytes;
  final String? imageName;
  final bool isPickingImage;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Text(
          'Unggah gambar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          key: const ValueKey('remove-bg-pick-image'),
          onTap: isPickingImage ? null : onPickImage,
          borderRadius: BorderRadius.circular(12),
          child: CustomPaint(
            painter: _DashedBorderPainter(color: AppColors.accent, radius: 12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 128),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageBytes == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isPickingImage)
                          const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.accentSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.file_upload_outlined,
                              color: AppColors.accent,
                              size: 20,
                            ),
                          ),
                        const SizedBox(height: 9),
                        Text(
                          isPickingImage
                              ? 'Membuka gambar...'
                              : 'Pilih file untuk diunggah',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'JPG, PNG, atau WEBP · Maks. 10 MB',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            imageBytes!,
                            height: 128,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          imageName ?? 'Gambar dipilih',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ketuk untuk memilih gambar lain',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (imageBytes == null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 17,
                  color: AppColors.muted,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Pilih foto produk atau objek dengan subjek yang terlihat jelas.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ProcessingStage extends StatelessWidget {
  const _ProcessingStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                AppColors.surface,
                AppColors.surfaceRaised,
                AppColors.surface,
              ],
              stops: [0.2, 0.5, 0.8],
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 22),
              SizedBox(height: 12),
              Text(
                'Sedang memproses...',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              SizedBox(height: 14),
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  backgroundColor: AppColors.border,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Pratinjau demo · pemrosesan otomatis belum aktif',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultStage extends StatelessWidget {
  const _ResultStage({
    super.key,
    required this.imageBytes,
    required this.onChooseAnother,
  });

  final Uint8List imageBytes;
  final VoidCallback onChooseAnother;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _Checkerboard(),
                Image.memory(imageBytes, fit: BoxFit.contain),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 17,
                color: AppColors.amber,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Ini pratinjau antarmuka. Gambar belum diproses dan latarnya belum dihapus.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onChooseAnother,
            icon: const Icon(Icons.refresh_rounded, size: 17),
            label: const Text('Pilih gambar lain'),
          ),
        ),
      ],
    );
  }
}

class _Checkerboard extends StatelessWidget {
  const _Checkerboard();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CheckerboardPainter());
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.stage,
    required this.hasImage,
    required this.onStart,
    required this.onDownload,
  });

  final _RemovalStage stage;
  final bool hasImage;
  final VoidCallback onStart;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    if (stage == _RemovalStage.processing) {
      return const SizedBox(height: 16);
    }

    final isResult = stage == _RemovalStage.result;
    final enabled = isResult || hasImage;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          key: ValueKey(isResult ? 'remove-bg-download' : 'remove-bg-start'),
          onPressed: !enabled
              ? null
              : isResult
              ? onDownload
              : onStart,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.48),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: Text(isResult ? 'Unduh' : 'Mulai Hapus'),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + 6).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + 4;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color || radius != oldDelegate.radius;
}

class _CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tileSize = 18.0;
    final light = Paint()..color = const Color(0xFF3B3942);
    final dark = Paint()..color = const Color(0xFF29272F);

    for (var row = 0; row * tileSize < size.height; row++) {
      for (var column = 0; column * tileSize < size.width; column++) {
        final paint = (row + column).isEven ? light : dark;
        canvas.drawRect(
          Rect.fromLTWH(column * tileSize, row * tileSize, tileSize, tileSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerboardPainter oldDelegate) => false;
}
