import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/state/product_controller.dart';
import 'features/auth/models/auth_user.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/cart/controller/cart_controller.dart';
import 'features/home/presentation/home_page.dart';
import 'features/farmer/presentation/farmer_dashboard.dart';

class AgroLinkApp extends StatefulWidget {

  const AgroLinkApp({super.key});

  @override
  State<AgroLinkApp> createState() => _AgroLinkAppState();
}

class _AgroLinkAppState extends State<AgroLinkApp> {
  AuthUser? _user;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
      ],
      child: MaterialApp(
        title: 'AgroLink',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: _user == null
            ? AuthPage(onAuthenticated: (user) => setState(() => _user = user))
            : (_user!.role == UserRole.farmer
                ? FarmerDashboard(
                    farmerName: _user!.displayName,
                    onLogout: () => setState(() => _user = null),
                  )
                : HomePage(
                    displayName: _user!.displayName,
                    isFarmer: false,
                    onLogout: () => setState(() => _user = null),
                  )),
      ),
    );
  }
}
