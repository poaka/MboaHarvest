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
}
