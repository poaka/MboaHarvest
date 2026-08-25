import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/state/product_controller.dart';
import '../../../core/models/order.dart';
import '../../../core/state/order_controller.dart';
import '../../auth/models/auth_user.dart';
import '../../profile/presentation/profile_page.dart';
import 'add_product_page.dart';

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({
    required this.farmerName,
    required this.onLogout,
    required this.authUser,
    super.key,
  });

  final String farmerName;
  final VoidCallback onLogout;
  final AuthUser authUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.canvas,
          elevation: 0,
          title: const Text(
            'MboaHarvest - Espace Producteur',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          bottom: const TabBar(
            labelColor: AppColors.leafDark,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.leaf,
            tabs: [
              Tab(text: 'Produits'),
              Tab(text: 'Commandes'),
              Tab(text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MyProductsTab(farmerName: farmerName),
            _OrdersTab(),
            ProfilePage(authUser: authUser, onLogout: onLogout),
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
  
  void _showRejectDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter la commande'),
        content: const Text('Êtes-vous sûr de vouloir rejeter cette commande ? Cette action est irréversible et le client en sera informé.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<OrderController>().updateOrderStatus(order.id, OrderStatus.rejected);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Commande rejetée')));
            },
            child: const Text('Rejeter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, controller, child) {
        final orders = controller.orders;
        
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Aucune commande reçue.'),
                const SizedBox(height: 8),
                const Text('Les commandes apparaîtront ici.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // Sort by date descending
        final sortedOrders = List<Order>.from(orders)
          ..sort((a, b) => b.date.compareTo(a.date));

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: sortedOrders.length,
          itemBuilder: (context, index) {
            final order = sortedOrders[index];
            final isRejected = order.status == OrderStatus.rejected;
            
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
                          decoration: BoxDecoration(
                            color: isRejected ? Colors.red.shade100 : Colors.green.shade100, 
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            isRejected ? 'Rejetée' : 'Nouvelle', 
                            style: TextStyle(
                              color: isRejected ? Colors.red : Colors.green, 
                              fontSize: 12, 
                              fontWeight: FontWeight.bold
                            )
                          ),
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
                    const Text('Détails du client', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 4),
                    if (order.clientName != null) Text(order.clientName!, style: const TextStyle(fontWeight: FontWeight.w500)),
                    if (order.clientPhone != null) Text(order.clientPhone!, style: const TextStyle(color: AppColors.leafDark, fontWeight: FontWeight.w500)),
                    if (order.deliveryAddress != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(child: Text(order.deliveryAddress!, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ],
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${order.total} FCFA', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.leafDark)),
                      ],
                    ),
                    if (!isRejected) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Rejeter la commande'),
                          onPressed: () => _showRejectDialog(context, order),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ]
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
