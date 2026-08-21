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

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      buyerId: json['buyerId'] as String,
      items: (json['items'] as List)
          .map((i) => OrderItem.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
      total: json['total'] as int,
      date: DateTime.parse(json['date'] as String),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      clientName: json['clientName'] as String?,
      clientPhone: json['clientPhone'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'items': items.map((i) => i.toJson()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'status': status.toString(),
      'clientName': clientName,
      'clientPhone': clientPhone,
      'deliveryAddress': deliveryAddress,
    };
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

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
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
