import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/state/product_controller.dart';
import '../../../core/state/cart_controller.dart';
import 'add_product_page.dart';

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({
    required this.farmerName,
    required this.onLogout,
    super.key,
  });

  final String farmerName;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.canvas,
          elevation: 0,
          title: Text(
            'AgroLink - Espace Producteur',
            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.ink),
              onPressed: onLogout,
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.leafDark,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.leaf,
            tabs: [
              Tab(text: 'Mes Produits'),
              Tab(text: 'Commandes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MyProductsTab(farmerName: farmerName),
            _OrdersTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.leaf,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddProductPage(farmerName: farmerName)),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Nouveau produit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _MyProductsTab extends StatelessWidget {
  const _MyProductsTab({required this.farmerName});
  
  final String farmerName;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final products = controller.getProductsByFarmer(farmerName);

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Vous n\'avez aucun produit en ligne.'),
                const SizedBox(height: 8),
                const Text('Appuyez sur + pour ajouter votre récolte.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: const Color(0xFFEAF1E8), borderRadius: BorderRadius.circular(12)),
                  child: Text(product.emoji, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${product.category} · ${product.location}'),
                trailing: Text('${product.price} FCFA', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.leafDark, fontSize: 16)),
              ),
            );
          },
        );
      },
    );
  }
}

class _OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cart, child) {
        final orders = cart.orders;
        // In a real app, we would filter orders containing this farmer's products.
        // Here we just simulate showing all orders for demo.
        if (orders.isEmpty) {
          return const Center(child: Text('Aucune commande reçue pour le moment.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Commande #${order.id.substring(0, 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                          child: const Text('Validée', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text('${item.quantity}x ${item.product.name}'),
                            ],
                          ),
                        )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${order.total} FCFA', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.leafDark)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
