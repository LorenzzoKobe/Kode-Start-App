// lib/widgets/recipe_grid_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/spoonacular_item_model.dart'; 
import '../providers/all_recipes_provider.dart';
import 'recipe_card_widget.dart';

class RecipeGridView extends StatelessWidget {
  const RecipeGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AllRecipesProvider>(
      builder: (context, provider, child) {
        
        switch (provider.state) {
          case RecipeState.loading:
          case RecipeState.initial:
            return const Center(child: CircularProgressIndicator());
          case RecipeState.error:
            return Center(child: Text("Erro ao carregar receitas: ${provider.errorMessage}"));
          case RecipeState.loaded:
            return _buildRecipeGrid(context, provider.recipes);
        }
      },
    );
  }

  // --- FUNÇÃO AUXILIAR PARA "MOCKAR" OS TÍTULOS ---
  String _getDisplayTitle(String apiTitle) {
    if (apiTitle.contains('Peanut Butter Banana Oat Breakfast Cookies')) {
      return 'Cookies de Aveia e Banana';
    }
    if (apiTitle.contains('How to Make OREO Turkeys')) {
      return 'Perus de OREO';
    }
    if (apiTitle.contains('Sausage & Pepperoni Stromboli')) {
      return 'Stromboli de Linguiça';
    }
    if (apiTitle.contains('Cannoli Ice Cream')) {
      return 'Sorvete de Cannoli';
    }
    if (apiTitle.contains('Turkey Pot Pie')) {
      return 'Torta de Peru';
    }
    if (apiTitle.contains('Slow Cooker Spicy Chicken Wings')) {
      return 'Asinhas Picantes';
    }
    
    // Se não for nenhum dos acima, retorna o original
    return apiTitle;
  }

  Widget _buildRecipeGrid(BuildContext context, List<SpoonacularRecipe> recipes) {
    return GridView.builder(
      itemCount: recipes.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final recipe = recipes[index];

        // USANDO A FUNÇÃO DE TÍTULO
        final String displayTitle = _getDisplayTitle(recipe.title);

        return RecipeCardWidget(
          externalId: recipe.id.toString(),
          
          // PASSANDO O TÍTULO CORRIGIDO
          title: displayTitle, 
          
          imageUrl: recipe.imgUrl,
          cookTime: null,
          origem: 'Spoonacular',
          
          ingredientesJson: '[]', 
          modoPreparoJson: '[]', 

          onTap: () {
            // A lógica de navegação já está dentro do RecipeCardWidget
          },
        );
      },
    );
  }
}