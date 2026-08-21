import 'package:flutter/foundation.dart';

import '../models/market_product.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  
  int get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addProduct(MarketProduct product, [int quantity = 1]) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void checkout(String buyerId, String? clientName, String? clientPhone, String? deliveryAddress, {required Function(Order) onOrderCreated}) {
    if (_items.isEmpty) return;

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      buyerId: buyerId,
      items: _items.map((item) => OrderItem(product: item.product, quantity: item.quantity)).toList(),
      total: totalPrice,
      date: DateTime.now(),
      status: OrderStatus.validated,
      clientName: clientName,
      clientPhone: clientPhone,
      deliveryAddress: deliveryAddress,
    );

    onOrderCreated(newOrder);
    _items.clear();
    notifyListeners();
  }
}
