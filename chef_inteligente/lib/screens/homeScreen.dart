// lib/screens/homeScreen.dart
import 'package:flutter/material.dart';
// import 'package:chef_inteligente/models/recipe_model.dart';
// import '../widgets/featured_recipe_carrousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usei a mesma estrutura da FavoritesScreen para consistência
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // --- CABEÇALHO DA TELA (PADRONIZADO) ---

          // 1. Título da Marca (Smart Chef)
          Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 16.0, top: 60.0, bottom: 8.0),
            child: Text(
              'SMART CHEF',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          // 2. Título da Seção (Receitas em Destaque)
          Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 16.0, bottom: 20.0),
            child: Text(
              'Receitas em Destaque',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // --- CORPO DA TELA (COM A CORREÇÃO) ---

          // O 'Expanded' foi removido daqui de fora.
          // O 'SingleChildScrollView' também foi removido (por enquanto).

          // Adicionei um Expanded aqui para que o conteúdo (Center)
          // preencha o restante do espaço da Column principal.
          Expanded(
            child: Center(
              child: Text(
                'Erro ao carregar as receitas.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
              ),
            ),
          ),

          // O 'FeaturedRecipeCarousel()' virá aqui no lugar do Center
          // ou abaixo dele.
        ],
      ),
    );
  }
}
