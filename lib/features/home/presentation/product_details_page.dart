import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/market_product.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/controller/cart_controller.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({required this.product, super.key});

  final MarketProduct product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1E8),
                          shape: BoxShape.circle,
                        ),
                        child: Text(product.emoji, style: const TextStyle(fontSize: 60)),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${product.price} FCFA / ${product.unit}',
                        style: const TextStyle(
                          color: AppColors.leafDark,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        leading: const Icon(Icons.storefront, color: AppColors.leaf),
                        title: Text(product.farmer, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(product.location),
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _decrement,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.leaf,
                            iconSize: 32,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _increment,
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.leaf,
                            iconSize: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Total: ${product.price * _quantity} FCFA',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.leaf,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<CartController>().addProduct(product, _quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$_quantity x ${product.name} ajouté(s) au panier'),
                      backgroundColor: AppColors.leafDark,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ajouter au panier',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
