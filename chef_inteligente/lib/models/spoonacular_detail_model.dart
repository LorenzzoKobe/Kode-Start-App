
class SpoonacularDetail {
  final List<Ingredient> extendedIngredients;
  final List<AnalyzedInstruction> analyzedInstructions;

  SpoonacularDetail({
    required this.extendedIngredients,
    required this.analyzedInstructions,
  });

  factory SpoonacularDetail.fromJson(Map<String, dynamic> json) {
    var ingredientsList = json['extendedIngredients'] as List? ?? [];
    List<Ingredient> ingredients = ingredientsList
        .map((i) => Ingredient.fromJson(i))
        .toList();

    var instructionsList = json['analyzedInstructions'] as List? ?? [];
    List<AnalyzedInstruction> instructions = instructionsList
        .map((i) => AnalyzedInstruction.fromJson(i))
        .toList();

    return SpoonacularDetail(
      extendedIngredients: ingredients,
      analyzedInstructions: instructions,
    );
  }
}

class Ingredient {
  final String original;

  Ingredient({required this.original});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      original: json['original'] as String? ?? 'Ingrediente não encontrado',
    );
  }
}

class AnalyzedInstruction {
  final List<InstructionStep> steps;

  AnalyzedInstruction({required this.steps});

  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) {
    var stepsList = json['steps'] as List? ?? [];
    List<InstructionStep> steps =
        stepsList.map((s) => InstructionStep.fromJson(s)).toList();
    return AnalyzedInstruction(steps: steps);
  }
}

class InstructionStep {
  final int number;
  final String step; // "Mix sugar and flour..."

  InstructionStep({required this.number, required this.step});

  factory InstructionStep.fromJson(Map<String, dynamic> json) {
    return InstructionStep(
      number: json['number'] as int? ?? 0,
      step: json['step'] as String? ?? 'Passo não encontrado',
    );
  }
}