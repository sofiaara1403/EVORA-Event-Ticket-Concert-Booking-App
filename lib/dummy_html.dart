// lib/dummy_html.dart
class Blob {
  Blob(List content);
}

class Url {
  static String createObjectUrlFromBlob(dynamic blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  String href;
  AnchorElement({required this.href});
  void setAttribute(String name, String value) {}
  void click() {}
}