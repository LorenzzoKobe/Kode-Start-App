import 'recipe_model.dart';

class CarouselComponent {
  final String title;
  final List<FeaturedRecipe> recipes;

  CarouselComponent({
    required this.title,
    required this.recipes,
  });

  factory CarouselComponent.fromJson(Map<String, dynamic> json) {
    final String title = json['titulo'] ?? 'Carrossel';

    final List recipesList = json['receitasCollection']?['items'] ?? [];
    
    final List<FeaturedRecipe> recipes = recipesList
        .map((item) => FeaturedRecipe.fromJson(item))
        .toList();

    return CarouselComponent(
      title: title,
      recipes: recipes,
    );
  }
}