import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/order.dart';
import '../../../core/state/order_controller.dart';
import '../../auth/models/auth_user.dart';

class BuyerOrdersPage extends StatelessWidget {
  const BuyerOrdersPage({
    required this.authUser,
    super.key,
  });

  final AuthUser authUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<OrderController>(
        builder: (context, controller, child) {
          // In a real app we'd use authUser.id, here we use 'buyer_123' as hardcoded in checkout
          final orders = controller.getOrdersForBuyer('buyer_123');

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Aucune commande trouvée.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Parcourez le marché pour passer une commande.', style: TextStyle(color: Colors.grey)),
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
              return _OrderCard(order: sortedOrders[index]);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.validated:
        return 'Validée';
      case OrderStatus.completed:
        return 'Terminée';
      case OrderStatus.rejected:
        return 'Rejetée';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.validated:
        return Colors.blue;
      case OrderStatus.completed:
        return AppColors.leafDark;
      case OrderStatus.rejected:
        return Colors.red;
    }
  }

  void _showEditDialog(BuildContext context) {
    final addressController = TextEditingController(text: order.deliveryAddress);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la commande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seule l\'adresse de livraison peut être modifiée avant traitement.', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse de livraison',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.leaf),
            onPressed: () {
              final updated = order.copyWith(deliveryAddress: addressController.text);
              context.read<OrderController>().updateOrder(updated);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Commande modifiée avec succès')));
            },
            child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    final canEdit = order.status == OrderStatus.pending || order.status == OrderStatus.validated;

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
                Text('Commande #${order.id.substring(0, 6)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(_getStatusText(order.status), style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
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
            if (order.deliveryAddress != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(order.deliveryAddress!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${order.total} FCFA', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.leafDark, fontSize: 16)),
              ],
            ),
            if (canEdit) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Modifier les détails'),
                  onPressed: () => _showEditDialog(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
