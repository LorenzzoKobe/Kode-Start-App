class FeaturedRecipe {
  final String name;
  final String imgUrl;

  FeaturedRecipe({
    required this.name,
    required this.imgUrl,
  });

  factory FeaturedRecipe.fromJson(Map<String, dynamic> json) {
    
    final String name = json['nomeDaReceita'] ?? 'Receita sem nome';
    final String imgUrl = (json['imagemDaReceita'] != null && json['imagemDaReceita']['url'] != null)
        ? json['imagemDaReceita']['url']
        : 'https://via.placeholder.com/400x300.png?text=Imagem+N%C3%A3o+Dispon%C3%ADvel'; // URL reserva
    return FeaturedRecipe(
      name: name,
      imgUrl: imgUrl,
    );
  }
}
