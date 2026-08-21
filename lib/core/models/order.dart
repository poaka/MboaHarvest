import 'market_product.dart';

enum OrderStatus { pending, validated, completed, rejected }

class Order {
  Order({
    required this.id,
    required this.buyerId,
    required this.items,
    required this.total,
    required this.date,
    this.status = OrderStatus.pending,
    this.clientName,
    this.clientPhone,
    this.deliveryAddress,
  });

  final String id;
  final String buyerId;
  final List<OrderItem> items;
  final int total;
  final DateTime date;
  final OrderStatus status;
  final String? clientName;
  final String? clientPhone;
  final String? deliveryAddress;

  Order copyWith({
    String? id,
    String? buyerId,
    List<OrderItem>? items,
    int? total,
    DateTime? date,
    OrderStatus? status,
    String? clientName,
    String? clientPhone,
    String? deliveryAddress,
  }) {
    return Order(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      items: items ?? this.items,
      total: total ?? this.total,
      date: date ?? this.date,
      status: status ?? this.status,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}

class OrderItem {
  const OrderItem({
    required this.product,
    required this.quantity,
  });

  final MarketProduct product;
  final int quantity;
  
  OrderItem copyWith({
    MarketProduct? product,
    int? quantity,
  }) {
    return OrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
