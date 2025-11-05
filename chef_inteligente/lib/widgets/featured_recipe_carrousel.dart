import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/recipe_model.dart';
import '../models/carousel_component_model.dart';
import '../services/graphql_queries.dart';
import 'recipe_card_widget.dart';
import '../screens/recipe_detail_screen.dart'; 

class FeaturedRecipeCarousel extends StatelessWidget {
  const FeaturedRecipeCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getFeaturedCarouselComponentQuery),
      ),
      builder:
          (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        
        if (result.hasException) {
          print(result.exception.toString());
          return Container(
              height: 250,
              child: Center(child: Text("Erro ao carregar o carrossel.")));
        }
        if (result.isLoading) {
          return Container(
              height: 250, child: Center(child: CircularProgressIndicator()));
        }

        final Map<String, dynamic>? item =
            result.data?['componenteCarrosselCollection']?['items']?[0];

        if (item == null) {
          return Container(
              height: 250,
              child: Center(child: Text("Nenhum carrossel encontrado.")));
        }

        final CarouselComponent carousel = CarouselComponent.fromJson(item);
        final List<FeaturedRecipe> recipes = carousel.recipes;

        if (recipes.isEmpty) {
          return Center(child: Text("Carrossel vazio."));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                carousel.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            Container(
              height: 180,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                              externalId: recipe.contentfulId,
                              title: recipe.name,
                              imageUrl: recipe.imgUrl,
                              cookTime: recipe.preparationTime,
                              ingredientesJson: recipe.ingredientsJson,
                              modoPreparoJson: recipe.preparationStepsJson,
                              origem: 'Contentful',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}