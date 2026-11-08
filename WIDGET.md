# Widget Vibr (untuk penilaian Mobile Programming)


Cara menjawab: **nama widget -> fungsinya -> dipakai di mana di app -> tunjukkan file:baris**.


## A. Kerangka aplikasi

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **MaterialApp** | Widget akar app bergaya Material. Mengatur judul, tema, dan halaman awal. | Dipasang di `VibrApp`: `theme: AppTheme.dark`, `home: HomeScreen()`. | `main.dart:25` |
| **Scaffold** | Kerangka dasar satu halaman (body, appBar, bottomNavigationBar, dst). | Dipakai di Home, form Buat, dan Hasil. Home memakai `bottomNavigationBar`. | `features/home/home_screen.dart:52` |
| **SafeArea** | Menjaga isi tidak tertutup notch, status bar, atau gesture bar. | Membungkus body tiap layar. | `features/home/home_screen.dart:53` |
| **ThemeData / Theme.of** | Menentukan gaya global (warna, font, bentuk komponen) di satu tempat. `Theme.of(context)` mengambilnya. | `AppTheme.dark` dan `AppColors` di `app_theme.dart`; Home membaca `textTheme`. | `core/theme/app_theme.dart:26` |
| **SystemChrome** | Mengatur tampilan sistem (warna status bar dan navigation bar). | Dipanggil di `main()` sebelum `runApp`. | `main.dart:9` |

## B. Layout (menyusun posisi)

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **Column** | Menyusun anak **vertikal** (atas ke bawah). | Isi hampir semua layar: header, form, daftar kartu. | `features/home/home_screen.dart:60` |
| **Row** | Menyusun anak **horizontal**. | Tiga kartu angka, baris tombol bawah, header dialog. | `features/home/home_screen.dart:66` |
| **Expanded** | Membuat anak mengisi sisa ruang di Row/Column. | Teks judul dan tombol agar membagi lebar sama rata. | `features/home/home_screen.dart:200` |
| **Flexible** | Seperti Expanded tapi anak boleh lebih kecil dari ruang yang tersedia. | Dialog Canva: area isi bisa menyusut dan scroll. | `features/canva/canva_dialog_shell.dart:112` |
| **Stack + Positioned** | Menumpuk widget; `Positioned` menaruh anak di posisi tertentu. | Thumbnail referensi + tombol X di pojok kanan atas. | `features/create/creation_form.dart:189` |
| **Center / Align** | `Center` menaruh di tengah; `Align` di posisi tertentu. | Home: `Align(topCenter)` agar konten mulai dari atas, bukan di tengah layar. | `features/home/home_screen.dart:54` |
| **Padding** | Memberi jarak di dalam widget. | Jarak tepi layar dan isi kartu. | `features/create/create_with_ai_screen.dart:68` |
| **SizedBox** | Kotak berukuran tetap; sering dipakai sebagai **spasi** antar widget. | Ada 78 pemakaian, misalnya `SizedBox(height: 14)`. | `features/home/home_screen.dart:64` |
| **ConstrainedBox** | Membatasi ukuran minimum/maksimum anak. | `maxWidth: 620` agar tampilan tetap rapi di layar lebar/web. | `features/home/home_screen.dart:56` |
| **Container** | Kotak serbaguna: ukuran, padding, warna, dekorasi. | Kotak ikon alat, chip status, panel dialog. | `features/canva/canva_status_dialog.dart:53` |
| **DecoratedBox** | Memberi dekorasi (warna, border, radius) tanpa padding. | Latar panel dialog dan kartu. | `features/canva/canva_dialog_shell.dart:88` |
| **Wrap** | Menyusun anak berderet dan **turun baris otomatis** jika tidak muat. | Deretan pill pilihan (Model, Gaya, Rasio) dan thumbnail referensi. | `shared/widgets/option_group.dart:47` |
| **SingleChildScrollView** | Membuat konten bisa di-**scroll** jika lebih tinggi dari layar. | Halaman Home, form, dan hasil. | `features/home/home_screen.dart:58` |
| **IntrinsicHeight** | Menyamakan tinggi anak-anak dalam Row. | Tiga kartu angka di Home supaya sama tinggi. | `features/home/home_screen.dart:65` |
| **FittedBox** | Mengecilkan anak agar muat di ruang yang ada. | Teks tombol 'Periksa lagi' dan 'Lanjutkan ke Canva' agar tidak terpecah. | `features/canva/canva_status_dialog.dart:102` |
| **AspectRatio** | Menjaga perbandingan lebar:tinggi. | Preview gambar sesuai rasio pilihan (1:1, 4:5, 9:16, dst). | `features/create/creation_result_screen.dart:110` |
| **LayoutBuilder** | Membangun anak berdasarkan ukuran ruang yang tersedia. | Mengambil tinggi preview untuk `GeneratedArtwork`. | `features/create/creation_result_screen.dart:115` |
| **ClipRRect** | Memotong anak dengan sudut membulat. | Sudut membulat pada thumbnail dan dialog. | `features/create/creation_form.dart:193` |
| **Divider** | Garis pemisah tipis. | Pemisah di dialog Canva. | `features/canva/canva_dialog_shell.dart:187` |

## C. Tampilan (yang terlihat)

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **Text** | Menampilkan teks. `TextStyle` mengatur ukuran, warna, ketebalan. | Judul, label, pesan error, isi tombol. | `features/home/home_screen.dart:204` |
| **Icon** | Menampilkan ikon dari `Icons`. | Ikon alat, navigasi, tombol back/close. | `features/home/home_screen.dart:115` |
| **Image.asset** | Menampilkan gambar dari folder `assets` (didaftarkan di `pubspec.yaml`). | Logo Canva di Alat dan dialog. | `features/home/home_screen.dart:121` |
| **Image.memory** | Menampilkan gambar dari data byte di memori. | Thumbnail gambar referensi hasil pilih galeri. | `features/create/creation_form.dart:195` |
| **CircleAvatar** | Lingkaran untuk avatar/inisial. | Avatar 'Mir' di Home dan titik status. | `features/home/home_screen.dart:214` |
| **CustomPaint** | Melukis sendiri lewat kode (Canvas). | `GeneratedArtwork`: gambar planet ungu sebagai hasil sementara. | `shared/widgets/generated_artwork.dart:18` |
| **CircularProgressIndicator** | Indikator putar tanda sedang memproses. | Tombol 'Periksa lagi' dan 'Lanjutkan ke Canva' saat loading. | `features/canva/canva_status_dialog.dart:222` |

## D. Tombol, input, dan interaksi

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **FilledButton** | Tombol solid berwarna. | 'Bikin Ulang', 'Download', 'Hubungkan Canva'. | `features/create/creation_result_screen.dart:235` |
| **FilledButton.icon** | Tombol solid dengan ikon. | `PrimaryButton` (tombol Buat gambar). | `shared/widgets/primary_button.dart:25` |
| **OutlinedButton** | Tombol dengan garis tepi. | 'Periksa lagi'; `.icon` untuk 'Tambah gambar / referensi'. | `features/canva/canva_status_dialog.dart:208` |
| **TextButton** | Tombol teks tanpa latar. | 'Lihat semua' di `SectionHeading`. | `shared/widgets/section_heading.dart:36` |
| **IconButton** | Tombol berbentuk ikon. | Tombol Kembali dan Tutup di `CreationHeader`. | `shared/widgets/creation_header.dart:20` |
| **InkWell** | Membuat area **bisa disentuh** dengan efek riak. | Kotak alat (Buat Gambar, Canva), tombol X thumbnail. | `features/home/home_screen.dart:303` |
| **GestureDetector** | Mendeteksi sentuhan tanpa efek visual. | Menutup toast dengan sekali sentuh. | `shared/widgets/top_toast.dart:107` |
| **TextField** | Kolom input teks. `InputDecoration` mengatur hint dan pesan error; `TextEditingController` menyimpan isinya. | Kolom 'Prompt kamu' dengan validasi wajib isi. | `features/create/creation_form.dart:75` |
| **ChoiceChip** | Chip pilihan tunggal (terpilih/tidak). | `SelectablePill` untuk Model, Gaya, Rotasi, Rasio. | `shared/widgets/selectable_pill.dart:21` |
| **NavigationBar** | Bilah navigasi bawah; item dibuat dengan `NavigationDestination`. | Beranda, Jadwal, Buat, Insight, Profil. | `shared/widgets/app_bottom_navigation.dart:17` |

## E. Dialog dan pesan

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **showDialog + AlertDialog** | `showDialog` memunculkan popup; `AlertDialog` adalah isinya. | Popup 'Batas referensi tercapai'. | `shared/widgets/info_dialog.dart:16` |
| **Dialog** | Kerangka popup bebas (isi dan bentuk diatur sendiri). | Dasar dua popup Canva (`CanvaDialogShell`). | `features/canva/canva_dialog_shell.dart:80` |
| **SnackBar + ScaffoldMessenger** | Pesan singkat di bawah layar yang hilang sendiri. | Dipakai untuk pesan 'galeri tidak bisa dibuka'. | `shared/widgets/show_demo_message.dart:5` |
| **Overlay + OverlayEntry** | Lapisan di atas semua halaman untuk menampilkan widget sementara. | Toast di atas layar (`showTopToast`) yang hilang setelah 3 detik. | `shared/widgets/top_toast.dart:21` |

## F. Animasi

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **AnimationController** | Pengendali waktu animasi (mulai, ulang, balik). | Efek shimmer saat loading dan gerak toast. | `features/create/creation_result_screen.dart:262` |
| **AnimatedBuilder** | Membangun ulang widget setiap frame animasi. | Menggeser kilau di kartu loading. | `features/create/creation_result_screen.dart:286` |
| **AnimatedSwitcher** | Transisi halus saat anak diganti. | Kartu loading berganti ke gambar hasil. | `features/create/creation_result_screen.dart:112` |
| **FadeTransition / SlideTransition** | Animasi memudar dan menggeser memakai `Tween`/`CurvedAnimation`. | Toast muncul dari atas lalu menghilang. | `shared/widgets/top_toast.dart:100` |

## G. Navigasi

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **Navigator + MaterialPageRoute** | `push` membuka halaman baru, `pop` kembali, `popUntil` kembali ke halaman tertentu. | Home ke form, form ke hasil; dialog mengembalikan nilai lewat `pop(true/false)`. | `features/create/create_with_ai_screen.dart:30` |

## H. State dan data

| Widget | Fungsi | Dipakai di app | Lokasi |
|---|---|---|---|
| **StatefulWidget + setState** | Widget yang tampilannya bisa berubah; `setState` memicu gambar ulang. | Status loading ke hasil di layar Hasil; spinner tombol di dialog. | `features/create/creation_result_screen.dart:56` |
| **ChangeNotifier + ListenableBuilder** | Objek penyimpan state yang memberi tahu pendengarnya saat berubah; `ListenableBuilder` menggambar ulang otomatis. | `CreationFormController` dibagi ke layar Buat dan Hasil. | `features/create/creation_form.dart:66` |
| **TextEditingController** | Membaca dan mengatur isi TextField. | Menyimpan prompt dan dipakai validasi. | `features/create/creation_form_controller.dart:20` |
| **Timer** | Menjalankan kode setelah jeda waktu. | Simulasi generate gambar 3 detik. | `features/create/creation_result_screen.dart:57` |
| **Future / async / await** | Menjalankan proses yang butuh waktu tanpa membekukan UI. | Cek koneksi Canva dan memilih gambar dari galeri. | `features/canva/canva_connection.dart:11` |
| **ImagePicker (paket image_picker)** | Paket untuk memilih gambar dari galeri/kamera. | Tombol 'Tambah gambar / referensi' (maks. 4 gambar). | `features/create/creation_form.dart:19` |

## I. Widget buatan sendiri (custom widget)

Bisa dijelaskan sebagai: widget yang dibuat sendiri supaya kode tidak berulang (reusable).

| Nama | File | Fungsi |
|---|---|---|
| **VibrApp** | `main.dart` | Akar app: `MaterialApp` + tema + halaman awal. |
| **HomeScreen** | `features/home/home_screen.dart` | Halaman Beranda: sapaan, kartu angka, jadwal, Alat, navigasi bawah. |
| **CreateWithAiScreen** | `features/create/create_with_ai_screen.dart` | Layar form buat gambar. Satu layar untuk dua mode (AI dan Canva). |
| **CreationResultScreen** | `features/create/creation_result_screen.dart` | Layar hasil: loading, gambar, form untuk bikin ulang. |
| **CreationForm** | `features/create/creation_form.dart` | Form prompt, pilihan, dan referensi; dipakai dua layar. |
| **CreationFormController** | `features/create/creation_form_controller.dart` | Penyimpan state form (ChangeNotifier) + validasi. |
| **OptionGroup / SectionLabel** | `shared/widgets/option_group.dart` | Label + deretan pill pilihan; dipakai 5 kali. |
| **SelectablePill** | `shared/widgets/selectable_pill.dart` | Pill pilihan berbasis `ChoiceChip`. |
| **CreationHeader** | `shared/widgets/creation_header.dart` | Header: panah kembali, judul, tombol tutup. |
| **PrimaryButton** | `shared/widgets/primary_button.dart` | Tombol utama berwarna ungu dengan ikon. |
| **MetricCard** | `shared/widgets/metric_card.dart` | Kartu angka di Home. |
| **SurfaceCard** | `shared/widgets/surface_card.dart` | Kartu dasar bergradasi tipis. |
| **SectionHeading** | `shared/widgets/section_heading.dart` | Judul bagian + tautan aksi ('Lihat semua'). |
| **StatusPill** | `shared/widgets/status_pill.dart` | Chip status ('Terjadwal'). |
| **AppBottomNavigation** | `shared/widgets/app_bottom_navigation.dart` | Navigasi bawah 5 tab. |
| **GeneratedArtwork** | `shared/widgets/generated_artwork.dart` | Gambar placeholder hasil (dilukis dengan `CustomPaint`). |
| **showTopToast** | `shared/widgets/top_toast.dart` | Fungsi pesan singkat di atas layar. |
| **showInfoDialog** | `shared/widgets/info_dialog.dart` | Fungsi popup sederhana (ikon, judul, pesan, tombol). |
| **CanvaConnection** | `features/canva/canva_connection.dart` | State koneksi Canva (ChangeNotifier), simulasi. |
| **CanvaStatusDialog / CanvaConnectDialog** | `features/canva/` | Dua popup koneksi Canva. |
| **CanvaDialogShell / CanvaLogo** | `features/canva/canva_dialog_shell.dart` | Kerangka bersama popup Canva + logo. |

## J. Widget yang filenya ada tetapi TIDAK dipakai di layar mana pun

Sisa dari kerangka awal. Jangan disebut sebagai widget yang dipakai; kalau ditanya, jawab jujur bahwa ini belum dipakai atau hapus sebelum presentasi.

- **AppPage** (`shared/widgets/app_page.dart`)
- **ScreenHeader** (`shared/widgets/screen_header.dart (hanya dipakai AppPage)`)
- **AppTextField** (`shared/widgets/app_text_field.dart`)
- **AppIconButton** (`shared/widgets/app_icon_button.dart`)
- **SecondaryButton** (`shared/widgets/secondary_button.dart`)
- **EmptyState** (`shared/widgets/empty_state.dart`)
- **BrandLogo** (`shared/widgets/brand_logo.dart`)
- **SocialPlatformIcon** (`shared/widgets/social_platform_icon.dart`)
