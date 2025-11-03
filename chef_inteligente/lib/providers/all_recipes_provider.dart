import 'package:flutter/material.dart';
import '../models/spoonacular_item_model.dart';
import '../services/spoonacular_service.dart';

enum RecipeState {
  initial,
  loading,
  loaded,
  error
}

class AllRecipesProvider extends ChangeNotifier {
  final SpoonacularService _service = SpoonacularService();

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

      _recipes = jsonList
          .map((json) => SpoonacularRecipe.fromJson(json))
          .toList();

      _state = RecipeState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = RecipeState.error;
      notifyListeners();
    }
  }
}