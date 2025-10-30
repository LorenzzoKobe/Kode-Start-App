class SpoonacularRecipe {

    final int id;
    final String title;
    final String imgUrl;

    SpoonacularRecipe({
      required this.id,
      required this.title,
      required this.imgUrl,
    });

    factory SpoonacularRecipe.fromJson(Map<String, dynamic> json) {
      return SpoonacularRecipe(
        id: json['id'],
        title: json['title'],
        imgUrl: json['image']
      );
    }
}