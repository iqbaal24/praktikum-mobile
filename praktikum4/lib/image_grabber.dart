
import 'dart:io';
import 'downloader.dart';
import 'html_parser.dart';

class ImageGrabber {
  final String url;
  final String outputFolder;

  ImageGrabber(this.url, this.outputFolder);

  Future<void> run() async {
    print('Mengunduh halaman...');

    final htmlContent = await Downloader.fetchHtml(url);

    if (htmlContent == null) {
      print('Gagal mengunduh halaman.');
      return;
    }

    final imageUrls = HtmlParser.extractImageUrls(
      htmlContent,
      baseUrl: url,
    );

    if (imageUrls.isEmpty) {
      print('Tidak ditemukan gambar pada halaman.');
      return;
    }

    final directory = Directory(outputFolder);

    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    print('Menemukan ${imageUrls.length} gambar. Mengunduh...');

    for (final imageUrl in imageUrls) {
      await Downloader.downloadImage(
        imageUrl,
        directory.path,
      );
    }

    print(
      "Unduhan selesai, silakan cek folder '$outputFolder'.",
    );
  }
}
