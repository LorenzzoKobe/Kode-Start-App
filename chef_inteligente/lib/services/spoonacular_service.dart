import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_keys.dart';
import '../models/spoonacular_detail_model.dart'; 

class SpoonacularService {
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  static const String _apiKey = ApiKeys.spoonacularApiKey;

  Future<List<dynamic>> getPopularRecipes({String? filterTerm, String? search}) async {
    
    String url = '$_baseUrl/complexSearch?number=10&apiKey=$_apiKey';

    if (search != null && search.isNotEmpty) {
      url += '&query=$search';
    } else if (filterTerm != null && filterTerm.isNotEmpty) {
        url += '&type=$filterTerm';
    } else {
        url += '&sort=popularity';
    }

    debugPrint('Tentando API Call: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Erro ao buscar receitas: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro de conexão Spoonacular: $e');
      throw Exception('Erro de conexão: $e'); 
    }
  }

  Future<SpoonacularDetail> getRecipeDetails(String recipeId) async {
    String url = '$_baseUrl/$recipeId/information?includeNutrition=false'; 
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SpoonacularDetail.fromJson(data); 
      } else {
        throw Exception('Erro ao buscar detalhes: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro de conexão (Detalhes): $e');
      throw Exception('Erro de conexão (Detalhes): $e');
    }
  }
}