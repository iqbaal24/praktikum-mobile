
import 'dart:io';
import 'mata_kuliah.dart';

void main() {
  List<MataKuliah> transkrip = [
    MataKuliah('IF101', 'Algoritma', 3, 3.5),
    MataKuliah('IF102', 'Basis Data', 3, 4.0),
    MataKuliah('IF103', 'Pemrograman', 4, 3.0),
  ];

  while (true) {
    print('\n=== MENU TRANSKRIP NILAI ===');
    print('1. Hitung IPK');
    print('2. Filter Nilai Bagus');
    print('3. Menampilkan Nilai Terformat');
    print('0. Keluar');
    stdout.write('Pilih menu: ');

    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        double totalNilai = transkrip
            .map((mk) => mk.nilai * mk.sks)
            .reduce((a, b) => a + b);

        int totalSks = transkrip
            .map((mk) => mk.sks)
            .reduce((a, b) => a + b);

        double ipk = totalNilai / totalSks;

        print('IPK: ${ipk.toStringAsFixed(2)}');
        break;

      case '2':
        var nilaiBagus =
        transkrip.where((mk) => mk.nilai >= 3.5);

        print('\nMata kuliah dengan nilai bagus:');
        for (var mk in nilaiBagus) {
          print('${mk.nama} (${mk.nilai})');
        }
        break;

      case '3':
        print('\nDaftar Ringkas:');
        transkrip
            .map((mk) => '${mk.nama}: ${mk.nilai}')
            .forEach(print);
        break;

      case '0':
        print('Program selesai.');
        return;

      default:
        print('Pilihan tidak valid.');
    }
  }
}
