class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'icon': icon,
    };
  }
}
