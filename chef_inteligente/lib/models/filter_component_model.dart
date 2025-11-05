import 'filter_category_model.dart';

class FilterComponent {
  final String title;
  final List<FilterCategory> filters;

  FilterComponent({
    required this.title,
    required this.filters,
  });

  factory FilterComponent.fromJson(Map<String, dynamic> json) {
    final String title = json['titulo'] ?? 'Categorias';

    final List filtersList = json['filtroCollection']?['items'] ?? [];
    
    final List<FilterCategory> filters = filtersList
        .map((item) => FilterCategory.fromJson(item))
        .toList();

    return FilterComponent(
      title: title,
      filters: filters,
    );
  }
}