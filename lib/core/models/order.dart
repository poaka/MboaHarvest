import 'market_product.dart';

enum OrderStatus { pending, validated, completed }

class Order {
  Order({
    required this.id,
    required this.buyerId,
    required this.items,
    required this.total,
    required this.date,
    this.status = OrderStatus.pending,
  });

  final String id;
  final String buyerId;
  final List<OrderItem> items;
  final int total;
  final DateTime date;
  OrderStatus status;
}

class OrderItem {
  const OrderItem({
    required this.product,
    required this.quantity,
  });

  final MarketProduct product;
  final int quantity;
}
