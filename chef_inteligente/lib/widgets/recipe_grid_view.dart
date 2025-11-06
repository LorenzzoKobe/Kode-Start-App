// lib/widgets/recipe_grid_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/spoonacular_item_model.dart'; 
import '../providers/all_recipes_provider.dart';
import 'recipe_card_widget.dart';
import '../screens/recipe_detail_screen.dart';

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

        final String displayTitle = recipe.title;

        return RecipeCardWidget(
          externalId: recipe.id.toString(),
          
          title: displayTitle, 
          
          imageUrl: recipe.imgUrl,
          cookTime: null,
          origem: 'Spoonacular',
          
          ingredientesJson: '[]', 
          modoPreparoJson: '[]', 

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                  externalId: recipe.id.toString(),
                  title: displayTitle,
                  imageUrl: recipe.imgUrl,
                  cookTime: null,
                  ingredientesJson: '[]',
                  modoPreparoJson: '[]',
                  origem: 'Spoonacular',
                ),
              ),
            );
          },
        );
      },
    );
  }
}