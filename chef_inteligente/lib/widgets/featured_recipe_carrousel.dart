import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/recipe_model.dart'; 
import '../services/graphql_queries.dart';

class FeaturedRecipeCarousel extends StatelessWidget {
  const FeaturedRecipeCarousel({Key? key}) : super(key: key);
  
@override
  Widget build(BuildContext context) {
    // 1. O WIDGET 'QUERY'
    // Este widget faz a chamada à API automaticamente
    return Query(
      options: QueryOptions(
        document: gql(getFeaturedRecipesQuery),
      ),
      builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
        
        // 2. ESTADO DE ERRO
        if (result.hasException) {
          print(result.exception.toString()); // Útil para debug
          return Container(
            height: 250,
            child: Center(child: Text("Erro ao carregar as receitas."))
          );
        }

        // 3. ESTADO DE CARREGAMENTO (LOADING)
        if (result.isLoading) {
          // Mostra um indicador de progresso centralizado
          return Container(
            height: 250, // Dê uma altura fixa para o 'loading' não pular
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 4. ESTADO DE SUCESSO (DADOS RECEBIDOS)
        // Pega a lista de 'items' de dentro da resposta JSON
        final List? items = result.data?['receitaDestaqueCollection']?['items'];

        if (items == null || items.isEmpty) {
          return Container(
            height: 250,
            child: Center(child: Text("Nenhuma receita em destaque encontrada."))
          );
        }

        // Converte a lista de JSON (Map) para uma lista de Objetos (FeaturedRecipe)
        final List<FeaturedRecipe> recipes = items
            .map((item) => FeaturedRecipe.fromJson(item))
            .toList();

        // 5. CONSTRÓI O CARROSSEL (PageView)
        return Container(
          height: 250, // Altura fixa para o carrossel
          child: PageView.builder(
            itemCount: recipes.length,
            controller: PageController(viewportFraction: 0.85), // Mostra "pedaços" dos cards laterais
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _buildRecipeCard(context, recipe); // Chama a função que constrói o card
            },
          ),
        );
      },
    );
  }

  // Widget separado para construir cada Card do carrossel
  Widget _buildRecipeCard(BuildContext context, FeaturedRecipe recipe) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        clipBehavior: Clip.antiAlias, // Arredonda os cantos da imagem
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // IMAGEM
            Image.network(
              // ATENÇÃO: Adicionamos "https:" pois o Contentful pode omitir
              "https:${recipe.imageUrl}", 
              fit: BoxFit.cover,
              // Mostra um loading enquanto a imagem carrega
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              // Mostra um ícone de erro se a imagem falhar
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey));
              },
            ),
            
            // Gradiente para escurecer o fundo e facilitar a leitura do texto
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // TEXTO (Nome da Receita)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Text(
                recipe.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8.0, color: Colors.black.withOpacity(0.8))],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}