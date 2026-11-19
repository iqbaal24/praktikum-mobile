// Uji fitur Kuis-2: detail jurnal, pre-fill, dan update (SQLite UPDATE).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydj/data/database_helper.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:mydj/pages/buat_jurnal_page.dart';
import 'package:mydj/pages/detail_jurnal_page.dart';
import 'package:mydj/pages/lihat_jurnal_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Widget buildApp(Widget child) {
  return ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child: MaterialApp(home: child),
  );
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Halaman detail menampilkan semua atribut jurnal sebagai teks',
      (WidgetTester tester) async {
    final Jurnal jurnal = Jurnal(
      id: 1,
      kelas: '3A',
      mapel: 'Matematika',
      jam: 2,
      tujuanPembelajaran: 'Menjumlah dua bilangan',
      materiTopikPembelajaran: 'Penjumlahan',
      kegiatanPembelajaran: 'Latihan soal',
      dimensiProfilPelajarPancasila: 'Berakhlak mulia',
    );

    await tester.pumpWidget(buildApp(DetailJurnalPage(jurnal: jurnal)));

    // Judul atribut.
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('Mata Pelajaran'), findsOneWidget);
    expect(find.text('Jam Ke-'), findsOneWidget);
    expect(find.text('Tujuan Pembelajaran'), findsOneWidget);
    expect(find.text('Materi / Topik Pembelajaran'), findsOneWidget);
    expect(find.text('Kegiatan Pembelajaran'), findsOneWidget);
    expect(find.text('Dimensi Profil Pelajar Pancasila'), findsOneWidget);
    expect(find.text('Waktu Dibuat'), findsOneWidget);

    // Nilai atribut.
    expect(find.text('3A'), findsOneWidget);
    expect(find.text('Matematika'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Menjumlah dua bilangan'), findsOneWidget);
    expect(find.text('Penjumlahan'), findsOneWidget);
    expect(find.text('Latihan soal'), findsOneWidget);
    expect(find.text('Berakhlak mulia'), findsOneWidget);

    // Halaman detail bersifat read-only: tidak ada isian yang bisa diketik.
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(TextFormField), findsNothing);

    // Tombol edit.
    expect(find.text('Edit Jurnal Ini'), findsOneWidget);
  });

  testWidgets('Halaman edit terisi otomatis dengan data jurnal yang tersimpan',
      (WidgetTester tester) async {
    final Jurnal jurnal = Jurnal(
      id: 7,
      kelas: '4B',
      mapel: 'IPA',
      jam: 4,
      tujuanPembelajaran: 'Memahami gaya',
      materiTopikPembelajaran: 'Fisika',
      kegiatanPembelajaran: 'Praktikum',
      dimensiProfilPelajarPancasila: 'Gotong royong',
    );

    await tester.pumpWidget(buildApp(BuatJurnalPage(jurnal: jurnal)));

    // Semua isian teks terisi otomatis (pre-fill).
    expect(find.widgetWithText(TextField, '4B'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'IPA'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Memahami gaya'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Fisika'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Praktikum'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Gotong royong'), findsOneWidget);

    // Dropdown jam juga terisi otomatis.
    final DropdownButtonFormField<String> dropdown =
        tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(dropdown.initialValue, '4');
  });

  testWidgets('Menekan baris pada daftar jurnal membuka halaman detail',
      (WidgetTester tester) async {
    final DataProvider provider = DataProvider();
    await provider.tambahJurnal(Jurnal(kelas: '5A', mapel: 'Bahasa Indonesia'));

    await tester.pumpWidget(
      ChangeNotifierProvider<DataProvider>.value(
        value: provider,
        child: const MaterialApp(home: LihatJurnalPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('5A'), findsOneWidget);

    await tester.tap(find.text('5A'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailJurnalPage), findsOneWidget);
    expect(find.text('Detail Jurnal'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);
  });

  testWidgets('ubahJurnal memperbarui baris lama, tidak menambah baris baru',
      (WidgetTester tester) async {
    final DataProvider provider = DataProvider();
    await provider.tambahJurnal(Jurnal(kelas: '6A', mapel: 'Sejarah'));
    expect(provider.jurnalTersimpan.length, 1);

    final Jurnal lama = provider.jurnalTersimpan.first;

    // Ubah isi jurnal.
    lama.kelas = '6B';
    lama.mapel = 'Sejarah Dunia';

    await provider.ubahJurnal(lama);

    // Jumlah baris tetap satu -> UPDATE, bukan INSERT.
    expect(provider.jurnalTersimpan.length, 1);
    expect(provider.jurnalTersimpan.first.kelas, '6B');
    expect(provider.jurnalTersimpan.first.mapel, 'Sejarah Dunia');

    // Data juga benar-benar tersimpan di database.
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('jurnal');
    expect(rows.length, 1);
    expect(rows.first['kelas'], '6B');
  });
}
