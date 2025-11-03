// lib/widgets/recipe_favorite_card.dart
import 'package:flutter/material.dart';
import '../models/receita_favorita_model.dart';
import '../config/app_theme.dart';

class RecipeFavoriteCard extends StatelessWidget {
  final ReceitaFavorita receita;
  final VoidCallback? onRemoveFavorite;

  const RecipeFavoriteCard({
    super.key,
    required this.receita,
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardBackgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.network(
                  receita.imagemUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                    );
                  },
                ),
                if (onRemoveFavorite != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: AppTheme.favoriteIconColor), // Usando a cor definida no tema
                      onPressed: onRemoveFavorite,
                      tooltip: 'Remover dos favoritos',
                    ),
                  ),
                // Adicionando o chip de tempo de preparo
                if (receita.tempoPreparo != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: AppTheme.cardChipColor, // Cor do chip
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 16, color: AppTheme.cardChipTextColor), // Ícone do timer
                          const SizedBox(width: 4),
                          Text(
                            receita.tempoPreparo!,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppTheme.cardChipTextColor, // Cor do texto do chip
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              receita.nome,
              style: Theme.of(context).textTheme.titleLarge, // Usar estilo de título
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Removido o tempo de preparo daqui, pois ele agora está como um chip na imagem
        ],
      ),
    );
  }
}