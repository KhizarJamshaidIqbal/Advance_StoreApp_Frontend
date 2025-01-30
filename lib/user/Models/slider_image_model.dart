class SliderImage {
  final String imageUrl;
  final String? title;
  final String? description;

  SliderImage({
    required this.imageUrl,
    this.title,
    this.description,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json) {
    return SliderImage(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
    };
  }
}
