class FeaturedRecipe {
  final String name;
  final String imgUrl;
  final String contentfulId;
  final String preparationTime;
  final String ingredientsJson;
  final String preparationStepsJson;

  FeaturedRecipe({
    required this.name,
    required this.imgUrl,
    required this.contentfulId,
    required this.preparationTime,
    required this.ingredientsJson,
    required this.preparationStepsJson,
  });

  factory FeaturedRecipe.fromJson(Map<String, dynamic> json) {
    
    final String name = json['nomeDaReceita'] ?? 'Receita sem nome';
    final String imgUrl = (json['imagemDaReceita'] != null && json['imagemDaReceita']['url'] != null)
        ? json['imagemDaReceita']['url']
        : 'https://via.placeholder.com/400x300.png?text=Imagem+N%C3%A3o+Dispon%C3%ADvel';
    final String contentfulId = json['sys']?['id'] ?? '';
    
    final String preparationTime = json['tempoDePreparo'] ?? '0';
    final String ingredientsJson = json['ingredientes'] ?? '[]';
    final String preparationStepsJson = json['modoDePreparo'] ?? '[]';
    
    return FeaturedRecipe(
      name: name,
      imgUrl: imgUrl,
      contentfulId: contentfulId,
      preparationTime: preparationTime,
      ingredientsJson: ingredientsJson,
      preparationStepsJson: preparationStepsJson,
    );
  }
}