import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_keys.dart';

class SpoonacularService {
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  static const String _apiKey = ApiKeys.spoonacularApiKey;

  Future<List<dynamic>> getPopularRecipes({String? filterTerm, String? search}) async {
    String url = '$_baseUrl/complexSearch?number=2&apiKey=$_apiKey';

    if (search != null && search.isNotEmpty) {
      url += '&query=$search';
    } else if (filterTerm != null && filterTerm.isNotEmpty) {
        url += '&type=$filterTerm';
    } else {
        url += '&sort=popularity';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> recipes = data['results'];

        debugPrint('Receitas da Spoonacular encontradas: ${recipes.length}');
        return recipes;
      } else {
        debugPrint('Erro na API Spoonacula  r: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Erro de conexão Spoonacular: $e');
      return [];
    }
  }
  
}
