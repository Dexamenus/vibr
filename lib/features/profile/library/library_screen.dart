import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/selectable_pill.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  
  final List<String> _filters = ['Semua', 'Buat Gambar', 'Hapus BG', 'Buat Canva'];

  // Data mockup untuk kreasi
  final List<Map<String, dynamic>> _allCreations = [
    {
      'title': 'Pelarian pesisir',
      'type': 'Buat Gambar',
      'date': 'Hari ini',
      'icon': Icons.auto_awesome,
      'color1': const Color(0xFF6A85B6),
      'color2': const Color(0xFFBAC8E0),
    },
    {
      'title': 'Sneaker sehari-hari',
      'type': 'Hapus BG',
      'date': 'Hari ini',
      'icon': Icons.content_cut_rounded,
      'color1': const Color(0xFFD4C8EC),
      'color2': const Color(0xFFF3F0F8),
    },
    {
      'title': 'Seduhan akhir pekan',
      'type': 'Buat Canva',
      'date': 'Hari ini',
      'icon': Icons.web_rounded,
      'color1': const Color(0xFFD7C7B5),
      'color2': const Color(0xFFF2EBE3),
    },
    {
      'title': 'Mekar lembut',
      'type': 'Buat Gambar',
      'date': 'Hari ini',
      'icon': Icons.auto_awesome,
      'color1': const Color(0xFFC8A2C8),
      'color2': const Color(0xFFE6D7E6),
    },
    {
      'title': 'Kebutuhan harian',
      'type': 'Hapus BG',
      'date': 'Kemarin',
      'icon': Icons.content_cut_rounded,
      'color1': const Color(0xFFB5C9C3),
      'color2': const Color(0xFFE2EBE8),
    },
    {
      'title': 'Awal yang segar',
      'type': 'Buat Canva',
      'date': 'Kemarin',
      'icon': Icons.web_rounded,
      'color1': const Color(0xFFD5D8B4),
      'color2': const Color(0xFFEFF0D9),
    },
  ];

  // Mendapatkan kreasi yang sudah difilter berdasarkan pencarian dan kategori
  List<Map<String, dynamic>> get _filteredCreations {
    return _allCreations.where((creation) {
      final matchesSearch = creation['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Semua' || creation['type'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _handleSelectAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mode pilihan diaktifkan'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  void _handleItemTap(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka kreasi: $title'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _handleDownload(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengunduh $title...'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  void _handleMoreOptions(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka opsi untuk $title'),
        backgroundColor: AppColors.surfaceRaised,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCreations;
    final todayCreations = filtered.where((c) => c['date'] == 'Hari ini').toList();
    final yesterdayCreations = filtered.where((c) => c['date'] == 'Kemarin').toList();

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
          'Pustaka',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleSelectAction,
            child: const Text(
              'Pilih',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_allCreations.length} kreasi tersimpan · Semua di satu tempat',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kolom Pencarian
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Cari kreasi Anda',
                      hintStyle: const TextStyle(color: AppColors.muted),
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.surfaceRaised,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Filter Horizontal (Semua, Buat Gambar, dll)
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: _filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SelectablePill(
                      label: filter,
                      selected: _selectedFilter == filter,
                      onTap: () => setState(() => _selectedFilter = filter),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Seksi Hari Ini
          if (todayCreations.isNotEmpty) ...[
            _buildSectionHeader('Hari ini', todayCreations.length, showSort: true),
            _buildGrid(todayCreations),
          ],

          // Seksi Kemarin
          if (yesterdayCreations.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _buildSectionHeader('Kemarin', yesterdayCreations.length),
            _buildGrid(yesterdayCreations),
          ],

          // Pesan jika hasil pencarian/filter kosong
          if (filtered.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    'Tidak ada kreasi yang ditemukan.',
                    style: TextStyle(color: AppColors.muted, fontSize: 15),
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, {bool showSort = false}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count item',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            if (showSort)
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menu urutkan dibuka')),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Terbaru',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.sort_rounded, color: AppColors.muted, size: 16),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<dynamic> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () => _handleItemTap(item['title']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Area Thumbnail Kreasi
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [item['color1'], item['color2']],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Placeholder gambar tengah
                          Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                          
                          // Kumpulan ikon di sisi kanan bawah
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol Opsi (Titik Tiga)
                                InkWell(
                                  onTap: () => _handleMoreOptions(item['title']),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                
                                // Tombol Unduh
                                InkWell(
                                  onTap: () => _handleDownload(item['title']),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.file_download_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                
                                // Ikon Tipe Kreasi
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceRaised.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    item['icon'],
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Info Teks (Judul dan Tipe)
                  Text(
                    item['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['type'],
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}