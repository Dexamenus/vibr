import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibr/app.dart';

Future<void> _finishFirstLaunch(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  const headings = [
    'Buat konten menarik dengan AI',
    'Jadwalkan dan otomatisasi postingan',
    'Pahami audiensmu',
  ];
  for (var index = 0; index < headings.length; index++) {
    expect(find.text(headings[index]), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({'vibr.brand_setup_complete': true});
  });

  testWidgets('New users can register and complete brand setup', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('onboarding-screen')), findsOneWidget);
    await _finishFirstLaunch(tester);
    expect(find.text('Selamat datang kembali'), findsOneWidget);
    await tester.ensureVisible(find.text('Daftar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nama Merek');
    await tester.enterText(fields.at(1), 'nama@contoh.com');
    await tester.enterText(fields.at(2), 'kataSandi123');
    await tester.enterText(fields.at(3), 'kataSandiSalah');
    await tester.tap(find.byKey(const ValueKey('register-terms-checkbox')));
    await tester.tap(find.byKey(const ValueKey('register-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi kata sandi tidak cocok.'), findsOneWidget);
    await tester.enterText(fields.at(3), 'kataSandi123');
    await tester.enterText(fields.at(3), 'kataSandi123');
    await tester.tap(find.byKey(const ValueKey('register-submit')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('account-created-dialog')),
      findsOneWidget,
    );
    expect(find.text('Akun berhasil dibuat'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('account-created-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang kembali'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('login-email-field')),
      'nama@contoh.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password-field')),
      'kataSandi123',
    );
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Ceritakan tentang\nmerekmu'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey('instagram-brand-connect')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('instagram-brand-connect')));
    await tester.pumpAndSettle();

    expect(find.text('Status koneksi Instagram'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('instagram-status-connect')));
    await tester.pumpAndSettle();
    expect(find.text('Hubungkan Instagram'), findsOneWidget);
    expect(find.text('Pilih akun profesional'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('instagram-authorize-demo')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    expect(find.text('Terhubung · akun demo'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('vibr.instagram_demo_connected'), isTrue);
    await tester.tap(find.byKey(const ValueKey('dismiss-feedback-toast')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('facebook-brand-connect')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('facebook-brand-connect')));
    await tester.pumpAndSettle();
    expect(find.text('Status koneksi Facebook'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('facebook-status-connect')));
    await tester.pumpAndSettle();
    expect(find.text('Hubungkan Halaman Facebook'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('facebook-authorize-demo')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    expect(find.text('Terhubung · akun demo'), findsNWidgets(2));
    expect(preferences.getBool('vibr.facebook_demo_connected'), isTrue);
    await tester.tap(find.byKey(const ValueKey('dismiss-feedback-toast')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('brand-name-field')),
      'Merek Contoh',
    );
    await tester.tap(find.byKey(const ValueKey('brand-industry-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teknologi').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('brand-continue')));
    await tester.pumpAndSettle();

    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(
      SharedPreferences.getInstance().then(
        (preferences) => preferences.getBool('vibr.brand_setup_complete'),
      ),
      completion(isTrue),
    );

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koneksi'));
    await tester.pumpAndSettle();
    expect(find.text('@zahira.studio'), findsOneWidget);
    expect(find.text('Zahira Studio'), findsOneWidget);
    expect(find.text('Terhubung · Demo'), findsNWidgets(2));
  });

  testWidgets('Profile can connect and disconnect Facebook independently', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koneksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('connect-facebook-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Status koneksi Facebook'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('facebook-status-connect')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('facebook-authorize-demo')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('Zahira Studio'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('facebook-connection-card')),
        matching: find.text('Terhubung · Demo'),
      ),
      findsOneWidget,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('vibr.facebook_demo_connected'), isTrue);
    expect(
      preferences.getBool('vibr.instagram_demo_connected') ?? false,
      isFalse,
    );

    await tester.tap(find.byKey(const ValueKey('dismiss-feedback-toast')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('facebook-connection-card')),
        matching: find.text('Putuskan koneksi'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Putuskan Facebook?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm-facebook-disconnect')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('facebook-connection-card')),
        matching: find.text('Belum terhubung'),
      ),
      findsOneWidget,
    );
    expect(preferences.getBool('vibr.facebook_demo_connected'), isFalse);
    expect(
      preferences.getBool('vibr.instagram_demo_connected') ?? false,
      isFalse,
    );
  });

  testWidgets('Profile can connect Instagram through the demo steps', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koneksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('connect-instagram-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Status koneksi Instagram'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('instagram-status-connect')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('instagram-authorize-demo')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('@zahira.studio'), findsOneWidget);
    expect(find.text('Terhubung · Demo'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('vibr.instagram_demo_connected'), isTrue);

    await tester.tap(find.byKey(const ValueKey('dismiss-feedback-toast')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Putuskan koneksi'));
    await tester.pumpAndSettle();
    expect(find.text('Putuskan Instagram?'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('confirm-instagram-disconnect')),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('instagram-connection-card')),
        matching: find.text('Belum terhubung'),
      ),
      findsOneWidget,
    );
    expect(preferences.getBool('vibr.instagram_demo_connected'), isFalse);
  });

  testWidgets('Login without completed brand setup opens brand setup', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();
    await _finishFirstLaunch(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'nama@contoh.com');
    await tester.enterText(fields.at(1), 'kataSandi123');
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Ceritakan tentang\nmerekmu'), findsOneWidget);
  });

  testWidgets('Logout confirms, returns to login, and preserves brand setup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sign-out-button')));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari akun?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm-sign-out')));
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang kembali'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('vibr.signed_in'), isFalse);
    expect(preferences.getBool('vibr.brand_setup_complete'), isTrue);

    await tester.enterText(
      find.byKey(const ValueKey('login-email-field')),
      'nama@contoh.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password-field')),
      'kataSandi123',
    );
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(preferences.getBool('vibr.signed_in'), isTrue);
  });

  testWidgets('Home screen is shown when the app launches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('id', 'ID'),
    );
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Buat'), findsOneWidget);
    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('Remove background tool opens its upload screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Hapus BG'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus BG'));
    await tester.pumpAndSettle();

    expect(find.text('Unggah gambar'), findsOneWidget);
    expect(find.byKey(const ValueKey('remove-bg-pick-image')), findsOneWidget);
    expect(find.text('Mulai Hapus'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('remove-bg-start')))
          .onPressed,
      isNull,
    );
  });

  testWidgets('Home screen adapts to narrow and wide layouts', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(SingleChildScrollView).first).width, 320);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1200, 900);
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(SingleChildScrollView).first).width,
      1200,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bottom navigation opens each destination', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('month-year-picker')), findsOneWidget);

    await tester.tap(find.text('Buat'));
    await tester.pumpAndSettle();
    expect(find.text('Jadwal Baru'), findsOneWidget);

    await tester.tap(find.text('Wawasan'));
    await tester.pumpAndSettle();
    expect(find.text('Kinerja konten'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Faizal Isman'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
  });

  testWidgets('Month and year can be selected from the calendar header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();

    final initialYear = DateTime.now().add(const Duration(days: 1)).year;
    await tester.tap(find.byKey(const ValueKey('month-year-picker')));
    await tester.pumpAndSettle();

    expect(find.text('Pilih bulan'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('schedule-year-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${initialYear + 1}').last);
    await tester.pumpAndSettle();
    expect(find.text('${initialYear + 1}'), findsOneWidget);

    await tester.tap(find.text('Jun'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        DateFormat('MMMM yyyy', 'id_ID').format(DateTime(initialYear + 1, 6)),
      ),
      findsOneWidget,
    );
    expect(find.text('Pilih bulan'), findsNothing);
  });

  testWidgets(
    'Generate caption asks for a prompt and drafts a caption from it',
    (WidgetTester tester) async {
      await tester.pumpWidget(const VibrApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buat'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buat caption'));
      await tester.pumpAndSettle();

      expect(find.text('Jelaskan ide caption'), findsOneWidget);
      final promptField = find.byKey(const ValueKey('caption-prompt-field'));
      await tester.enterText(promptField, 'A new spring collection');
      await tester.tap(find.byKey(const ValueKey('generate-from-prompt')));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('caption-field')))
            .controller!
            .text,
        contains('A new spring collection ✨'),
      );
      expect(find.text('Unggah'), findsOneWidget);
      expect(find.text('Upload new'), findsNothing);
    },
  );

  testWidgets(
    'Create flow schedules a post with a bounded split date and time picker',
    (WidgetTester tester) async {
      await tester.pumpWidget(const VibrApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buat'));
      await tester.pumpAndSettle();
      expect(find.text('Jadwal Baru'), findsOneWidget);

      final dateTimeSelector = find.byKey(
        const ValueKey('open-date-time-picker'),
      );
      await tester.ensureVisible(dateTimeSelector);
      await tester.pumpAndSettle();
      await tester.tap(dateTimeSelector);
      await tester.pumpAndSettle();
      expect(find.text('Tanggal & waktu'), findsNWidgets(2));
      expect(find.text('Tanggal'), findsOneWidget);
      expect(find.text('Waktu'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNothing);

      final maxYear = DateTime.now().year + 5;
      for (var year = DateTime.now().year; year < maxYear; year++) {
        await tester.tap(find.byTooltip('Tahun berikutnya'));
        await tester.pumpAndSettle();
      }
      expect(find.text('$maxYear'), findsOneWidget);
      expect(
        tester
            .widget<IconButton>(
              find.ancestor(
                of: find.byTooltip('Tahun berikutnya'),
                matching: find.byType(IconButton),
              ),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byKey(const ValueKey('confirm-date-time')));
      await tester.pumpAndSettle();
      expect(find.text('Tanggal & waktu'), findsOneWidget);

      final scheduleButton = find.widgetWithText(FilledButton, 'Jadwalkan');
      await tester.ensureVisible(scheduleButton);
      await tester.pumpAndSettle();
      await tester.tap(scheduleButton);
      await tester.pumpAndSettle();
      expect(find.text('Terbitkan sekarang atau jadwalkan?'), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Jadwalkan'));
      await tester.pumpAndSettle();
      expect(find.text('Tanggal & waktu'), findsNothing);
      expect(find.text('Jadwal'), findsNWidgets(2));
      expect(
        find.textContaining('Sambut ide segar dan sudut pandang baru.'),
        findsOneWidget,
      );

      final newPost = find.byWidgetPredicate(
        (widget) =>
            widget is Material &&
            widget.key is ValueKey<String> &&
            (widget.key! as ValueKey<String>).value.startsWith(
              'schedule-post-post-',
            ),
      );
      await tester.ensureVisible(newPost.first);
      await tester.pumpAndSettle();
      await tester.tap(newPost.first);
      await tester.pumpAndSettle();
      expect(find.text('Detail Postingan'), findsOneWidget);
      expect(find.text('Performa'), findsOneWidget);
    },
  );

  testWidgets('Post now hides the arrow, publishes, and opens post detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buat'));
    await tester.pumpAndSettle();
    final scheduleButton = find.widgetWithText(FilledButton, 'Jadwalkan');
    await tester.ensureVisible(scheduleButton);
    await tester.pumpAndSettle();
    await tester.tap(scheduleButton);
    await tester.pumpAndSettle();

    final postNowButton = find.widgetWithText(
      FilledButton,
      'Terbitkan sekarang',
    );
    expect(
      find.descendant(
        of: postNowButton,
        matching: find.byIcon(Icons.arrow_forward_rounded),
      ),
      findsNothing,
    );
    await tester.tap(postNowButton);
    await tester.pumpAndSettle();

    expect(find.text('Detail Postingan'), findsOneWidget);
    expect(find.text('Dipublikasikan'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('1 Postingan'), findsOneWidget);
    expect(find.text('Dipublikasikan'), findsOneWidget);
    expect(find.text('Instagram · Facebook'), findsOneWidget);
  });

  testWidgets('Schedule card menu can edit and delete a post', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VibrApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();
    const postId = 'post-oct-27';
    await tester.tap(find.byKey(const ValueKey('post-options-$postId')));
    await tester.pumpAndSettle();

    expect(find.text('Lihat detail postingan'), findsOneWidget);
    expect(find.text('Edit postingan'), findsOneWidget);
    expect(find.text('Hapus postingan'), findsOneWidget);
    await tester.tap(find.text('Edit postingan'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Postingan'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Updated schedule caption');
    final saveButton = find.widgetWithText(FilledButton, 'Simpan perubahan');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Updated schedule caption'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('post-options-$postId')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus postingan'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus postingan?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Updated schedule caption'), findsNothing);
  });
}
