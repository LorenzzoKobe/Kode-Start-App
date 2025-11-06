import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../models/filter_category_model.dart';
import '../models/filter_component_model.dart';
import '../services/graphql_queries.dart';
import '../providers/all_recipes_provider.dart';
import '../config/app_theme.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String _selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(getFilterComponentQuery)),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return Container(
              height: 100, child: Center(child: CircularProgressIndicator()));
        }

        if (result.hasException) {
          print('### ERRO GRAPHQL FilterBar: ${result.exception.toString()}');
          return Center(child: Text("Erro ao carregar filtros."));
        }

        final Map<String, dynamic>? item =
            result.data?['componenteFiltrosCollection']?['items']?[0];

        if (item == null) {
          return Center(child: Text("Nenhum componente de filtro encontrado."));
        }

        final FilterComponent filterComponent = FilterComponent.fromJson(item);
        final List<FilterCategory> categories = filterComponent.filters;

        if (categories.isEmpty) {
          return Center(child: Text("Nenhum filtro encontrado."));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Text(
                filterComponent.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final bool isSelected = _selectedFilter == category.apiSearchTerm;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category.title),
                      selected: isSelected,
                      backgroundColor: AppTheme.cardBackgroundColor,
                      selectedColor: AppTheme.cardChipColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppTheme.cardChipTextColor
                            : AppTheme.primaryTextColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      checkmarkColor: AppTheme.cardChipTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.cardChipColor
                              : AppTheme.secondaryTextColor.withOpacity(0.5),
                        ),
                      ),
                      onSelected: (bool selected) {
                        final newTerm = category.apiSearchTerm;
                        setState(() {
                          _selectedFilter = category.apiSearchTerm;
                        });

                        Provider.of<AllRecipesProvider>(context, listen: false)
                            .fetchAllRecipes(filterTerm: newTerm, search: null);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}