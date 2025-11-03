// lib/screens/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_recipes_provider.dart';
  import '../../widgets/recipe_favorite_card.dart';
import '../../config/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Consumer<FavoriteRecipesProvider>(
        builder: (context, provider, child) {
          return Column( // Column para ter o título acima da lista/mensagem
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1. Título da Marca (Smart Chef)
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 60.0, bottom: 8.0), // Padding superior (safe area)
                child: Text(
                  'Smart Chef',
                  style: Theme.of(context).textTheme.headlineMedium, // O estilo maior (definido no AppTheme)
                ),
              ),

              // --- TÍTULO DA TELA (replicando o Figma) ---
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, bottom: 20.0), // Ajuste o top para não sobrepor a 'notch'
                child: Text(
                  'Suas Receitas Favoritas!',
                  style: Theme.of(context).textTheme.headlineSmall, // Usando o estilo definido no tema
                ),
              ),

              // --- RESTO DO CORPO DA TELA (Carregamento, Erro, Vazio, Conteúdo) ---
              Expanded( // O resto do conteúdo expande para preencher o espaço restante
                child: Builder(
                  builder: (context) {
                    // --- ESTADO DE CARREGAMENTO ---
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppTheme.primaryTextColor), // Cor do spinner
                      );
                    }

                    // --- ESTADO DE ERRO ---
                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text(
                          'Ocorreu um erro: ${provider.errorMessage}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
                        ),
                      );
                    }

                    // --- ESTADO VAZIO (Ajustado) ---
                    if (provider.favoriteRecipes.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            'Você ainda não salvou nenhuma receita favorita. Que tal explorar a Home?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.secondaryTextColor, // Cor marrom mais claro
                                  height: 1.5, // Espaçamento entre linhas
                                ),
                          ),
                        ),
                      );
                    }

                    // --- ESTADO COM DADOS (SUCESSO) ---
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
                        return RecipeFavoriteCard(
                          receita: receita,
                          onRemoveFavorite: () {
                            provider.removeFavorite(receita.externalId);
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
