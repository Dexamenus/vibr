import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:vibr/app.dart';

void main() {
  testWidgets('Calendar schedule preview is shown when the app launches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SociAiApp());

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('id', 'ID'),
    );
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Buat'), findsOneWidget);
    expect(find.text('Jadwal'), findsNWidgets(2));
    expect(find.text('Month'), findsNothing);
    expect(find.text('Week'), findsNothing);
    expect(find.text('1 Postingan'), findsOneWidget);
    expect(
      find.text('Orbit ungu. Kilau mint. ✦ Sambut ide-ide segar.'),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/img/Violet orbits artwork.png',
      ),
      findsOneWidget,
    );
    expect(find.text('Dipublikasikan'), findsNothing);
  });

  testWidgets('Month and year can be selected from the calendar header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SociAiApp());

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
      await tester.pumpWidget(const SociAiApp());

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
      await tester.pumpWidget(const SociAiApp());

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
    await tester.pumpWidget(const SociAiApp());

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
    await tester.pumpWidget(const SociAiApp());
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
