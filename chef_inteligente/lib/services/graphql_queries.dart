const String getFilterCategoryQuery = """
query {
  filtroPorCategoriaCollection {
    items {
      titulo
      termoDeBuscaApi
    }
  }
}
""";

const String getFilterComponentQuery = """
query {
  componenteFiltrosCollection(limit: 1) {
    items {
      titulo
            filtroCollection(limit: 10) { 
        items {
          ... on FiltroPorCategoria { 
            titulo
            termoDeBuscaApi
          }
        }
      }
    }
  }
}
""";

const String getFeaturedCarouselComponentQuery = """
query {
  componenteCarrosselCollection(limit: 1) {
    items {
      titulo
      receitasCollection(limit: 10) {
        items {
          ... on ReceitaDestaque { 
            nomeDaReceita
            imagemDaReceita {
              url
            }
          }
        }
      }
    }
  }
} 
""";