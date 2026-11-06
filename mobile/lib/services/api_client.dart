import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/verse.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiClient {
  // Backend FastAPI dev server (see backend/README.md for how to run it).
  static const String baseUrl = 'http://localhost:8001';

  Future<List<Verse>> getSurahVerses(int surahNumber) async {
    final uri = Uri.parse('$baseUrl/surahs/$surahNumber/verses');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Erreur ${response.statusCode} lors du chargement de la sourate');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return data.map((e) => Verse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<SearchResult>> search(String query, {String lang = 'fr'}) async {
    final uri = Uri.parse('$baseUrl/search').replace(queryParameters: {
      'q': query,
      'lang': lang,
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Erreur ${response.statusCode} lors de la recherche');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return data.map((e) => SearchResult.fromJson(e as Map<String, dynamic>)).toList();
  }
}
