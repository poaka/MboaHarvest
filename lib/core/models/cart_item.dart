import 'market_product.dart';

class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
  });

  final MarketProduct product;
  int quantity;

  int get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: MarketProduct.fromJson(Map<String, dynamic>.from(json['product'])),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
