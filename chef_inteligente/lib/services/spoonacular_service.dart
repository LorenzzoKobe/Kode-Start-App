import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_keys.dart';

// 1. IMPORTAR O NOVO MODELO DE DETALHES (que criaremos a seguir)
import '../models/spoonacular_detail_model.dart'; 

class SpoonacularService {
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  // 2. LISTA DE CHAVES (com fallback)
  static final List<String> _apiKeys = [
    ApiKeys.spoonacularApiKey,
    ApiKeys.spoonacularApiKey_Fallback, // Assumindo que o senhor adicionou esta no ApiKeys.dart
  ];
  int _currentKeyIndex = 0;

  String _getApiKey() {
    return _apiKeys[_currentKeyIndex];
  }

  void _rotateApiKey() {
    _currentKeyIndex = (_currentKeyIndex + 1) % _apiKeys.length;
    debugPrint('Cota da API atingida. Rotacionando para a próxima chave.');
  }

  // 3. EXECUTOR DE CHAMADA COM FALLBACK
  Future<http.Response> _makeApiCall(String url) async {
    int attemptCount = 0;
    while (attemptCount < _apiKeys.length) {
      
      String urlWithKey = '$url&apiKey=${_getApiKey()}';
      debugPrint('Tentando API Call: $urlWithKey'); // Ótimo para depuração
      final response = await http.get(Uri.parse(urlWithKey));

      if (response.statusCode == 402 || response.statusCode == 429) { // 402 = Cota estourada
        _rotateApiKey();
        attemptCount++;
      } else {
        return response; // Retorna 200 (OK) ou outro erro (404, 500)
      }
    }
    throw Exception('Todas as chaves da API atingiram o limite.');
  }


  // --- GET POPULAR RECIPES (Atualizado) ---
  Future<List<dynamic>> getPopularRecipes({String? filterTerm, String? search}) async {
    // Chave removida daqui, será adicionada pelo _makeApiCall
    String url = '$_baseUrl/complexSearch?number=6'; 

    if (search != null && search.isNotEmpty) {
      url += '&query=$search';
    } else if (filterTerm != null && filterTerm.isNotEmpty) {
      url += '&type=$filterTerm';
    } else {
      url += '&sort=popularity';
    }

    try {
      final response = await _makeApiCall(url); // Usa o executor com fallback

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

  // --- 4. NOVO MÉTODO (para a Tela de Detalhes) ---
  Future<SpoonacularDetail> getRecipeDetails(String recipeId) async {
    // Chave removida daqui
    String url = '$_baseUrl/$recipeId/information?includeNutrition=false'; 
    
    try {
      final response = await _makeApiCall(url); // Usa o executor com fallback

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SpoonacularDetail.fromJson(data);
      } else {
        throw Exception('Erro ao buscar detalhes da receita: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro de conexão Spoonacular (Detalhes): $e');
      throw Exception('Erro de conexão (Detalhes): $e');
    }
  }
}