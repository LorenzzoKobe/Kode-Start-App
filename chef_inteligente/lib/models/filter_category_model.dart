class FilterCategory {
  final String title; // "Doces"
  final String apiSearchTerm; // "dessert"

  FilterCategory({
    required this.title,
    required this.apiSearchTerm,
  });

    factory FilterCategory.fromJson(Map<String, dynamic> json) {
      return FilterCategory(
        title: json['titulo'] ?? 'Categoria', 
        apiSearchTerm: json['termoDeBuscaApi'] ?? '',
        );
    }
}