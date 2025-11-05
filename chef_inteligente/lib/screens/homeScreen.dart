import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';
import '../widgets/featured_recipe_carrousel.dart';
import '../widgets/recipe_grid_view.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar_widget.dart';
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
                padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 60.0, bottom: 8.0),
                child: Text('SMART CHEF', style: Theme.of(context).textTheme.headlineMedium),
              ),

            FeaturedRecipeCarousel(),

            FilterBar(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Text('Receitas Populares', style: Theme.of(context).textTheme.titleLarge),
            ),

            SearchBarWidget(),

            RecipeGridView(),
        ],
      ),
     );
  }
}