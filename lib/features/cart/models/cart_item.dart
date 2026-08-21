import '../../../core/models/market_product.dart';

class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
  });

  final MarketProduct product;
  int quantity;

  int get totalPrice => product.price * quantity;
}
