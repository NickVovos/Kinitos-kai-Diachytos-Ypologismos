class RecipeImage {
  final int id;
  final String name;
  final String data;

  RecipeImage({
    required this.id,
    required this.name,
    required this.data,
  });

  factory RecipeImage.fromJson(Map<String, dynamic> json) {
    return RecipeImage(
      id: json['id'],
      name: json['name'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data': data,
    };
  }
}
