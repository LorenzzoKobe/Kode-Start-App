/// Modelo para a tabela `tb_receitas_favoritas`
class ReceitaFavorita {
  int? id; // O ID local do SQLite (auto-incrementado)
  String externalId; // O ID que vem da API (Contentful ou Spoonacular)
  String origem; // "Contentful" ou "Spoonacular"
  String nome;
  String imagemUrl;
  String? tempoPreparo; // Nullable, caso a API não forneça
  String? calorias; // Nullable
  String ingredientesJson; // Armazena a lista de ingredientes como uma string JSON
  String modoPreparoJson; // Armazena os passos do preparo como uma string JSON
  String? dataFavoritado; // O SQLite vai preencher com o timestamp

  ReceitaFavorita({
    this.id,
    required this.externalId,
    required this.origem,
    required this.nome,
    required this.imagemUrl,
    this.tempoPreparo,
    this.calorias,
    required this.ingredientesJson,
    required this.modoPreparoJson,
    this.dataFavoritado,
  });

  /// Converte um objeto Map (vindo do SQLite) para um objeto ReceitaFavorita.
  factory ReceitaFavorita.fromMap(Map<String, dynamic> map) {
    return ReceitaFavorita(
      id: map['id'] as int?,
      externalId: map['external_id'] as String,
      origem: map['origem'] as String,
      nome: map['nome'] as String,
      imagemUrl: map['imagem_url'] as String,
      tempoPreparo: map['tempo_preparo'] as String?,
      calorias: map['calorias'] as String?,
      ingredientesJson: map['ingredientes_json'] as String,
      modoPreparoJson: map['modo_preparo_json'] as String,
      dataFavoritado: map['data_favoritado'] as String?,
    );
  }

  /// Converte um objeto ReceitaFavorita para um Map (para salvar no SQLite).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'external_id': externalId,
      'origem': origem,
      'nome': nome,
      'imagem_url': imagemUrl,
      'tempo_preparo': tempoPreparo,
      'calorias': calorias,
      'ingredientes_json': ingredientesJson,
      'modo_preparo_json': modoPreparoJson,
    };
  }
}
