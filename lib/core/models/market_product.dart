class MarketProduct {
  const MarketProduct({
    required this.id,
    required this.name,
    required this.farmer,
    required this.location,
    required this.price,
    required this.unit,
    required this.category,
    required this.emoji,
  });

  final String id;
  final String name;
  final String farmer;
  final String location;
  final int price;
  final String unit;
  final String category;
  final String emoji;

  factory MarketProduct.fromJson(Map<String, dynamic> json) {
    return MarketProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      farmer: json['farmer'] as String,
      location: json['location'] as String,
      price: json['price'] as int,
      unit: json['unit'] as String,
      category: json['category'] as String,
      emoji: json['emoji'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'farmer': farmer,
      'location': location,
      'price': price,
      'unit': unit,
      'category': category,
      'emoji': emoji,
    };
  }
}
