import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agrolink/app.dart';
import 'package:agrolink/features/auth/controller/auth_controller.dart';
import 'package:agrolink/features/auth/models/auth_user.dart';
import 'package:agrolink/features/home/controller/home_controller.dart';

void main() {
  testWidgets('connecte un acheteur puis affiche l’accueil', (tester) async {
    await tester.pumpWidget(const AgroLinkApp());

    expect(find.text('Du champ à votre table.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('auth_phone')), '699887766');
    await tester.enterText(find.byKey(const Key('auth_password')), 'secret1');
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Bonjour, Acheteur AgroLink'), findsOneWidget);
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

    controller.search('Soa');
    expect(controller.visibleProducts.single.name, 'Maïs jaune');

    controller.search('');
    controller.selectCategory('Tubercules');
    expect(controller.visibleProducts.single.name, 'Macabo blanc');
  });
}
