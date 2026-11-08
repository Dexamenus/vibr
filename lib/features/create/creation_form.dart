import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/info_dialog.dart';
import '../../shared/widgets/option_group.dart';
import '../../shared/widgets/show_demo_message.dart';
import 'create_options.dart';
import 'creation_form_controller.dart';


// bikin form buat bikin gambar pake AI, termasuk prompt, model, style, tone, ratio, dan referensi gambar.
/// Prompt, model/style/tone/ratio choices and reference images.
class CreationForm extends StatelessWidget {
  CreationForm({super.key, required this.controller, this.showModel = true});

  final CreationFormController controller;
  final bool showModel;
  // ImagePicker (paket image_picker): untuk memilih gambar dari galeri.
  final _picker = ImagePicker();

  // async/await: memilih gambar butuh waktu, jadi ditunggu tanpa membekukan layar.
  // Maksimal 4 gambar; kalau sudah penuh muncul popup batas.
  Future<void> _pickReferences(BuildContext context) async {
    final remaining =
        CreationFormController.maxReferences - controller.references.length;
    if (remaining <= 0) {
      await _showLimitDialog(context);
      return;
    }
    // try-catch: kalau galeri gagal dibuka, tampil pesan dan app tidak crash.
    try {
      // image_picker only accepts a multi-pick limit of 2 or more.
      final picked = remaining == 1
          ? [?await _picker.pickImage(source: ImageSource.gallery)]
          : await _picker.pickMultiImage(limit: remaining);
      if (picked.isEmpty) return;
      // Baca semua gambar terpilih jadi data byte (Uint8List) supaya bisa ditampilkan dengan Image.memory.
      final bytes = await Future.wait(
        picked.take(remaining).map((file) => file.readAsBytes()),
      );
      controller.addReferences(bytes);
      if (picked.length > remaining && context.mounted) {
        await _showLimitDialog(context);
      }
    } catch (_) {
      if (!context.mounted) return;
      showDemoMessage(
        context,
        'Galerinya nggak bisa dibuka nih, coba lagi ya.',
      );
    }
  }

  // Popup (AlertDialog) pemberitahuan batas referensi.
  Future<void> _showLimitDialog(BuildContext context) {
    return showInfoDialog(
      context,
      icon: Icons.image_not_supported_outlined,
      iconColor: AppColors.amber,
      title: 'Batas referensi tercapai',
      message:
          'Kamu cuma bisa pasang maksimal '
          '${CreationFormController.maxReferences} gambar referensi. '
          'Hapus satu dulu kalau mau nambah.',
      buttonLabel: 'Oke, paham',
    );
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: bagian form ini digambar ulang otomatis tiap controller memanggil notifyListeners().
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final references = controller.references;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Prompt kamu'),
            const SizedBox(height: 10),
            // TextField: input teks. controller menyimpan isinya, error menampilkan pesan validasi (wajib diisi).
            TextField(
              controller: controller.promptController,
              minLines: 5,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Ceritain apa yang mau kamu bikin...',
                error: controller.promptError == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 18,
                              color: AppColors.red,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                controller.promptError!,
                                style: const TextStyle(
                                  color: AppColors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            // Pilihan Model hanya muncul di mode AI (di mode Canva disembunyikan).
            if (showModel)
              OptionGroup(
                label: 'Model',
                options: CreateOptions.models,
                selected: controller.model,
                onSelected: (v) => controller.model = v,
              ),
            // OptionGroup (widget buatan sendiri): label + deretan pilihan.
            // Dipakai berulang untuk Gaya visual, Gaya bahasa, Rotasi, dan Rasio.
            OptionGroup(
              label: 'Gaya visual',
              options: CreateOptions.styles,
              selected: controller.style,
              onSelected: (v) => controller.style = v,
            ),
            OptionGroup(
              label: 'Gaya bahasa',
              options: CreateOptions.tones,
              selected: controller.tone,
              onSelected: (v) => controller.tone = v,
            ),
            OptionGroup(
              label: 'Rotasi gambar',
              options: CreateOptions.rotations,
              selected: controller.rotation,
              onSelected: (v) => controller.rotation = v,
            ),
            OptionGroup(
              label: 'Rasio gambar',
              // Daftar rasio berubah sesuai rotasi (Potret / Lanskap).
              options: CreateOptions.ratiosFor(controller.rotation),
              selected: controller.ratio,
              onSelected: (v) => controller.ratio = v,
            ),
            const SizedBox(height: 22),
            // Tombol tambah referensi dibuat selebar layar (width: double.infinity).
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => _pickReferences(context),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Tambah gambar / referensi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.surfaceRaised,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            // Thumbnail hanya tampil kalau sudah ada referensi. '...[' = menyisipkan beberapa widget sekaligus.
            if (references.isNotEmpty) ...[
              const SizedBox(height: 14),
              // Wrap: thumbnail berderet ke samping dan otomatis turun baris kalau tidak muat.
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // collection-for: membuat satu thumbnail untuk setiap gambar di list references.
                  for (var i = 0; i < references.length; i++)
                    _ReferenceThumbnail(
                      bytes: references[i],
                      onRemove: () => controller.removeReferenceAt(i),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

// tutup tombol tambah referensi, thumbnail referensi, dan tombol hapus thumbnail referensi
class _ReferenceThumbnail extends StatelessWidget {
  const _ReferenceThumbnail({required this.bytes, required this.onRemove});

  final Uint8List bytes;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    // Stack: menumpuk gambar dan tombol X (Positioned menaruh X di pojok kanan atas).
    return SizedBox.square(
      dimension: 76,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            // ClipRRect: potong gambar dengan sudut membulat.
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // Image.memory: menampilkan gambar dari data byte di memori.
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: Material(
              color: AppColors.surfaceRaised,
              shape: const CircleBorder(
                side: BorderSide(color: AppColors.border),
              ),
              // InkWell: tombol X bisa ditekan, memanggil onRemove untuk menghapus referensi.
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded, size: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
