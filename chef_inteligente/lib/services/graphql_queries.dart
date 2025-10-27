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