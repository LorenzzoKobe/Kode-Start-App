import 'package:flutter/material.dart';
import 'package:chef_inteligente/data/local/database_helper.dart';
import 'package:chef_inteligente/models/receita_favorita_model.dart';

class FavoriteRecipesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<ReceitaFavorita> _favoriteRecipes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReceitaFavorita> get favoriteRecipes => _favoriteRecipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FavoriteRecipesProvider() {
    // Carrega os favoritos assim que o provider é criado
    loadFavoriteRecipes();
  }

  Future<void> loadFavoriteRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a UI que o carregamento começou

    try {
      _favoriteRecipes = await _dbHelper.getTodosFavoritos();
    } catch (e) {
      _errorMessage = 'Erro ao carregar favoritos: $e';
      print(_errorMessage); // Para depuração
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a UI que o carregamento terminou (ou houve erro)
    }
  }

  Future<void> addFavorite(ReceitaFavorita receita) async {
    try {
      await _dbHelper.adicionarFavorito(receita);
      await loadFavoriteRecipes(); // Recarrega a lista para atualizar a UI
    } catch (e) {
      _errorMessage = 'Erro ao adicionar favorito: $e';
      print(_errorMessage);
      notifyListeners(); // Notifica a UI em caso de erro
    }
  }

  Future<void> removeFavorite(String externalId) async {
    try {
      await _dbHelper.removerFavorito(externalId);
      await loadFavoriteRecipes(); // Recarrega a lista para atualizar a UI
    } catch (e) {
      _errorMessage = 'Erro ao remover favorito: $e';
      print(_errorMessage);
      notifyListeners(); // Notifica a UI em caso de erro
    }
  }

  Future<bool> isRecipeFavorite(String externalId) async {
    return await _dbHelper.isFavorito(externalId);
  }
}