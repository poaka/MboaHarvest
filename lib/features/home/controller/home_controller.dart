import 'package:flutter/foundation.dart';

import '../models/market_product.dart';

class HomeController extends ChangeNotifier {
  static const categories = [
    'Tous',
    'Légumes',
    'Fruits',
    'Tubercules',
    'Céréales',
  ];

  static const _products = [
    MarketProduct(
      name: 'Tomates fraîches',
      farmer: 'Coopérative Nkolbisson',
      location: 'Nkolbisson, Yaoundé',
      price: 850,
      unit: 'kg',
      category: 'Légumes',
      emoji: '🍅',
    ),
    MarketProduct(
      name: 'Plantains mûrs',
      farmer: 'Ferme Mvog-Betsi',
      location: 'Mvog-Betsi, Yaoundé',
      price: 2500,
      unit: 'régime',
      category: 'Fruits',
      emoji: '🍌',
    ),
    MarketProduct(
      name: 'Macabo blanc',
      farmer: 'GIC Terre fertile',
      location: 'Mbankomo',
      price: 700,
      unit: 'kg',
      category: 'Tubercules',
      emoji: '🌱',
    ),
    MarketProduct(
      name: 'Maïs jaune',
      farmer: 'Producteurs de Soa',
      location: 'Soa',
      price: 500,
      unit: 'kg',
      category: 'Céréales',
      emoji: '🌽',
    ),
  ];

  String selectedCategory = categories.first;
  String query = '';

  List<MarketProduct> get visibleProducts {
    final normalizedQuery = query.trim().toLowerCase();
    return _products
        .where((product) {
          final matchesCategory =
              selectedCategory == categories.first ||
              product.category == selectedCategory;
          final matchesQuery =
              normalizedQuery.isEmpty ||
              product.name.toLowerCase().contains(normalizedQuery) ||
              product.location.toLowerCase().contains(normalizedQuery);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
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
