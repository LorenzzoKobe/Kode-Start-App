import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../models/filter_category_model.dart';
import '../services/graphql_queries.dart';
import '../providers/all_recipes_provider.dart';

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
      options: QueryOptions(
        document:gql(getFilterCategoriesQuery)
        ),
        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {

        if (result.isLoading) {
          return Container(height: 50, child: Center(child: CircularProgressIndicator()));
        }

        if (result.hasException) {
          return Center(child: Text("Erro ao carregar filtros."));
        }

        final List? items = result.data?['filtroPorCategoriaCollection']?['items'];

        if (items == null || items.isEmpty) {
          return Center(child: Text("Nenhum filtro encontrado."));
        }

        final List<FilterCategory> categories = items
            .map((item) => FilterCategory.fromJson(item))
            .toList();

        return Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(category.title),
                  selected: _selectedFilter == category.apiSearchTerm,
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
        );
      },
    );
  }
}