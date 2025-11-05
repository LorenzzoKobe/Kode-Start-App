// lib/widgets/recipe_card_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../config/app_theme.dart';
import '../models/receita_favorita_model.dart'; 
import '../providers/favorite_recipes_provider.dart';
import '../screens/recipe_detail_screen.dart'; 

class RecipeCardWidget extends StatelessWidget {
  final String externalId; // ID (do Contentful ou Spoonacular)
  final String title;
  final String imageUrl;
  final String? cookTime;
  final VoidCallback onTap; // Para abrir a tela de detalhes

  // Dados brutos necessários para criar um 'ReceitaFavorita'
  final String ingredientesJson;
  final String modoPreparoJson;
  final String origem; // 'Contentful' ou 'Spoonacular'

  const RecipeCardWidget({
    Key? key,
    required this.externalId,
    required this.title,
    required this.imageUrl,
    this.cookTime,
    required this.onTap,
    required this.ingredientesJson,
    required this.modoPreparoJson,
    required this.origem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos o Consumer para "ouvir" o provider de favoritos
    return Consumer<FavoriteRecipesProvider>(
      builder: (context, favProvider, child) {
        // Verificamos se esta receita já está na lista de favoritos
        final bool isFavorite = favProvider.favoriteRecipes
            .any((fav) => fav.externalId == externalId);

        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: InkWell(
            onTap: () {
              // Navega para a tela de detalhes da receita
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(
                    externalId: externalId,
                    title: title,
                    imageUrl: imageUrl,
                    cookTime: cookTime,
                    ingredientesJson: ingredientesJson,
                    modoPreparoJson: modoPreparoJson,
                    origem: origem,
                  ),
                ),
              );
            }, // Adiciona o efeito de "splash" ao tocar
          // Ação para abrir a tela de detalhes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- IMAGEM COM ÍCONES ---
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagem da Receita
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        // Placeholder enquanto carrega
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        // O que mostrar se falhar (offline e sem cache)
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      ),

                      // Botão de Favoritar (O "Coraçãozinho")
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildFavoriteButton(context, favProvider, isFavorite),
                      ),

                      // Chip de Tempo de Preparo
                      if (cookTime != null)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: _buildCookTimeChip(context, cookTime!),
                        ),
                    ],
                  ),
                ),

                // --- 2. BARRA DE TÍTULO (Fundo Pêssego) ---
                _buildTitleBar(context, title),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget para o botão de Favoritar
  Widget _buildFavoriteButton(BuildContext context, FavoriteRecipesProvider provider, bool isFavorite) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Fundo branco translúcido
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: AppTheme.favoriteIconColor,
        ),
        onPressed: () {
          // Lógica para adicionar ou remover dos favoritos
          if (isFavorite) {
            provider.removeFavorite(externalId);
          } else {
            // Objeto ReceitaFavorita para salvar no banco
            final newFavorite = ReceitaFavorita(
              externalId: externalId,
              nome: title,
              imagemUrl: imageUrl,
              tempoPreparo: cookTime,
              ingredientesJson: ingredientesJson,
              modoPreparoJson: modoPreparoJson,
              origem: origem,
            );
            provider.addFavorite(newFavorite);
          }
        },
      ),
    );
  }

  // Widget para o Chip de Tempo de Preparo
  Widget _buildCookTimeChip(BuildContext context, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppTheme.cardChipColor, // Cor pêssego/laranja do figma
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, size: 16, color: AppTheme.cardChipTextColor),
          const SizedBox(width: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.cardChipTextColor,
                ),
          ),
        ],
      ),
    );
  }

  // Widget para a Barra de Título
  Widget _buildTitleBar(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      // Cor de fundo pêssego claro, como no Figma
      color: const Color(0xFFFFEBD6), 
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 16, // Ajuste de fonte para caber
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}