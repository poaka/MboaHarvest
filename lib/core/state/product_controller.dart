import 'package:flutter/foundation.dart';

import '../models/market_product.dart';

class ProductController extends ChangeNotifier {
  final List<MarketProduct> _products = [
    const MarketProduct(
      id: 'p1',
      name: 'Tomates fraîches',
      farmer: 'Coopérative Nkolbisson',
      location: 'Nkolbisson, Yaoundé',
      price: 850,
      unit: 'kg',
      category: 'Légumes',
      emoji: '🍅',
    ),
    const MarketProduct(
      id: 'p2',
      name: 'Plantains mûrs',
      farmer: 'Ferme Mvog-Betsi',
      location: 'Mvog-Betsi, Yaoundé',
      price: 2500,
      unit: 'régime',
      category: 'Fruits',
      emoji: '🍌',
    ),
    const MarketProduct(
      id: 'p3',
      name: 'Macabo blanc',
      farmer: 'GIC Terre fertile',
      location: 'Mbankomo',
      price: 700,
      unit: 'kg',
      category: 'Tubercules',
      emoji: '🌱',
    ),
    const MarketProduct(
      id: 'p4',
      name: 'Maïs jaune',
      farmer: 'Producteurs de Soa',
      location: 'Soa',
      price: 500,
      unit: 'kg',
      category: 'Céréales',
      emoji: '🌽',
    ),
  ];

  List<MarketProduct> get allProducts => List.unmodifiable(_products);

  void addProduct(MarketProduct product) {
    _products.add(product);
    notifyListeners();
  }

  List<MarketProduct> getProductsByFarmer(String farmerName) {
    return _products.where((p) => p.farmer == farmerName).toList();
  }
}
