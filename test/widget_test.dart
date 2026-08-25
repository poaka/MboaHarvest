import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mboaharvest/app.dart';
import 'package:mboaharvest/features/auth/controller/auth_controller.dart';
import 'package:mboaharvest/features/auth/models/auth_user.dart';
import 'package:mboaharvest/features/home/controller/home_controller.dart';
import 'package:mboaharvest/core/state/product_controller.dart';

void main() {
  testWidgets('connecte un acheteur puis affiche l’accueil', (tester) async {
    await tester.pumpWidget(const MboaHarvestApp());

    expect(find.text('Bienvenue sur MboaHarvest !'), findsWidgets);

    await tester.enterText(find.byKey(const Key('auth_phone')), '699887766');
    await tester.enterText(find.byKey(const Key('auth_password')), 'secret1');
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Bonjour, Acheteur MboaHarvest'), findsOneWidget);
    expect(find.text('Tomates fraîches'), findsOneWidget);
  });

  test('valide les données avant de créer un compte', () {
    final controller = AuthController()..setMode(AuthMode.register);

    expect(
      controller.authenticate(name: '', phone: '123', password: 'court'),
      isNull,
    );
    expect(controller.errorMessage, isNotNull);

    final user = controller.authenticate(
      name: 'Amina Ngo',
      phone: '677889900',
      password: 'secret1',
    );
    expect(user?.displayName, 'Amina Ngo');
    expect(user?.role, UserRole.buyer);
  });

  test('filtre les produits par recherche et catégorie', () {
    final controller = HomeController();
    final allProducts = ProductController().allProducts;

    controller.search('Soa');
    expect(controller.getVisibleProducts(allProducts).single.name, 'Maïs jaune');

    controller.search('');
    controller.selectCategory('Tubercules');
    expect(controller.getVisibleProducts(allProducts).single.name, 'Macabo blanc');
  });
}
