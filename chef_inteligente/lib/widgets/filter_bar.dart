import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../models/filter_category_model.dart';
import '../services/graphql_queries.dart';
import '../providers/all_recipes_provider.dart';

// 1. IMPORTE O NOSSO TEMA
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
      options: QueryOptions(document: gql(getFilterCategoriesQuery)),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return Container(
              height: 50, child: Center(child: CircularProgressIndicator()));
        }

        if (result.hasException) {
          return Center(child: Text("Erro ao carregar filtros."));
        }

        final List? items =
            result.data?['filtroPorCategoriaCollection']?['items'];

        if (items == null || items.isEmpty) {
          return Center(child: Text("Nenhum filtro encontrado."));
        }

        final List<FilterCategory> categories =
            items.map((item) => FilterCategory.fromJson(item)).toList();

        return Container(
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

                  // --- 2. ESTILIZAÇÃO ADICIONADA AQUI ---

                  // Cor do chip quando NÃO selecionado
                  backgroundColor: AppTheme.cardBackgroundColor, // Branco

                  // Cor do chip QUANDO selecionado
                  selectedColor: AppTheme.cardChipColor, // Cor Pêssego/Laranja

                  // Cor do texto QUANDO selecionado
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.cardChipTextColor // Marrom Escuro
                        : AppTheme.primaryTextColor, // Marrom Escuro
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  
                  // Cor do ícone de check (o 'tick' ao lado de 'Geral')
                  checkmarkColor: AppTheme.cardChipTextColor,

                  // Estilo da borda
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.cardChipColor // Borda Laranja
                          : AppTheme.secondaryTextColor.withOpacity(0.5), // Borda cinza/marrom clara
                    ),
                  ),
                  
                  // --- FIM DA ESTILIZAÇÃO ---

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