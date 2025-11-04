// lib/widgets/featured_recipe_carrousel.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/recipe_model.dart'; 
import '../services/graphql_queries.dart';

// 1. IMPORTE O NOSSO CARD PADRONIZADO
import 'recipe_card_widget.dart';
// 2. IMPORTE A TELA DE DETALHES (que vamos criar em breve)
// import '../screens/details/details_screen.dart'; // TODO: Descomentar depois

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

              // 3. USANDO O NOVO RECIPECARDWIDGET
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0), // Espaço entre os cards do carrossel
                child: RecipeCardWidget(
                  externalId: recipe.contentfulId, // ID do Contentful
                  title: recipe.name,
                  imageUrl: recipe.imgUrl,
                  cookTime: recipe.preparationTime, // O Contentful fornece o tempo
                  origem: 'Contentful', // Marcamos a origem

                  // O Contentful fornece os detalhes
                  ingredientesJson: recipe.ingredientsJson ?? '[]',
                  modoPreparoJson: recipe.preparationStepsJson ?? '[]',

                  onTap: () {
                    // TODO: Ação da Tarefa 3 (Abrir Tela de Detalhes)
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) => DetailsScreen(recipe: recipe),
                    // ));
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