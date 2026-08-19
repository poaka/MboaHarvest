import 'package:flutter_test/flutter_test.dart';

import 'package:agrolink/app.dart';

void main() {
  testWidgets('affiche l’accueil', (tester) async {
    await tester.pumpWidget(const AgroLinkApp());

    expect(find.text('Bienvenue sur AgroLink'), findsOneWidget);
  });
}
