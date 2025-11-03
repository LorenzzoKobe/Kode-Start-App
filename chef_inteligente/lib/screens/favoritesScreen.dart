// lib/screens/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_recipes_provider.dart';
import '../../models/receita_favorita_model.dart';

// 1. IMPORTAR O NOSSO CARD PADRONIZADO
import '../../widgets/recipe_card_widget.dart'; 
import '../../config/app_theme.dart';

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
              // --- CABEÇALHO PADRONIZADO ---
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 60.0, bottom: 8.0),
                child: Text('SMART CHEF', style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, bottom: 20.0),
                child: Text('Suas Receitas Favoritas!', style: Theme.of(context).textTheme.headlineSmall),
              ),

              // --- CORPO DA TELA ---
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTextColor));
                    }
                    if (provider.errorMessage != null) {
                      return Center(child: Text('Ocorreu um erro: ${provider.errorMessage}'));
                    }
                    
                    // 2. VERIFICAR SE A LISTA ESTÁ VAZIA
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

                    // 3. CONSTRUIR O GRID COM O CARD CORRETO
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
                        
                        // 4. USANDO O RecipeCardWidget PADRONIZADO
                        return RecipeCardWidget(
                          externalId: receita.externalId,
                          title: receita.nome,
                          imageUrl: receita.imagemUrl,
                          cookTime: receita.tempoPreparo,
                          ingredientesJson: receita.ingredientesJson,
                          modoPreparoJson: receita.modoPreparoJson,
                          origem: receita.origem,
                          onTap: () {
                            // TODO: Implementar navegação para detalhes da receita
                            print('Clicou na receita: ${receita.nome}');
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