
import 'package:html/parser.dart' as parser;

class HtmlParser {
  static String _resolveUrl(String baseUrl, String src) {
    final uri = Uri.parse(src);

    if (uri.hasScheme) {
      return src;
    }

    final base = Uri.parse(baseUrl);
    return base.resolveUri(uri).toString();
  }

  static List<String> extractImageUrls(
      String html, {
        required String baseUrl,
      }) {
    final document = parser.parse(html);
    final elements = document.getElementsByTagName('img');
    final List<String> imageUrls = [];

    for (final element in elements) {
      final src = element.attributes['src'];

      if (src != null && src.trim().isNotEmpty) {
        final fullUrl = _resolveUrl(baseUrl, src.trim());
        imageUrls.add(fullUrl);
      }
    }

    return imageUrls;
  }
}
