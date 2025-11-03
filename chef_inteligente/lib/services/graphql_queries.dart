// lib/services/graphql_queries.dart

const String getFeaturedRecipesQuery = """
query {
  receitaDestaqueCollection {
    items {
      # Mantemos apenas os campos que TEMOS CERTEZA que existem
      sys {
        id 
      }
      nomeDaReceita
      imagemDaReceita {
        url
      }
      
      # Os campos errados (que eu adivinhei) foram removidos 
      # para parar o 'Erro ao carregar as receitas.'
    }
  }
}
""";

const String getFilterCategoriesQuery = """
query {
  filtroPorCategoriaCollection {
    items {
      titulo
      termoDeBuscaApi
    }
  }
}
""";