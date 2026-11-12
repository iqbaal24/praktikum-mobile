
import 'dart:io';
import '../lib/image_grabber.dart';

Future<void> main() async {
  print('Selamat datang di Dart Image Grabber!');

  stdout.write('Inputkan halaman web: ');
  final url = stdin.readLineSync()?.trim() ?? '';

  if (url.isEmpty ||
      (Uri.tryParse(url)?.hasScheme != true) ||
      !(url.startsWith('http://') ||
          url.startsWith('https://'))) {
    print('URL tidak valid. Gunakan URL HTTP atau HTTPS.');
    return;
  }

  stdout.write('Masukkan folder tujuan: ');
  final folder = stdin.readLineSync()?.trim() ?? '';

  if (folder.isEmpty) {
    print('Folder tujuan tidak boleh kosong.');
    return;
  }

  final grabber = ImageGrabber(url, folder);
  await grabber.run();
}
