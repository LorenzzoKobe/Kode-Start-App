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
            sys {
              id
            }
            nomeDaReceita
            imagemDaReceita {
              url
            }
            tempoDePreparo
            ingredientes
            modoDePreparo
          }
        }
      }
    }
  }
} 
""";