# 🍳 SMART CHEF

> Um assistente de culinária inteligente projetado para simplificar a **descoberta** de refeições, oferecendo receitas curadas e uma busca poderosa por pratos populares.

Este aplicativo Flutter resolve o problema diário de "o que cozinhar?", combinando receitas de alta qualidade (gerenciadas por CMS) com um vasto catálogo de receitas populares (API), permitindo ao usuário descobrir, salvar e cozinhar novos pratos.

---

## 🚀 Funcionalidades Principais

* **Receitas em Destaque:** Exibe receitas de alta qualidade curadas e gerenciadas via **Contentful (GraphQL)**, exibidas num carrossel na Home.
* **Filtros Dinâmicos:** Carrega uma barra de filtros (ex: Salgadas, Doces) **diretamente do Contentful**, permitindo que as categorias de busca sejam gerenciadas remotamente.
* **Busca Popular:** Permite buscar receitas populares da **API Spoonacular (REST)**, seja por termos de busca (`SearchBarWidget`) ou pelos filtros de categoria.
* **Tradução Automática:** Títulos das receitas da API Spoonacular são traduzidos de inglês para português usando a API MyMemory.
* **Lista de Favoritos (Offline Total):**
    * O usuário pode salvar suas receitas preferidas (tanto do Contentful quanto do Spoonacular) em um banco de dados **SQLite** local.
    * **Sincronização de Detalhes:** Ao visualizar ou favoritar uma receita da API pela primeira vez, os detalhes (ingredientes, preparo) são baixados e **salvos no banco local**, garantindo acesso 100% offline aos detalhes da receita favorita.
* **Cache de API:** As receitas populares (a chamada principal) são cacheadas localmente usando `SharedPreferences` para reduzir chamadas de API e melhorar o desempenho na inicialização.

## 🛠️ Tecnologias e Arquitetura

O projeto utiliza uma arquitetura limpa em camadas, separando a UI, o gerenciamento de estado e os serviços de dados.

### Arquitetura

* **Gerenciamento de Estado:** **Provider**. O estado da aplicação é gerenciado de forma reativa através de `ChangeNotifierProvider` (`AllRecipesProvider`, `FavoriteRecipesProvider`).
* **Camada de UI:** Composta por `Screens` (telas) e `Widgets` (componentes reutilizáveis).
* **Camada de Lógica:** Os `Providers` contêm a lógica de negócios, orquestrando as chamadas aos serviços e gerenciando o estado (como `loading`, `error`, `loaded`).
* **Camada de Dados:** Composta por `Services` (para chamadas de API) e `Data` (para persistência local).

### Dependências Principais

* **Estado:** `provider`
* **APIs REST:** `http`
* **API GraphQL:** `graphql_flutter` (com `hive_flutter` para cache)
* **Banco de Dados Local:** `sqflite`, `path_provider`
* **Utilitários:** `shared_preferences` (para cache de API), `cached_network_image` (para cache de imagens), `connectivity_plus` (para verificação de rede).

## 🔌 Integrações de Dados

O SMART CHEF consolida dados de múltiplas fontes para criar uma experiência de usuário rica:

1.  **Contentful (GraphQL):**
    * **Função:** Fonte de dados para as "Receitas em Destaque" e para os "Filtros de Categoria".
    * **Implementação:** Utiliza o pacote `graphql_flutter` (via `Query` widgets) para fazer queries GraphQL autenticadas.

2.  **Spoonacular (REST):**
    * **Função:** Fonte para "Receitas Populares", buscas e detalhes de receitas.
    * **Implementação:** A classe `SpoonacularService` usa o pacote `http` para chamadas à API REST.

3.  **MyMemory (REST):**
    * **Função:** Tradução dos títulos das receitas do Spoonacular.
    * **Implementação:** `TranslationService` usa `http` para traduzir textos de `en` para `pt`.

4.  **SQLite (Local):**
    * **Função:** Persistência dos favoritos do usuário.
    * **Implementação:** `DatabaseHelper` (Singleton) gerencia o banco `smartchef.db` e a tabela `tb_receitas_favoritas`. A tabela é projetada para salvar não apenas a referência, mas também o **JSON dos ingredientes e do modo de preparo**, permitindo a funcionalidade offline.

5.  **SharedPreferences (Local):**
    * **Função:** Cache de curto prazo (6 horas) para as receitas populares (chamada `/complexSearch`).
    * **Implementação:** Gerenciado dentro do `AllRecipesProvider`.

## 🏁 Como Executar o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone [URL-DO-SEU-REPOSITORIO]
    cd [NOME-DA-PASTA-DO-PROJETO]
    ```

2.  **Configure as Chaves de API:**
    As chaves de API estão centralizadas no arquivo `lib/services/api_keys.dart`. Certifique-se de que as constantes (`contentfulSpaceId`, `contentfulAccessToken`, `spoonacularApiKey`) estão corretas.

3.  **Instale as Dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute o Aplicativo:**
    ```bash
    flutter run
    ```