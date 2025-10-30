const String getFeaturedRecipesQuery = """
query {
  receitaDestaqueCollection {
    items {
      nomeDaReceita
      imagemDaReceita {
        url
      }
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