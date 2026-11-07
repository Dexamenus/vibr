import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../../shared/widgets/selectable_pill.dart';

class AiConfigurationScreen extends StatefulWidget {
  const AiConfigurationScreen({super.key});

  @override
  State<AiConfigurationScreen> createState() => _AiConfigurationScreenState();
}

class _AiConfigurationScreenState extends State<AiConfigurationScreen> {
  // State untuk menyimpan pilihan saat ini
  String _selectedTone = 'Santai';
  String _selectedStyle = 'Ilustrasi';

  final List<String> _tones = ['Santai', 'Profesional', 'Ramah'];
  final List<String> _styles = ['Ilustrasi', 'Foto', 'Minimalis'];

  void _handleModelSelection(String modelType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pilihan $modelType belum tersedia di versi demo'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  void _handleSavePreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preferensi Konfigurasi AI berhasil disimpan:\n$_selectedTone & $_selectedStyle'),
        backgroundColor: AppColors.teal,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Konfigurasi AI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                const Text(
                  'Pilih model dan pengaturan bawaan kreatif yang digunakan untuk konten Anda.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Bagian Model AI
                const Text(
                  'Model AI',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildModelItem(
                        icon: Icons.smart_toy_outlined,
                        title: 'Model LLM',
                        value: 'GPT-4o mini',
                        onTap: () => _handleModelSelection('Model LLM'),
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.5),
                        indent: 16,
                        endIndent: 16,
                      ),
                      _buildModelItem(
                        icon: Icons.image_outlined,
                        title: 'Model Gambar',
                        value: 'FLUX Schnell',
                        onTap: () => _handleModelSelection('Model Gambar'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Bagian Nada & Gaya Bawaan
                const Text(
                  'Nada & gaya bawaan',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SurfaceCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nada penulisan',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _tones.map((tone) {
                          return SelectablePill(
                            label: tone,
                            selected: _selectedTone == tone,
                            onTap: () {
                              setState(() {
                                _selectedTone = tone;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      
                      const Text(
                        'Gaya visual',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _styles.map((style) {
                          return SelectablePill(
                            label: style,
                            selected: _selectedStyle == style,
                            onTap: () {
                              setState(() {
                                _selectedStyle = style;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Helper Text Dinamis
                Text(
                  '$_selectedTone · $_selectedStyle adalah bawaan Anda saat ini. Anda dapat menyesuaikannya untuk setiap pembuatan konten baru.',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Tombol Simpan Preferensi
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleSavePreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan preferensi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.muted, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}