import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/all_recipes_provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar Por Receitas...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none, // Sem borda preta
          ),

          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[700]
              : Colors.grey[200],

          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        ),
        onSubmitted: (String value) { 
          debugPrint('Pesquisando por: $value');

          Provider.of<AllRecipesProvider>(context, listen: false)
          .fetchAllRecipes(filterTerm: null, search: value);
        },
      ),
    );
  }
}