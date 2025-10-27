import 'package:chef_inteligente/models/recipe_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../widgets/featured_recipe_carrousel.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMART CHEF'),
      ),
      body: SingleChildScrollView( // Permite rolar a tela se o conteúdo for grande
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
            
          ],
        ),
      ),
    );
  }
}
