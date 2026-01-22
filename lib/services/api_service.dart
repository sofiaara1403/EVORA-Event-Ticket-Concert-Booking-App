import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti URL ini dengan API endpoint dari MockAPI Anda
  static const String _baseUrl = "https://6970524d78fec16a63fd5d15.mockapi.io/external_news";

  Future<List<dynamic>> fetchExternalNews() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        // Berhasil mengambil data
        return json.decode(response.body);
      } else {
        // Gagal mengambil data
        print("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      // Terjadi kesalahan jaringan
      print("Network Error: $e");
      return [];
    }
  }
}