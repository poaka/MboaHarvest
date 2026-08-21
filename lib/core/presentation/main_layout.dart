import 'package:flutter/material.dart';
import '../../features/auth/models/auth_user.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/orders/presentation/buyer_orders_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../theme/app_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({
    required this.authUser,
    required this.onLogout,
    super.key,
  });

  final AuthUser authUser;
  final VoidCallback onLogout;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        displayName: widget.authUser.displayName,
        isFarmer: false,
        onLogout: widget.onLogout,
        onCartTapped: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CartPage()),
        ),
      ),
      BuyerOrdersPage(authUser: widget.authUser),
      ProfilePage(authUser: widget.authUser, onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.leafDark,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Marché'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Commandes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
