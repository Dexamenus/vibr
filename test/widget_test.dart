import 'package:flutter_test/flutter_test.dart';
import 'package:vibr/main.dart'; // Sesuaikan dengan nama package Anda di pubspec.yaml

void main() {
  testWidgets('Uji coba render halaman Profil dan navigasi di MainScreen', (WidgetTester tester) async {
    // Bangun aplikasi dan picu frame pertama.
    await tester.pumpWidget(const MyApp());

    // Tunggu semua animasi rendering selesai (karena kita set index ke 4, Profil akan muncul pertama)
    await tester.pumpAndSettle();

    // 1. Verifikasi elemen-elemen di Halaman Profil muncul
    expect(find.text('Profil'), findsWidgets); // Header 'Profil' atau label 'Profile' di bottom nav
    expect(find.text('Zahira'), findsOneWidget); // Nama pengguna
    expect(find.text('zahira@example.com'), findsOneWidget); // Email pengguna
    expect(find.text('Konfigurasi AI'), findsOneWidget); // Salah satu menu
    expect(find.text('KELUAR'), findsOneWidget); // Tombol Logout

    // 2. Uji coba navigasi ke tab 'Home'
    // 'Home' adalah label dari AppBottomNavigation untuk indeks ke-0
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // 3. Verifikasi bahwa halaman berpindah
    // Nama 'Zahira' seharusnya sudah tidak ada di layar karena kita berada di tab Home
    expect(find.text('Zahira'), findsNothing);
    
    // Teks placeholder halaman Home seharusnya muncul
    expect(find.text('Halaman Beranda'), findsOneWidget);
  });
}