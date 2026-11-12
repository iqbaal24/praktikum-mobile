
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Downloader {
  static Future<String?> fetchHtml(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      }

      print('Gagal mengunduh halaman. '
          'Status: ${response.statusCode}');
    } catch (e) {
      print('Error saat mengunduh halaman: $e');
    }

    return null;
  }

  static Future<void> downloadImage(
      String imageUrl,
      String folderPath,
      ) async {
    try {
      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var filename = path.basename(uri.path);

        if (filename.isEmpty) {
          filename = 'image_${DateTime.now().microsecondsSinceEpoch}.jpg';
        }

        final filePath = path.join(folderPath, filename);
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        print('Berhasil mengunduh: $filename');
      } else {
        print('Gagal mengunduh $imageUrl '
            '(status ${response.statusCode})');
      }
    } catch (e) {
      print('Gagal mengunduh $imageUrl: $e');
    }
  }
}
