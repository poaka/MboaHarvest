import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/state/product_controller.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/presentation/cart_page.dart';
import '../controller/home_controller.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.displayName,
    required this.isFarmer,
    required this.onLogout,
    super.key,
  });

  final String displayName;
  final bool isFarmer;
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = context.watch<ProductController>().allProducts;

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final products = _controller.getVisibleProducts(allProducts);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HomeHeader(onLogout: widget.onLogout),
                            const SizedBox(height: 28),
                            Text(
                              'Bonjour, ${widget.displayName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.isFarmer
                                  ? 'Suivez le marché et trouvez vos prochains acheteurs.'
                                  : 'Des produits locaux vérifiés, près de chez vous.',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.ink.withValues(alpha: 0.7),
                                  ),
                            ),
                            const SizedBox(height: 22),
                            TextField(
                              key: const Key('home_search'),
                              onChanged: _controller.search,
                              textInputAction: TextInputAction.search,
                              decoration: const InputDecoration(
                                hintText: 'Produit ou quartier',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 42,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: HomeController.categories.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final category =
                                      HomeController.categories[index];
                                  return ChoiceChip(
                                    label: Text(category),
                                    selected:
                                        _controller.selectedCategory ==
                                        category,
                                    onSelected: (_) =>
                                        _controller.selectCategory(category),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Disponibles autour de Yaoundé',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                                Text(
                                  '${products.length} produit${products.length > 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    color: Color(0xFF68756D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (products.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyProducts(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    sliver: SliverList.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: ProductCard(product: products[index]),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.leaf,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.eco_outlined, color: AppColors.canvas),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AgroLink CM',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14),
                  SizedBox(width: 2),
                  Text('Yaoundé', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        Consumer<CartController>(
          builder: (context, cart, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                ),
                if (cart.totalItems > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(
          key: const Key('logout'),
          tooltip: 'Se déconnecter',
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_outlined, size: 38, color: Color(0xFF68756D)),
            SizedBox(height: 12),
            Text(
              'Aucun produit trouvé',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text('Essayez un autre produit ou une autre catégorie.'),
          ],
        ),
      ),
    );
  }
}
