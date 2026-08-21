import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../models/order.dart';

class OrderController extends ChangeNotifier {
  OrderController() {
    _loadOrders();
  }

  final _box = GetStorage();
  final String _storageKey = 'orders';

  List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void _loadOrders() {
    final storedOrders = _box.read<List<dynamic>>(_storageKey);
    if (storedOrders != null) {
      _orders = storedOrders.map((o) => Order.fromJson(Map<String, dynamic>.from(o))).toList();
    }
  }

  void _saveOrders() {
    final data = _orders.map((o) => o.toJson()).toList();
    _box.write(_storageKey, data);
  }

  List<Order> getOrdersForBuyer(String buyerId) {
    return _orders.where((o) => o.buyerId == buyerId).toList();
  }

  void addOrder(Order order) {
    _orders.add(order);
    _saveOrders();
    notifyListeners();
  }

  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index >= 0) {
      _orders[index] = updatedOrder;
      _saveOrders();
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: status);
      _saveOrders();
      notifyListeners();
    }
  }
}
