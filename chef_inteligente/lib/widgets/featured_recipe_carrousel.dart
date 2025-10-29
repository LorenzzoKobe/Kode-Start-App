import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/recipe_model.dart'; 
import '../services/graphql_queries.dart';

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
          print(result.exception.toString());
          return Container(
            height: 250,
            child: Center(child: Text("Erro ao carregar as receitas."))
          );
        }

        if (result.isLoading) {
          return Container(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final List? items = result.data?['receitaDestaqueCollection']?['items'];

        if (items == null || items.isEmpty) {
          return Container(
            height: 250,
            child: Center(child: Text("Nenhuma receita em destaque encontrada."))
          );
        }

        final List<FeaturedRecipe> recipes = items
            .map((item) => FeaturedRecipe.fromJson(item))
            .toList();

        return Container(
          height: 250,
          child: PageView.builder(
            itemCount: recipes.length,
            controller: PageController(viewportFraction: 0.90),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _buildRecipeCard(context, recipe);
            },
          ),
        );
      },
    );
  }

  Widget _buildRecipeCard(BuildContext context, FeaturedRecipe recipe) {
    return Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            
            Image.network(
              "${recipe.imageUrl}", 
              fit: BoxFit.cover,

              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },

              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey));
              },
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Color.fromRGBO(101, 101, 101, 0.608),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Text(
                  recipe.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.8))],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}