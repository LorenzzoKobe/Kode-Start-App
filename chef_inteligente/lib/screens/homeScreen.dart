import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/featured_recipe_carrousel.dart';
import '../widgets/recipe_grid_view.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar_widget.dart';

import 'package:provider/provider.dart';
import '../providers/all_recipes_provider.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Receitas em Destaque',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          
          FeaturedRecipeCarousel(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0), // Adiciona espaço
            child: Text(
              'Categorias',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          FilterBar(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
            child: Text(
              'Receitas Populares',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          SearchBarWidget(),

          RecipeGridView(),
        ],
      ),
    );
  }
}
