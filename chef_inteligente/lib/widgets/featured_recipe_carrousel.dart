// lib/widgets/featured_recipe_carrousel.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/recipe_model.dart'; 
import '../services/graphql_queries.dart';
import 'recipe_card_widget.dart';

class FeaturedRecipeCarousel extends StatelessWidget {
  const FeaturedRecipeCarousel({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getFeaturedRecipesQuery),
      ),
      builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
        
        if (result.hasException) {
          return Container(height: 180, child: Center(child: Text("Erro ao carregar as receitas.")));
        }
        if (result.isLoading) {
          return Container(height: 180, child: Center(child: CircularProgressIndicator()));
        }

        final List? items = result.data?['receitaDestaqueCollection']?['items'];

        if (items == null || items.isEmpty) {
          return Container(height: 180, child: Center(child: Text("Nenhuma receita em destaque.")));
        }

        final List<FeaturedRecipe> recipes = items
            .map((item) => FeaturedRecipe.fromJson(item))
            .toList();

        return Container(
          height: 180, // Altura do Carrossel
          child: PageView.builder(
            itemCount: recipes.length,
            controller: PageController(viewportFraction: 0.90),
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: RecipeCardWidget(
                  externalId: recipe.contentfulId,
                  title: recipe.name,
                  imageUrl: recipe.imgUrl,
                  cookTime: recipe.preparationTime, 
                  origem: 'Contentful',

                  ingredientesJson: recipe.ingredientsJson,
                  modoPreparoJson: recipe.preparationStepsJson,

                  onTap: () {
                    print('Clicou em: ${recipe.name}');
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 4. O MÉTODO ANTIGO _buildRecipeCard FOI REMOVIDO
}