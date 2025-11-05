// lib/providers/all_recipes_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/spoonacular_item_model.dart';
import '../services/spoonacular_service.dart';

enum RecipeState { initial, loading, loaded, error }

class AllRecipesProvider extends ChangeNotifier {
  final SpoonacularService _service = SpoonacularService();

  RecipeState _state = RecipeState.initial;
  List<SpoonacularRecipe> _recipes = [];
  String _errorMessage = '';

  RecipeState get state => _state;
  List<SpoonacularRecipe> get recipes => _recipes;
  String get errorMessage => _errorMessage;

  static const int _cacheDurationInHours = 6;
  static const String _cacheKey = 'popular_recipes_cache';
  static const String _timestampKey = 'popular_recipes_timestamp';

  Future<void> fetchAllRecipes({String? filterTerm, String? search}) async {
    try {
      _state = RecipeState.loading;
      // Notifica o "loading" ANTES de buscar
      notifyListeners(); 

      // Se o usuário estiver filtrando ou buscando, VÁ PARA A API
      if (filterTerm != null || search != null) {
        await _fetchFromApi(filterTerm: filterTerm, search: search);
      } 
      // Se for o carregamento normal da Home, TENTE O CACHE
      else {
        final prefs = await SharedPreferences.getInstance();
        final String? cachedData = prefs.getString(_cacheKey);
        final int? cachedTimestamp = prefs.getInt(_timestampKey);
        final int now = DateTime.now().millisecondsSinceEpoch;
        final int cacheAgeInMs = _cacheDurationInHours * 60 * 60 * 1000;

        if (cachedData != null && cachedTimestamp != null && (now - cachedTimestamp < cacheAgeInMs)) {
          // CACHE HIT
          final List<dynamic> jsonList = jsonDecode(cachedData);
          _recipes = jsonList.map((json) => SpoonacularRecipe.fromJson(json)).toList();
          _state = RecipeState.loaded;
        } else {
          // CACHE MISS
          await _fetchFromApi(filterTerm: null, search: null);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = RecipeState.error;
    } finally {
      // Este notifyListeners() agora é chamado DEPOIS que
      // o cache (com sucesso) OU o _fetchFromApi (com sucesso ou erro)
      // terminarem de atualizar os dados.
      notifyListeners();
    }
  }

  // Função interna (agora NÃO notifica, só atualiza os dados)
  Future<void> _fetchFromApi({String? filterTerm, String? search}) async {
    try {
      final List<dynamic> jsonList = await _service.getPopularRecipes(
        filterTerm: filterTerm,
        search: search,
      );

      _recipes = jsonList.map((json) => SpoonacularRecipe.fromJson(json)).toList();

      if (_recipes.isEmpty && filterTerm == null && search == null) {
        throw Exception("Nenhuma receita popular foi encontrada. (API retornou vazio)");
      }

      _state = RecipeState.loaded;

      // Salva no cache APENAS se não for uma busca/filtro
      if (filterTerm == null && search == null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheKey, jsonEncode(jsonList));
        await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
      }

    } catch (e) {
      _errorMessage = e.toString();
      _state = RecipeState.error;
      // Não precisamos mais do rethrow, o 'finally' no fetchAllRecipes vai
      // notificar a UI sobre o estado de erro.
    }
  }
}