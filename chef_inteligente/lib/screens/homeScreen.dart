// lib/screens/homeScreen.dart

// 1. Import do Material é necessário para o Scaffold e o Theme
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';

// 2. Imports dos widgets
import '../widgets/featured_recipe_carrousel.dart';
import '../widgets/recipe_grid_view.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar_widget.dart';

// 3. Import do Provider 
import '../providers/all_recipes_provider.dart';

// 4. Import do Tema
import '../config/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllRecipesProvider>(context, listen: false)
          .fetchAllRecipes(filterTerm: null, search: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold que estava faltando
    return Scaffold(
      // O SingleChildScrollView agora fica dentro do body
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Cabeçalho padronizado AQUI
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 16.0, top: 60.0, bottom: 8.0), // Padding para a status bar
              child: Text(
                'SMART CHEF',
                style: Theme.of(context).textTheme.headlineMedium, // Estilo do AppTheme
              ),
            ),
            SearchBarWidget(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Receitas em Destaque',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            FeaturedRecipeCarousel(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Text(
                'Categorias',
                // Padronizando títulos de seção
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            FilterBar(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Text(
                'Receitas Populares',
                // Padronizando títulos de seção
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            RecipeGridView(),
          ],
        ),
      ),
    );
  }
}