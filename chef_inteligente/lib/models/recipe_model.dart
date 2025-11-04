import 'dart:convert';

class FeaturedRecipe {
  final String name;
  final String imgUrl;
  final String contentfulId;
  final String preparationTime;
  final String ingredientsJson;
  final String preparationStepsJson;

  FeaturedRecipe({
    required this.name,
    required this.imgUrl,
    required this.contentfulId,
    required this.preparationTime,
    required this.ingredientsJson,
    required this.preparationStepsJson,
  });

  factory FeaturedRecipe.fromJson(Map<String, dynamic> json) {
    
    final String name = json['nomeDaReceita'] ?? 'Receita sem nome';
    final String imgUrl = (json['imagemDaReceita'] != null && json['imagemDaReceita']['url'] != null)
        ? json['imagemDaReceita']['url']
        : 'https://via.placeholder.com/400x300.png?text=Imagem+N%C3%A3o+Dispon%C3%ADvel';
    final String contentfulId = json['sys']?['id'] ?? '';

    // --- LÓGICA DE MOCK (Injeção de Dados) ---
    
    String preparationTime = '0';
    String ingredientsJson = '[]';
    String preparationStepsJson = '[]';

    if (name == 'Lasanha') {
      preparationTime = '60';
      ingredientsJson = jsonEncode([
        '500g de massa de lasanha',
        '500g de carne moída',
        '2 caixas de molho de tomate',
        '1 cebola picada',
        '2 dentes de alho picados',
        '500g de queijo muçarela',
        '400g de presunto',
        'Sal e pimenta a gosto'
      ]);
      preparationStepsJson = jsonEncode([
        'Cozinhe a massa da lasanha conforme as instruções da embalagem.',
        'Refogue a cebola e o alho, adicione a carne moída e cozinhe até dourar.',
        'Adicione o molho de tomate, sal, pimenta e cozinhe por 10 minutos.',
        'Em um refratário, alterne camadas de molho, massa, presunto e queijo.',
        'Repita as camadas, terminando com queijo muçarela.',
        'Leve ao forno pré-aquecido a 180°C por 25-30 minutos.'
      ]);
    } 
    
    else if (name == 'Brownie') {
      preparationTime = '40';
      ingredientsJson = jsonEncode([
        '200g de chocolate meio amargo',
        '100g de manteiga',
        '1 xícara de açúcar',
        '3 ovos',
        '1 xícara de farinha de trigo',
        '1/2 xícara de nozes picadas (opcional)'
      ]);
      preparationStepsJson = jsonEncode([
        'Derreta o chocolate e a manteiga em banho-maria.',
        'Em outra tigela, bata os ovos com o açúcar até ficar fofo.',
        'Incorpore a mistura de chocolate derretido aos ovos.',
        'Adicione a farinha de trigo (e as nozes) e misture delicadamente.',
        'Despeje em uma forma untada e asse a 180°C por 25-30 minutos.'
      ]);
    } 
    
    else if (name == 'Bolo de Cenoura') {
      preparationTime = '50';
      ingredientsJson = jsonEncode([
        '3 cenouras médias raladas',
        '4 ovos',
        '1/2 xícara de óleo',
        '2 xícaras de açúcar',
        '2 xícaras de farinha de trigo',
        '1 colher (sopa) de fermento em pó',
        'Cobertura: 1 colher (sopa) de manteiga',
        'Cobertura: 3 colheres (sopa) de chocolate em pó',
        'Cobertura: 1 xícara de açúcar',
        'Cobertura: 1/4 xícara de leite'
      ]);
      preparationStepsJson = jsonEncode([
        'No liquidificador, bata as cenouras, os ovos e o óleo.',
        'Transfira para uma tigela e misture o açúcar e a farinha.',
        'Adicione o fermento e misture delicadamente.',
        'Asse em forma untada a 180°C por cerca de 40 minutos.',
        'Para a cobertura, misture tudo em uma panela e cozinhe em fogo baixo até engrossar.',
        'Despeje a cobertura sobre o bolo ainda quente.'
      ]);
    }
    // --- FIM DA LÓGICA DE MOCK ---

    
    return FeaturedRecipe(
      name: name,
      imgUrl: imgUrl,
      contentfulId: contentfulId,
      preparationTime: preparationTime,
      ingredientsJson: ingredientsJson,
      preparationStepsJson: preparationStepsJson,
    );
  }
}