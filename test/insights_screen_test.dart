import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibr/core/theme/app_theme.dart';
import 'package:vibr/features/insights/insights_screen.dart';

void main() {
  testWidgets('menampilkan ringkasan dan beralih ke komentar terbaru', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app(const InsightsScreen()));

    expect(find.text('Kinerja konten'), findsOneWidget);
    expect(find.text('17.052'), findsNWidgets(2));
    expect(find.text('Tingkat interaksi'), findsWidgets);

    await tester.tap(find.text('Komentar').first);
    await tester.pumpAndSettle();

    expect(find.text('Komentar Hari Ini'), findsOneWidget);
    expect(find.text('Semua 23'), findsOneWidget);
    expect(find.text('Menampilkan 3 dari 23'), findsOneWidget);
    expect(find.text('@naya.design'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(find.text('@arif.studio'), findsOneWidget);
    expect(find.text('Pertanyaan'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(find.text('@maya.creates'), findsOneWidget);
  });

  testWidgets('menerapkan filter periode dan jejaring sosial', (tester) async {
    await tester.pumpWidget(_app(const InsightsScreen()));

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Filter analitik'), findsOneWidget);

    await tester.tap(find.text('30 hari'));
    await tester.tap(find.text('Terapkan filter'));
    await tester.pumpAndSettle();
    expect(find.text('73.080'), findsWidgets);
  });

  testWidgets('filter analitik hanya mengizinkan satu jejaring sosial', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const InsightsScreen()));

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Pilih satu platform.'), findsOneWidget);

    await tester.tap(find.text('Facebook'));
    await tester.tap(find.text('Terapkan filter'));
    await tester.pumpAndSettle();

    expect(find.text('Contoh analitik · Facebook'), findsOneWidget);
  });

  testWidgets('menampilkan keadaan kosong saat tidak ada komentar', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const InsightsScreen(initialComments: [])));

    await tester.tap(find.text('Komentar').first);
    await tester.pumpAndSettle();

    expect(find.text('Semua 0'), findsOneWidget);
    expect(find.text('Semua komentar sudah diperiksa'), findsOneWidget);
    expect(find.text('Komentar baru akan muncul di sini.'), findsOneWidget);
  });
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark, home: home);
