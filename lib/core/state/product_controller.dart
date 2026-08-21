import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../models/market_product.dart';

class ProductController extends ChangeNotifier {
  ProductController() {
    _loadProducts();
  }

  final _box = GetStorage();
  final String _storageKey = 'products';

  List<MarketProduct> _products = [];

  List<MarketProduct> get allProducts => List.unmodifiable(_products);

  void _loadProducts() {
    final storedProducts = _box.read<List<dynamic>>(_storageKey);
    if (storedProducts != null && storedProducts.isNotEmpty) {
      _products = storedProducts.map((p) => MarketProduct.fromJson(Map<String, dynamic>.from(p))).toList();
    } else {
      _products = _defaultProducts;
      _saveProducts();
    }
  }

  void _saveProducts() {
    final data = _products.map((p) => p.toJson()).toList();
    _box.write(_storageKey, data);
  }

  void addProduct(MarketProduct product) {
    _products.add(product);
    _saveProducts();
    notifyListeners();
  }

  List<MarketProduct> getProductsByFarmer(String farmerName) {
    return _products.where((p) => p.farmer == farmerName).toList();
  }

  final List<MarketProduct> _defaultProducts = [
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
    const MarketProduct(
      id: 'p5',
      name: 'Haricots rouges',
      farmer: 'Coopérative de l\'Ouest',
      location: 'Bafoussam',
      price: 900,
      unit: 'kg',
      category: 'Légumineuses',
      emoji: '🫘',
    ),
    const MarketProduct(
      id: 'p6',
      name: 'Piment rouge',
      farmer: 'Ferme de Njombé',
      location: 'Njombé',
      price: 1200,
      unit: 'kg',
      category: 'Épices',
      emoji: '🌶️',
    ),
    const MarketProduct(
      id: 'p7',
      name: 'Poulet de chair',
      farmer: 'Ferme Avicole Obala',
      location: 'Obala',
      price: 3500,
      unit: 'pièce',
      category: 'Viandes',
      emoji: '🍗',
    ),
    const MarketProduct(
      id: 'p8',
      name: 'Carpes fraîches',
      farmer: 'Pêcheurs du Nyong',
      location: 'Akonolinga',
      price: 2000,
      unit: 'kg',
      category: 'Poissons',
      emoji: '🐟',
    ),
    const MarketProduct(
      id: 'p9',
      name: 'Lait de vache entier',
      farmer: 'Ferme Laitière de Ngaoundéré',
      location: 'Ngaoundéré',
      price: 800,
      unit: 'litre',
      category: 'Produits laitiers',
      emoji: '🥛',
    ),
    const MarketProduct(
      id: 'p10',
      name: 'Oignons',
      farmer: 'Coopérative de l\'Extrême-Nord',
      location: 'Maroua',
      price: 600,
      unit: 'kg',
      category: 'Légumes',
      emoji: '🧅',
    ),
  ];
}
