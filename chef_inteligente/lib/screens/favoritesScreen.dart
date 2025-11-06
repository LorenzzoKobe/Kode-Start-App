import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_recipes_provider.dart';
import '../../widgets/recipe_card_widget.dart'; 
import '../../config/app_theme.dart';
import '../screens/recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavoriteRecipesProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 60.0, bottom: 8.0),
                child: Text('SMART CHEF', style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, bottom: 20.0),
                child: Text('Suas Receitas Favoritas!', style: Theme.of(context).textTheme.headlineSmall),
              ),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTextColor));
                    }
                    if (provider.errorMessage != null) {
                      return Center(child: Text('Ocorreu um erro: ${provider.errorMessage}'));
                    }
                    
                    if (provider.favoriteRecipes.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            'Você ainda não salvou nenhuma receita favorita. Que tal explorar a Home?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.secondaryTextColor, height: 1.5,
                                ),
                          ),
                        ),
                      );
                    }

                    final recipes = provider.favoriteRecipes;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final receita = recipes[index];
                        
                        return RecipeCardWidget(
                          externalId: receita.externalId,
                          title: receita.nome,
                          imageUrl: receita.imagemUrl,
                          cookTime: receita.tempoPreparo,
                          ingredientesJson: receita.ingredientesJson,
                          modoPreparoJson: receita.modoPreparoJson,
                          origem: receita.origem,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  externalId: receita.externalId,
                                  title: receita.nome,
                                  imageUrl: receita.imagemUrl,
                                  cookTime: receita.tempoPreparo,
                                  // Passando os dados salvos do banco:
                                  ingredientesJson: receita.ingredientesJson,
                                  modoPreparoJson: receita.modoPreparoJson,
                                  origem: receita.origem,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}