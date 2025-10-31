import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/spoonacular_item_model.dart'; 
import '../providers/all_recipes_provider.dart';


class RecipeGridView extends StatelessWidget {
  const RecipeGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AllRecipesProvider>(
      builder: (context, provider, child) {
        
        switch (provider.state) {
          case RecipeState.loading:
          case RecipeState.initial:
            return Center(child: CircularProgressIndicator());

          case RecipeState.error:
            return Center(child: Text("Erro ao carregar receitas: ${provider.errorMessage}"));

          case RecipeState.loaded:
            return _buildRecipeGrid(provider.recipes);
        }
      },
    );
  }

  Widget _buildRecipeGrid(List<SpoonacularRecipe> recipes) {
    return GridView.builder(
      itemCount: recipes.length,
      
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      
      padding: EdgeInsets.all(16.0),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _buildGridCard(context, recipe);
      },
    );
  }

  Widget _buildGridCard(BuildContext context, SpoonacularRecipe recipe) {

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Stack(
        fit: StackFit.expand,
        children: [

          Image.network(
            recipe.imgUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('$error, stackTrace: $stackTrace');
              return Center(child: Icon(Icons.broken_image, size: 30, color: const Color.fromARGB(255, 141, 105, 39)));

            },
            loadingBuilder: (context, child, loadingProgress) {
                 if (loadingProgress == null) return child;
                 return Center(child: CircularProgressIndicator());
            }
          ),
          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),

          Positioned(
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
            child: Text(
              recipe.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 6.0, color: Colors.black.withOpacity(0.8))],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}