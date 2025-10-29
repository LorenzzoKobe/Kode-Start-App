class Recipe {

    final int id;
    final String name;
    final String imgUrl;

    Recipe({
      required this.id,
      required this.name,
      required this.imgUrl,
    });

    factory Recipe.fromJson(Map<String, dynamic> json) {
      return Recipe(
        id: json['id'],
        name: json['name'],
        imgUrl: json['image']
      );
    }
}