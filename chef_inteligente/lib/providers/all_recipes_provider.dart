import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/spoonacular_item_model.dart';
import '../services/spoonacular_service.dart';
import '../services/translation_service.dart';

enum RecipeState { initial, loading, loaded, error }

class AllRecipesProvider extends ChangeNotifier {
  final SpoonacularService _service = SpoonacularService();
  final TranslationService _translationService = TranslationService();

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
      notifyListeners(); 

      if (filterTerm != null || search != null) {
        await _fetchFromApi(filterTerm: filterTerm, search: search);
      } 
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
      notifyListeners();
    }
  }

  Future<void> _fetchFromApi({String? filterTerm, String? search}) async {
    try {
      final List<dynamic> jsonList = await _service.getPopularRecipes(
        filterTerm: filterTerm,
        search: search,
      );
      final List<SpoonacularRecipe> originalRecipes = jsonList
          .map((json) => SpoonacularRecipe.fromJson(json))
          .toList();

      if (originalRecipes.isEmpty) {
        _recipes = [];
        _state = RecipeState.loaded;
        return;
      }

      debugPrint("A traduzir ${originalRecipes.length} títulos...");
      final List<Future<String>> translationFutures = originalRecipes
          .map((recipe) => _translationService.translateText(recipe.title))
          .toList();

      final List<String> translatedTitles = await Future.wait(translationFutures);

      List<SpoonacularRecipe> translatedRecipes = [];
      for (int i = 0; i < originalRecipes.length; i++) {
        translatedRecipes.add(SpoonacularRecipe(
          id: originalRecipes[i].id,
          imgUrl: originalRecipes[i].imgUrl,
          title: translatedTitles[i],
        ));
      }

      _recipes = translatedRecipes;
      _state = RecipeState.loaded;

      if (filterTerm == null && search == null) {
        debugPrint("A salvar receitas traduzidas no cache...");
        final prefs = await SharedPreferences.getInstance();
        
        final List<Map<String, dynamic>> cacheData = translatedRecipes.map((recipe) => {
          'id': recipe.id,
          'title': recipe.title,
          'image': recipe.imgUrl
        }).toList();

        await prefs.setString(_cacheKey, jsonEncode(cacheData));
        await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
      }

    } catch (e) {
      _errorMessage = e.toString();
      _state = RecipeState.error;
    }
  }
}