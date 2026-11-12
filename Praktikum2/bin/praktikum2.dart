
import 'dart:io';
import 'modul_lain.dart';

void main() {
  print('Halo, Dart!');
  print('--------------');

  // 1. Fungsi, Variabel, dan Tipe Data
  fungsiPercobaan1();

  // 2. Operator
  fungsiPercobaan2();

  // 3. Input Pengguna
  fungsiPercobaan3();

  // 4. Pencabangan
  fungsiPercobaan4(80);

  // 5. Perulangan
  fungsiPercobaan5('Iqbal', 5);

  // 6. Fungsi dari file lain
  fungsiPercobaan6();

  // 7. List
  fungsiPercobaanList();

  // 8. Map
  fungsiPercobaanMap();

  // 9. Set
  fungsiPercobaanSet();
}

void fungsiPercobaan1() {
  String nama = 'Iqbal';
  int umur = 20;
  double ipk = 3.89;
  bool lulus = true;

  print('Nama         : $nama');
  print('Umur         : $umur');
  print('IPK          : $ipk');
  print('Sudah Lulus? : $lulus');
  print('--------------');
}

void fungsiPercobaan2() {
  int a = 10;
  int b = 3;

  print('Penjumlahan: ${a + b}');
  print('Pembagian  : ${a / b}');
  print('Modulus    : ${a % b}');
  print('Logika     : ${(a > b) && (b < 5)}');
  print('--------------');
}

void fungsiPercobaan3() {
  stdout.write('Masukkan nama: ');
  String? nama = stdin.readLineSync();

  print('Halo, $nama!');
  print('--------------');
}

void fungsiPercobaan4(double nilai) {
  String status;

  if (nilai >= 75) {
    status = 'Lulus';
  } else {
    status = 'Mengulang';
  }

  print('Nilai : $nilai');
  print('Status: $status');
  print('--------------');
}

void fungsiPercobaan5(String nama, double jumlah) {
  for (int i = 0; i < jumlah; i++) {
    print('For ke-$i: $nama');
  }

  print('--------------');

  int j = 0;
  while (j < jumlah) {
    print('While ke-$j: $nama');
    j++;
  }

  print('--------------');
}
