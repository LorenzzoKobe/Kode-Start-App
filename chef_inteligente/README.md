# 🍳 SMART CHEF

> Um assistente de culinária inteligente projetado para simplificar o planejamento de refeições, oferecendo receitas curadas e uma busca inteligente por ingredientes.

Este aplicativo Flutter resolve o problema diário de "o que cozinhar com o que tenho na geladeira", permitindo ao usuário otimizar suas compras, reduzir o desperdício e descobrir novos pratos.

---

## 🚀 Funcionalidades Principais

* **Receitas em Destaque:** Exibe receitas de alta qualidade curadas e gerenciadas via Contentful (GraphQL).
* **Busca Inteligente:** Permite buscar receitas populares da API Spoonacular (REST), seja por termos de busca ou filtros de categoria.
* **Tradução Automática:** Títulos das receitas da API Spoonacular são traduzidos de inglês para português usando a API MyMemory.
* **Lista de Favoritos (Offline):** O usuário pode salvar suas receitas preferidas, que ficam armazenadas localmente em um banco de dados SQLite para acesso offline.
* **Detalhes da Receita:** Uma tela dedicada exibe ingredientes e modo de preparo, buscando detalhes adicionais da API (se necessário) ou dos dados locais/CMS.
* **Cache de API:** As receitas populares são cacheadas localmente usando `SharedPreferences` para reduzir chamadas de API e melhorar o desempenho.

## 🛠️ Tecnologias e Arquitetura

O projeto utiliza uma arquitetura limpa em camadas, separando a UI, o gerenciamento de estado e os serviços de dados.

### Arquitetura

* **Gerenciamento de Estado:** **Provider**. O estado da aplicação é gerenciado de forma reativa através de `ChangeNotifierProvider` (`AllRecipesProvider`, `FavoriteRecipesProvider`).
* **Camada de UI:** Composta por `Screens` (telas) e `Widgets` (componentes reutilizáveis).
* **Camada de Lógica:** Os `Providers` contêm a lógica de negócios, orquestrando as chamadas aos serviços e gerenciando o estado (como `loading`, `error`, `loaded`).
* **Camada de Dados:** Composta por `Services` (para chamadas de API) e `Data` (para persistência local).

### Dependências Principais

O projeto é construído com Flutter e Dart, utilizando as seguintes dependências-chave (extraído do `pubspec.yaml`):

* **Estado:** `provider`
* **APIs REST:** `http`
* **API GraphQL:** `graphql_flutter` (com `hive_flutter` para cache)
* **Banco de Dados Local:** `sqflite`, `path_provider`
* **Utilitários:** `shared_preferences` (para cache de API), `cached_network_image` (para cache de imagens)

## 🔌 Integrações de Dados

O SMART CHEF consolida dados de múltiplas fontes para criar uma experiência de usuário rica:

1.  **Contentful (GraphQL):**
    * **Função:** Fonte de dados para as "Receitas em Destaque" (curadas).
    * **Implementação:** Utiliza o pacote `graphql_flutter` para fazer queries GraphQL autenticadas.

2.  **Spoonacular (REST):**
    * **Função:** Fonte para "Receitas Populares", buscas e filtros.
    * **Implementação:** A classe `SpoonacularService` usa o pacote `http` para chamadas à API REST `/recipes/complexSearch`.

3.  **MyMemory (REST):**
    * **Função:** Tradução dos títulos das receitas do Spoonacular.
    * **Implementação:** `TranslationService` usa `http` para traduzir textos de `en` para `pt`.

4.  **SQLite (Local):**
    * **Função:** Persistência dos favoritos do usuário.
    * **Implementação:** `DatabaseHelper` (Singleton) gerencia o banco de dados `smartchef.db` e a tabela `tb_receitas_favoritas`.

5.  **SharedPreferences (Local):**
    * **Função:** Cache de curto prazo (6 horas) para as receitas populares.
    * **Implementação:** Gerenciado dentro do `AllRecipesProvider`.

## 🏁 Como Executar o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/kobe-lorenzzo/Kode-Start-App.git]
    cd chef_inteligente
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