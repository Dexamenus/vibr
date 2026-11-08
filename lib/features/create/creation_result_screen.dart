import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/creation_header.dart';
import '../../shared/widgets/generated_artwork.dart';
import '../../shared/widgets/top_toast.dart';
import 'create_options.dart';
import 'creation_form.dart';
import 'creation_form_controller.dart';
import 'creation_mode.dart';

// enum: dua status layar ini, sedang dibuat (loading) atau sudah jadi (ready).
enum _GenerationStatus { loading, ready }

// Layar hasil. Stateful karena tampilannya berubah: loading lalu gambar jadi.
class CreationResultScreen extends StatefulWidget {
  const CreationResultScreen({
    super.key,
    required this.controller,
    this.mode = CreationMode.ai,
  });

  /// Shared with the Create screen, so the form keeps what was entered there.
  final CreationFormController controller;
  final CreationMode mode;

  @override
  State<CreationResultScreen> createState() => _CreationResultScreenState();
}

class _CreationResultScreenState extends State<CreationResultScreen> {
  _GenerationStatus _status = _GenerationStatus.loading;
  int _seed = 0;
  // Timer menjalankan kode setelah jeda waktu (simulasi proses generate 3 detik).
  Timer? _timer;

  CreationFormController get _form => widget.controller;
  // late: diisi saat pertama dipakai. Rasio yang benar-benar dipakai di preview,
  // baru berubah saat bikin ulang.
  late String _appliedRatio = _form.ratio;

  // initState(): dijalankan sekali saat layar pertama dibuat, langsung mulai proses generate.
  @override
  void initState() {
    super.initState();
    _startGeneration();
  }

  // dispose(): batalkan timer saat layar ditutup.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Simulated generation until the image API is wired in.
  void _startGeneration() {
    _timer?.cancel();
    // Rotation and ratio only apply when (re)generating, not while editing.
    _appliedRatio = _form.ratio;
    // setState: memberi tahu Flutter bahwa state berubah, supaya layar digambar ulang (tampil loading).
    setState(() => _status = _GenerationStatus.loading);
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _status = _GenerationStatus.ready);
      showTopToast(context, message: 'Gambarmu sudah jadi lho!');
    });
  }

  // Bikin Ulang: prompt harus terisi, lalu proses generate diulang.
  void _regenerate() {
    if (!_form.validatePrompt()) {
      showTopToast(
        context,
        message: 'Isi prompt dulu ya, baru bisa bikin ulang.',
        icon: Icons.edit_note_rounded,
        iconColor: AppColors.amber,
      );
      return;
    }
    // A bigger step so the new artwork is visibly different from the last.
    _seed += 3;
    _startGeneration();
  }

  double get _aspect => CreateOptions.aspectOf(_appliedRatio);

  // build(): menyusun tampilan. Dipanggil ulang setiap setState().
  @override
  Widget build(BuildContext context) {
    // ready bernilai true kalau gambar sudah jadi, dipakai untuk memilih tampilan.
    final ready = _status == _GenerationStatus.ready;

    // Scaffold: kerangka halaman hasil. Isi di atas (scroll), tombol Bikin Ulang / Download di bawah.
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: tombol kembali dan tutup. Tutup (popUntil) langsung kembali ke halaman paling awal (Beranda).
                        CreationHeader(
                          title: 'Hasil Karyamu',
                          onBack: () => Navigator.of(context).maybePop(),
                          onClose: () =>
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst),
                        ),
                        const SizedBox(height: 14),
                        const SizedBox(height: 16),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 420),
                            // AspectRatio: menjaga bentuk preview sesuai rasio pilihan (1:1, 4:5, 9:16, dst).
                            child: AspectRatio(
                              aspectRatio: _aspect,
                              // AnimatedSwitcher: transisi halus dari kartu loading ke gambar hasil.
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                // Ternary: kalau ready tampilkan gambar, kalau belum tampilkan kartu loading.
                                child: ready
                                    ? LayoutBuilder(
                                        key: ValueKey(_seed),
                                        builder: (context, constraints) =>
                                            GeneratedArtwork(
                                              height: constraints.maxHeight,
                                              seed: _seed,
                                            ),
                                      )
                                    : const _LoadingPreview(),
                              ),
                            ),
                          ),
                        ),
                        // Tombol 'Buat dengan Canva' hanya muncul di mode Canva setelah gambar jadi.
                        if (ready && widget.mode == CreationMode.canva) ...[
                          const SizedBox(height: 12),
                          _CanvaButton(
                            onPressed: () => showTopToast(
                              context,
                              message: 'Membuka desainmu di Canva...',
                              icon: Icons.open_in_new_rounded,
                              iconColor: AppColors.accent,
                            ),
                          ),
                        ],
                        // Setelah gambar jadi, form muncul lagi di bawahnya supaya bisa diubah lalu dibikin ulang.
                        if (ready) ...[
                          const SizedBox(height: 40),
                          CreationForm(
                            controller: _form,
                            showModel: widget.mode.showsModel,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                // Area tombol bawah yang selalu terlihat (tidak ikut ter-scroll).
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _BottomButton(
                              label: 'Bikin Ulang',
                              primary: true,
                              // onPressed null = tombol nonaktif (saat masih loading).
                              onPressed: ready ? _regenerate : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BottomButton(
                              label: 'Download',
                              primary: false,
                              onPressed: ready
                                  ? () => showTopToast(
                                      context,
                                      message:
                                          'Fitur download segera hadir ya!',
                                      icon: Icons.download_rounded,
                                      iconColor: AppColors.accent,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tombol 'Buat dengan Canva' (widget kecil terpisah).
class _CanvaButton extends StatelessWidget {
  const _CanvaButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.surfaceRaised,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Buat dengan Canva'),
      ),
    );
  }
}

// Tombol bawah yang bisa berwarna utama (ungu) atau sekunder lewat parameter primary.
class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.primary,
    required this.onPressed,
  });

  final String label;
  final bool primary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primary ? AppColors.accent : AppColors.surfaceRaised,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.surfaceRaised,
          disabledForegroundColor: AppColors.muted,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

// Kartu loading dengan efek kilau. Stateful karena memegang AnimationController.
class _LoadingPreview extends StatefulWidget {
  const _LoadingPreview();

  @override
  State<_LoadingPreview> createState() => _LoadingPreviewState();
}

class _LoadingPreviewState extends State<_LoadingPreview>
    // mixin: memberi 'detak' (ticker) yang dibutuhkan AnimationController.
    with SingleTickerProviderStateMixin {
  // AnimationController: pengatur waktu animasi. ..repeat() membuatnya berulang terus.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(20),
        ),
        // Stack: kilau animasi ditumpuk di belakang ikon dan teks.
        child: Stack(
          fit: StackFit.expand,
          children: [
            // AnimatedBuilder: gambar ulang tiap frame animasi untuk menggeser kilau.
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1.6 + t * 3.2, 0),
                      end: Alignment(-0.6 + t * 3.2, 0),
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.07),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  size: 30,
                  color: Color(0xFFB59CFF),
                ),
                SizedBox(height: 14),
                Text(
                  'Lagi mewujudkan idemu...',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(height: 14),
                Text(
                  'Gambarmu lagi dibuat...',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
