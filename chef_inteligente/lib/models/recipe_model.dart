class FeaturedRecipe {
  final String name;
  final String imageUrl;

  FeaturedRecipe({
    required this.name,
    required this.imageUrl,
  });

  factory FeaturedRecipe.fromJson(Map<String, dynamic> json) {
    
    final String name = json['nomeDaReceita'] ?? 'Receita sem nome';
    final String imageUrl = (json['imagemDaReceita'] != null && json['imagemDaReceita']['url'] != null)
        ? json['imagemDaReceita']['url']
        : 'https://via.placeholder.com/400x300.png?text=Imagem+N%C3%A3o+Dispon%C3%ADvel'; // URL reserva
    return FeaturedRecipe(
      name: name,
      imageUrl: imageUrl,
    );
  }
}
