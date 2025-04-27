class WardrobeItem {
  final String id;
  final String name;
  final String type;
  final String imageUrl;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      imageUrl: json['imageUrl'],
    );
  }
}