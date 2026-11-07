import 'package:flutter/material.dart';

import '../../shared/widgets/creation_header.dart';
import '../../shared/widgets/primary_button.dart';
import 'creation_form.dart';
import 'creation_mode.dart';
import 'creation_form_controller.dart';
import 'creation_result_screen.dart';

// Layar form buat gambar. Dipakai dua mode: AI dan Canva (parameter mode).
class CreateWithAiScreen extends StatefulWidget {
  const CreateWithAiScreen({super.key, this.mode = CreationMode.ai});

  final CreationMode mode;

  @override
  State<CreateWithAiScreen> createState() => _CreateWithAiScreenState();
}

class _CreateWithAiScreenState extends State<CreateWithAiScreen> {
  // Objek penyimpan isi form (prompt, pilihan, referensi).
  // Dikirim juga ke layar hasil supaya isinya ikut terbawa.
  final _form = CreationFormController();

  // dispose(): bebaskan controller saat layar ditutup supaya tidak bocor memori.
  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  // Dipanggil saat tombol Buat gambar ditekan. Prompt kosong = berhenti (validasi),
  // kalau sudah terisi pindah ke layar hasil.
  void _generate() {
    if (!_form.validatePrompt()) return;
    // push: tumpuk halaman baru di atas halaman ini (tombol kembali akan balik ke sini).
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CreationResultScreen(controller: _form, mode: widget.mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman. Form di atas (bisa di-scroll), tombol Buat gambar menempel di bawah.
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            // Column luar: area isi (Expanded) di atas + tombol tetap di bawah.
            child: Column(
              children: [
                // Expanded: area isi mengambil semua sisa tinggi layar di atas tombol.
                Expanded(
                  // SingleChildScrollView: form bisa di-scroll kalau layar kecil.
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header buatan sendiri: tombol kembali, judul, dan tombol tutup.
                        CreationHeader(
                          title: widget.mode.createTitle,
                          onBack: () => Navigator.of(context).maybePop(),
                          onClose: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(height: 14),
                        const SizedBox(height: 22),
                        // Form bersama (prompt, pilihan, referensi). showModel false untuk mode Canva.
                        CreationForm(
                          controller: _form,
                          showModel: widget.mode.showsModel,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol utama. onPressed memanggil _generate.
                      PrimaryButton(
                        label: 'Buat gambar',
                        icon: Icons.auto_awesome_outlined,
                        onPressed: _generate,
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
