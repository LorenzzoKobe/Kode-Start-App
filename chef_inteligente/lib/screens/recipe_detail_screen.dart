// lib/screens/details/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../config/app_theme.dart';
import '../../models/receita_favorita_model.dart';
import '../../providers/favorite_recipes_provider.dart';

// 1. IMPORTAR O SERVIÇO E O MODELO DE DETALHES
import '../../services/spoonacular_service.dart'; 
import '../../models/spoonacular_detail_model.dart'; 

// 2. TORNAR A TELA UM STATEFULWIDGET
class RecipeDetailScreen extends StatefulWidget {
  final String externalId;
  final String title;
  final String imageUrl;
  final String? cookTime;
  final String ingredientesJson;
  final String modoPreparoJson;
  final String origem;

  const RecipeDetailScreen({
    Key? key,
    required this.externalId,
    required this.title,
    required this.imageUrl,
    this.cookTime,
    required this.ingredientesJson,
    required this.modoPreparoJson,
    required this.origem,
  }) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // 3. CRIAR ESTADOS PARA OS DADOS
  final SpoonacularService _service = SpoonacularService();
  
  List<String> _ingredientes = [];
  List<String> _modoPreparo = [];
  
  // Estado de carregamento para Spoonacular
  bool _isLoadingDetails = false; 

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  void _loadRecipeData() async {
    // Se a origem for Contentful, os dados JSON já estão corretos (após a Correção 2).
    if (widget.origem == 'Contentful') {
      setState(() {
        _ingredientes = _parseJsonList(widget.ingredientesJson);
        _modoPreparo = _parseJsonList(widget.modoPreparoJson);
      });
    } else {
      // Se for Spoonacular, precisamos buscar os detalhes.
      setState(() {
        _isLoadingDetails = true;
      });
      
      try {
        // 4. CHAMADA DE API SECUNDÁRIA
        final details = await _service.getRecipeDetails(widget.externalId);
        
        // Atraso de 1 segundo (opcional) para vermos o loading
        // await Future.delayed(Duration(seconds: 1)); 

        setState(() {
          // Extrai os ingredientes e passos do modelo de detalhes
          _ingredientes = details.extendedIngredients
              .map((ing) => ing.original)
              .toList();
          _modoPreparo = details.analyzedInstructions.isNotEmpty
              ? details.analyzedInstructions[0].steps
                  .map((step) => step.step)
                  .toList()
              : ['Modo de preparo não disponível.'];
          _isLoadingDetails = false;
        });
      } catch (e) {
         setState(() {
           _ingredientes = ['Erro ao carregar ingredientes.'];
           _modoPreparo = ['Erro ao carregar modo de preparo.'];
           _isLoadingDetails = false;
         });
      }
    }
  }

  List<String> _parseJsonList(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Erro ao decodificar JSON: $jsonString. Erro: $e');
      return []; // Retorna vazio se o JSON for inválido
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 26,
                        ),
                  ),
                ),
                // 5. ABAS QUE AGORA DEPENDEM DO ESTADO
                _buildTabs(context, _ingredientes, _modoPreparo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      iconTheme: IconThemeData(color: AppTheme.primaryTextColor),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image, size: 50));
          },
        ),
      ),
      actions: [
        Consumer<FavoriteRecipesProvider>(
          builder: (context, favProvider, child) {
            final bool isFavorite = favProvider.favoriteRecipes
                .any((fav) => fav.externalId == widget.externalId);
            
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppTheme.favoriteIconColor,
                size: 30,
              ),
              onPressed: () {
                if (isFavorite) {
                  favProvider.removeFavorite(widget.externalId);
                } else {
                  final newFavorite = ReceitaFavorita(
                    externalId: widget.externalId,
                    nome: widget.title,
                    imagemUrl: widget.imageUrl,
                    tempoPreparo: widget.cookTime,
                    // 6. SALVANDO OS DADOS CORRETOS (se já tivermos)
                    ingredientesJson: jsonEncode(_ingredientes),
                    modoPreparoJson: jsonEncode(_modoPreparo),
                    origem: widget.origem,
                  );
                  favProvider.addFavorite(newFavorite);
                }
              },
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, List<String> ingredientes, List<String> modoPreparo) {
    
    // 7. LIDANDO COM O CARREGAMENTO DA SPOONACULAR
    if (_isLoadingDetails) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: AppTheme.primaryTextColor),
        ),
      );
    }
    
    final bool hasIngredients = ingredientes.isNotEmpty;
    final bool hasSteps = modoPreparo.isNotEmpty;

    // Se AMBOS estiverem vazios (ex: Spoonacular falhou)
    if (!hasIngredients && !hasSteps) {
       return Center(
         child: Padding(
           padding: const EdgeInsets.all(40.0),
           child: Text(
             'Os detalhes desta receita não estão disponíveis no momento.',
             textAlign: TextAlign.center,
             style: Theme.of(context).textTheme.bodyLarge,
           ),
         ),
       );
    }
    
    // O resto do código (DefaultTabController) é o mesmo...
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            labelColor: AppTheme.primaryTextColor,
            unselectedLabelColor: AppTheme.secondaryTextColor,
            indicatorColor: AppTheme.bottomNavSelectedItemColor,
            labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            tabs: const [
              Tab(text: 'Ingredientes'),
              Tab(text: 'Modo de Preparo'),
            ],
          ),
          Container(
            height: 400, // TODO: Melhorar para altura dinâmica
            padding: const EdgeInsets.all(16.0),
            child: TabBarView(
              children: [
                // --- Conteúdo da Aba 1 (Ingredientes) ---
                hasIngredients
                    ? ListView.builder(
                        itemCount: ingredientes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.check_circle_outline, color: AppTheme.bottomNavSelectedItemColor),
                            title: Text(ingredientes[index], style: Theme.of(context).textTheme.bodyLarge),
                          );
                        },
                      )
                    : const Center(child: Text('Ingredientes não disponíveis.')),
                
                // --- Conteúdo da Aba 2 (Modo de Preparo) ---
                hasSteps
                    ? ListView.builder(
                        itemCount: modoPreparo.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.bottomNavSelectedItemColor,
                                  ),
                            ),
                            title: Text(modoPreparo[index], style: Theme.of(context).textTheme.bodyLarge),
                          );
                        },
                      )
                    : const Center(child: Text('Modo de preparo não disponível.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}