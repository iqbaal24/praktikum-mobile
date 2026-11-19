// Basic widget test for the MyDJ application.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Membangun widget tree yang sama dengan main() (MyApp di bawah Provider).
Widget buildApp() {
  return ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child: const MyApp(),
  );
}

/// MemPump beberapa frame supaya future async selesai, tanpa pumpAndSettle
/// (indikator loading di StartupPage beranimasi terus sehingga tak pernah settle).
Future<void> pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
}

/// Menggulir widget ke area terlihat lalu tap (viewport test 800x600, tombol
/// Login berada di bawah lipatan karena gambar login 250px + AppBar).
Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Startup page directs a guest to the login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await pumpFrames(tester);

    expect(find.text('Log-In'), findsOneWidget);
    expect(find.text('Nama Pengguna:'), findsOneWidget);
    expect(find.text('Sandi:'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Startup page skips the login screen for a logged in user',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'username': 'guru',
      'password': 'guru',
      'isLoggedIn': true,
    });

    await tester.pumpWidget(buildApp());
    await pumpFrames(tester);

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Lihat Jurnal'), findsOneWidget);
    expect(find.text('Buat Jurnal'), findsOneWidget);
    expect(find.text('Akun'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });

  testWidgets('Login with guru/guru opens the home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await pumpFrames(tester);

    await tester.enterText(find.byType(TextField).first, 'guru');
    await tester.enterText(find.byType(TextFormField).first, 'guru');
    await scrollAndTap(tester, find.text('Login'));
    await pumpFrames(tester);

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Lihat Jurnal'), findsOneWidget);
    expect(find.text('Buat Jurnal'), findsOneWidget);
    expect(find.text('Akun'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });

  testWidgets('Login with wrong credentials keeps the user on the login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await pumpFrames(tester);

    await tester.enterText(find.byType(TextField).first, 'salah');
    await tester.enterText(find.byType(TextFormField).first, 'salah');
    await scrollAndTap(tester, find.text('Login'));
    await pumpFrames(tester);

    expect(find.text('Nama pengguna atau sandi salah!'), findsOneWidget);
    expect(find.text('Log-In'), findsOneWidget);
  });
}
