import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../../shared/widgets/selectable_pill.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String _selectedTheme = 'Gelap';
  String _selectedAccent = 'Ungu';

  final Map<String, Color> _accentColors = {
    'Ungu': AppColors.accent,
    'Biru': const Color(0xFF6495ED), // Cornflower Blue
    'Mint': AppColors.teal,
    'Merah Muda': const Color(0xFFE5A4B4), // Pinkish
  };

  void _handleThemeChange(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
  }

  void _handleAccentChange(String accent) {
    setState(() {
      _selectedAccent = accent;
    });
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
          'Tampilan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          const Text(
            'Jadikan ruang kerja Anda terasa seperti milik sendiri.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Bagian Tema
          const Text(
            'Tema',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildThemeOption('Gelap', _buildDarkMockup()),
              _buildThemeOption('Terang', _buildLightMockup()),
              _buildThemeOption('Sistem', _buildSystemMockup()),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$_selectedTheme dipilih. Sistem mengikuti tampilan perangkat Anda.',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Bagian Warna Aksen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Warna aksen',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
              Text(
                '$_selectedAccent dipilih',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _accentColors.entries.map((entry) {
                return _buildColorOption(entry.key, entry.value);
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),

          // Bagian Pratinjau
          const Text(
            'Pratinjau',
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
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: _accentColors[_selectedAccent],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Ruang kerja kreatif Anda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _getPreviewDescription(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tema ${_selectedTheme.toLowerCase()} · Aksen ${_selectedAccent.toLowerCase()}',
                  style: TextStyle(
                    color: _accentColors[_selectedAccent]!.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Teks dinamis untuk pratinjau
  String _getPreviewDescription() {
    String themeText = _selectedTheme == 'Gelap' 
        ? 'Kanvas gelap yang tenang' 
        : _selectedTheme == 'Terang' 
            ? 'Kanvas terang yang bersih' 
            : 'Kanvas dinamis yang menyesuaikan perangkat';
    
    return '$themeText dengan sorotan ${_selectedAccent.toLowerCase()} untuk menjaga konten Anda tetap fokus.';
  }

  // Widget untuk Opsi Tema
  Widget _buildThemeOption(String title, Widget mockup) {
    final isSelected = _selectedTheme == title;
    return GestureDetector(
      onTap: () => _handleThemeChange(title),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? _accentColors[_selectedAccent]! : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: mockup,
            ),
          ),
          const SizedBox(height: 12),
          SelectablePill(
            label: title,
            selected: isSelected,
            onTap: () => _handleThemeChange(title),
          ),
        ],
      ),
    );
  }

  // Widget untuk Opsi Warna Aksen
  Widget _buildColorOption(String name, Color color) {
    final isSelected = _selectedAccent == name;
    return GestureDetector(
      onTap: () => _handleAccentChange(name),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.muted,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Mockup Tampilan Gelap
  Widget _buildDarkMockup() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 16, height: 16, decoration: const BoxDecoration(color: Color(0xFF2C2C2C), shape: BoxShape.circle)),
          const SizedBox(height: 8),
          Container(width: 40, height: 4, color: const Color(0xFF424242)),
          const SizedBox(height: 12),
          Container(width: double.infinity, height: 20, decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(4))),
          const Spacer(),
          Container(width: 24, height: 4, color: _accentColors[_selectedAccent]),
        ],
      ),
    );
  }

  // Mockup Tampilan Terang
  Widget _buildLightMockup() {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 16, height: 16, decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle)),
          const SizedBox(height: 8),
          Container(width: 40, height: 4, color: const Color(0xFFBDBDBD)),
          const SizedBox(height: 12),
          Container(width: double.infinity, height: 20, decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4))),
          const Spacer(),
          Container(width: 24, height: 4, color: const Color(0xFF9E9E9E)),
        ],
      ),
    );
  }

  // Mockup Tampilan Sistem (Setengah Gelap, Setengah Terang)
  Widget _buildSystemMockup() {
    return Row(
      children: [
        Expanded(child: _buildDarkMockup()),
        Expanded(child: _buildLightMockup()),
      ],
    );
  }
}