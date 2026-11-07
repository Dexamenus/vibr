import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../../shared/widgets/metric_card.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/status_pill.dart';
import '../../shared/widgets/surface_card.dart';
import '../../shared/widgets/top_toast.dart';
import '../canva/canva_connection.dart';
import '../canva/canva_flow.dart';
import '../create/create_with_ai_screen.dart';

// HomeScreen = halaman Beranda. Pakai StatefulWidget karena menyimpan objek yang
// hidup selama halaman ada (CanvaConnection) dan perlu dibuang di dispose().
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onNavigationSelected,
    this.onOpenSchedule,
    this.showBottomNavigation = true,
  });

  final ValueChanged<int>? onNavigationSelected;
  final VoidCallback? onOpenSchedule;
  final bool showBottomNavigation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const: nilainya tetap dan sudah pasti sejak kompilasi (nama dummy).
  static const _userName = 'Mirulesss';

  // final: diisi sekali saat halaman dibuat. Menyimpan status koneksi Canva.
  final _canva = CanvaConnection();

  // dispose(): dipanggil saat halaman ditutup, objek _canva dibuang supaya tidak boros memori.
  @override
  void dispose() {
    _canva.dispose();
    super.dispose();
  }

  // Navigator.push: membuka halaman baru (form buat gambar). MaterialPageRoute = animasi pindah halaman.
  void _openAiImage() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const CreateWithAiScreen()));

  // Menampilkan toast singkat di atas layar untuk fitur yang belum tersedia.
  void _comingSoon() => showTopToast(
    context,
    message: 'Fitur ini segera hadir ya!',
    icon: Icons.hourglass_top_rounded,
    iconColor: AppColors.amber,
  );

  // Dipanggil saat item navigasi bawah ditekan. index 0 = Beranda (halaman ini).
  void _onNavSelected(int index) {
    if (index == 0) return;
    if (index == 1 && widget.onOpenSchedule != null) {
      widget.onOpenSchedule!();
      return;
    }
    // Jadwal, Buat (nanti buat jadwal), Insight, dan Profil belum tersedia.
    _comingSoon();
  }

  // build(): menyusun tampilan halaman dari widget. Dipanggil ulang kalau ada perubahan.
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Scaffold: kerangka halaman (body = isi, bottomNavigationBar = menu bawah).
    return Scaffold(
      // SafeArea: supaya isi tidak tertutup notch / status bar.
      body: SafeArea(
        // Align(topCenter): isi menempel di atas. Tanpa ini isi ter-center secara vertikal.
        child: Align(
          alignment: Alignment.topCenter,
          // ConstrainedBox: batasi lebar maksimal 620 supaya tetap rapi di layar lebar / web.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            // SingleChildScrollView: isi bisa di-scroll kalau lebih tinggi dari layar.
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              // Column: menyusun widget dari atas ke bawah.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sapaan + tanggal + avatar (widget buatan sendiri, ada di bawah file ini).
                  _Header(name: _userName, now: now),
                  const SizedBox(height: 20),
                  // IntrinsicHeight + Row(stretch): tiga kartu angka dibuat sama tinggi.
                  const IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // MetricCard: kartu angka ringkas (widget buatan sendiri di shared/widgets).
                        // Lebar dibagi rata oleh Expanded di dalam MetricCard.
                        MetricCard(
                          value: '12',
                          label: 'Postingan terjadwal',
                          icon: Icons.calendar_today_outlined,
                        ),
                        SizedBox(width: 10),
                        MetricCard(
                          value: '+8.3%',
                          label: 'Tingkat engagement',
                          icon: Icons.calendar_today_outlined,
                          tint: AppColors.teal,
                        ),
                        SizedBox(width: 10),
                        MetricCard(
                          value: '24',
                          label: 'Komentar baru',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  // SectionHeading: judul bagian + tombol teks 'Lihat semua'.
                  SectionHeading(
                    title: 'Jadwal Hari Ini',
                    actionLabel: 'Lihat semua',
                    onAction: widget.onOpenSchedule ?? _comingSoon,
                  ),
                  // Kartu jadwal (data dummy). Dibuat sebagai widget terpisah supaya kode tidak diulang.
                  const _ScheduleCard(
                    platform: 'Instagram',
                    platformIcon: Icons.camera_alt_outlined,
                    caption: 'Siapin ruang buat ide-ide segar ✦',
                    meta: '10:30 · Feed post',
                  ),
                  const SizedBox(height: 12),
                  const _ScheduleCard(
                    platform: 'Facebook',
                    platformIcon: Icons.facebook_rounded,
                    caption: 'Intip dikit di balik layar desainnya.',
                    meta: '14:00 · Page post',
                  ),
                  const SizedBox(height: 26),
                  // Bagian Alat: tiga tombol pintasan fitur.
                  const SectionHeading(title: 'Alat'),
                  // Row: tombol alat disusun ke samping. _ToolButton = ikon + label yang bisa ditekan.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ToolButton(
                        icon: const Icon(Icons.image_outlined, size: 24),
                        label: 'Buat Gambar',
                        onTap: _openAiImage,
                      ),
                      const SizedBox(width: 12),
                      _ToolButton(
                        icon: Image.asset(
                          'assets/img/canva_logo.png',
                          width: 28,
                          height: 28,
                          filterQuality: FilterQuality.high,
                        ),
                        label: 'Canva',
                        // Canva: cek koneksi dulu (popup status / hubungkan). Kalau sudah terhubung, buka form Canva.
                        onTap: () => openCanva(context, _canva),
                      ),
                      const SizedBox(width: 12),
                      _ToolButton(
                        icon: const Icon(Icons.layers_clear_outlined, size: 24),
                        label: 'Hapus BG',
                        onTap: _comingSoon,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Menu navigasi bawah (NavigationBar). selectedIndex 0 = tab Beranda aktif.
      bottomNavigationBar: widget.showBottomNavigation
          ? AppBottomNavigation(
              selectedIndex: 0,
              onSelected: widget.onNavigationSelected ?? _onNavSelected,
            )
          : null,
    );
  }
}

// StatelessWidget: tampilan tetap, tidak menyimpan state sendiri.
// Isinya dikirim lewat parameter (name, now).
class _Header extends StatelessWidget {
  const _Header({required this.name, required this.now});

  final String name;
  final DateTime now;

  // List: daftar nama hari dan bulan, dipakai untuk memformat tanggal.
  static const _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  static const _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // getter: dihitung dari jam sekarang, jadi sapaan berubah otomatis (pagi / siang / sore / malam).
  String get _greeting {
    final hour = now.hour;
    if (hour < 11) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  // Menyusun tanggal bahasa Indonesia dari list _days dan _months.
  String get _date =>
      '${_days[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]} '
      '${now.year}';

  @override
  Widget build(BuildContext context) {
    // Ambil maksimal 3 huruf pertama nama untuk avatar (ternary: kondisi ? ya : tidak).
    final initials = name.length > 3 ? name.substring(0, 3) : name;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting,\n$name',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(_date, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // CircleAvatar: lingkaran avatar berisi inisial nama.
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.surfaceRaised,
          child: Text(
            initials,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// Kartu satu jadwal posting: platform, status, caption, dan jam.
class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.platform,
    required this.platformIcon,
    required this.caption,
    required this.meta,
  });

  final String platform;
  final IconData platformIcon;
  final String caption;
  final String meta;

  @override
  Widget build(BuildContext context) {
    // SurfaceCard: kartu dasar (latar + border + bayangan tipis).
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(platformIcon, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        platform,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // StatusPill: chip kecil penanda status ('Terjadwal').
                    const StatusPill(
                      label: 'Terjadwal',
                      color: AppColors.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  caption,
                  // maxLines 1 + ellipsis: caption yang kepanjangan dipotong jadi '...'.
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tombol alat: kotak ikon + label. Ikon dikirim sebagai Widget supaya bisa Icon atau Image.
class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // InkWell: membuat area bisa ditekan, dengan efek riak.
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      // SizedBox: kotak lebar tetap 76 supaya ketiga alat sejajar.
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            // Container: kotak ikon dengan warna, border, dan sudut membulat (BoxDecoration).
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: icon,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
