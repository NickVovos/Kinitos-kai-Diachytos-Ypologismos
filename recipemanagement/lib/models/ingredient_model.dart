class IngredientModel {
  String name;
  String quantity;

  IngredientModel({
    required this.name,
    required this.quantity,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'],
      quantity: json['quantity'],
    );
  }
}
