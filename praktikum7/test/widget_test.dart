// Basic widget test for the MyDJ home screen.

import 'package:flutter_test/flutter_test.dart';

import 'package:praktikum7/main.dart';

void main() {
  testWidgets('MyDJ home screen renders logo and buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Jurnal Harian Guru'), findsOneWidget);
    expect(find.text('Lihat Jurnal'), findsOneWidget);
    expect(find.text('Buat Jurnal'), findsOneWidget);
    expect(find.text('Akun'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });
}