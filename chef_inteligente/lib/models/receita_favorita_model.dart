

class ReceitaFavorita {
  int? id;
  String externalId;
  String origem;
  String nome;
  String imagemUrl;
  String? tempoPreparo;
  String ingredientesJson;
  String modoPreparoJson;
  String? dataFavoritado;

  ReceitaFavorita({
    this.id,
    required this.externalId,
    required this.origem,
    required this.nome,
    required this.imagemUrl,
    this.tempoPreparo,
    required this.ingredientesJson,
    required this.modoPreparoJson,
    this.dataFavoritado,
  });

  factory ReceitaFavorita.fromMap(Map<String, dynamic> map) {
    return ReceitaFavorita(
      id: map['id'] as int?,
      externalId: map['external_id'] as String,
      origem: map['origem'] as String,
      nome: map['nome'] as String,
      imagemUrl: map['imagem_url'] as String,
      tempoPreparo: map['tempo_preparo'] as String?,
      ingredientesJson: map['ingredientes_json'] as String,
      modoPreparoJson: map['modo_preparo_json'] as String,
      dataFavoritado: map['data_favoritado'] as String?,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'external_id': externalId,
      'origem': origem,
      'nome': nome,
      'imagem_url': imagemUrl,
      'tempo_preparo': tempoPreparo,
      'ingredientes_json': ingredientesJson,
      'modo_preparo_json': modoPreparoJson,
    };
  }
}