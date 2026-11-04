import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/profile_screen.dart';
import 'shared/widgets/app_bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SociAI', // Sesuai dengan nama brand di desain awal
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark, // Menggunakan tema gelap (Dark Theme) bawaan aplikasi
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Disetel ke indeks 4 agar aplikasi langsung membuka layar profil saat dijalankan
  int _selectedIndex = 4;

  // Daftar halaman untuk setiap tab di navigasi bawah
  final List<Widget> _screens = [
    const Center(child: Text('Halaman Beranda', style: TextStyle(color: Colors.white, fontSize: 18))),
    const Center(child: Text('Halaman Jadwal', style: TextStyle(color: Colors.white, fontSize: 18))),
    const Center(child: Text('Halaman Buat', style: TextStyle(color: Colors.white, fontSize: 18))),
    const Center(child: Text('Halaman Wawasan', style: TextStyle(color: Colors.white, fontSize: 18))),
    const ProfileScreen(), // Halaman Profil utama tempat semua pengaturan diakses
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Menampilkan halaman sesuai dengan tab yang dipilih
      body: _screens[_selectedIndex],
      // Menampilkan navigasi bawah custom
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}