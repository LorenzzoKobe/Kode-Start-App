import 'package:flutter/material.dart';
import '../models/spoonacular_item_model.dart';
import '../services/spoonacular_service.dart';
import '../services/translation_service.dart';

enum RecipeState {
  initial,
  loading,
  loaded,
  error
}

class AllRecipesProvider extends ChangeNotifier {
  final SpoonacularService _service = SpoonacularService();
  final TranslationService _translationService = TranslationService();

  RecipeState _state = RecipeState.initial;
  List<SpoonacularRecipe> _recipes = [];
  String _errorMessage = '';

  RecipeState get state => _state;
  List<SpoonacularRecipe> get recipes => _recipes;
  String get errorMessage => _errorMessage;

  Future<void> fetchAllRecipes({String? filterTerm, String? search}) async {
    try {
      _state = RecipeState.loading;
      notifyListeners();

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
        notifyListeners();
        return;
      }

      final List<Future<String>> translationFutures = originalRecipes
          .map((recipe) => _translationService.translateText(recipe.title))
          .toList();
        
      final List<String> translatedTitles = await Future.wait(translationFutures);

      _recipes = [];

      for (int i = 0; i < originalRecipes.length; i++) {
        _recipes.add(SpoonacularRecipe(
          id: originalRecipes[i].id,
          imgUrl: originalRecipes[i].imgUrl,
          title: translatedTitles[i], 
        ));
      }

      _state = RecipeState.loaded;
      notifyListeners();

    } catch (e) {
      _errorMessage = e.toString();
      _state = RecipeState.error;
      notifyListeners();
    }
  }
}