import 'package:flutter/foundation.dart';

import '../../../core/models/market_product.dart';

class HomeController extends ChangeNotifier {
  static const categories = [
    'Tous',
    'Légumes',
    'Fruits',
    'Tubercules',
    'Céréales',
    'Légumineuses',
    'Épices',
    'Viandes',
    'Poissons',
    'Produits laitiers',
  ];

  String selectedCategory = categories.first;
  String query = '';

  List<MarketProduct> getVisibleProducts(List<MarketProduct> allProducts) {
    final normalizedQuery = query.trim().toLowerCase();
    return allProducts.where((product) {
      final matchesCategory =
          selectedCategory == categories.first ||
          product.category == selectedCategory;
      final matchesQuery =
          normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.location.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }

  void selectCategory(String value) {
    if (value == selectedCategory) return;
    selectedCategory = value;
    notifyListeners();
  }

  void search(String value) {
    query = value;
    notifyListeners();
  }
}
