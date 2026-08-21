import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';

import 'core/theme/app_theme.dart';
import 'core/state/product_controller.dart';
import 'features/auth/models/auth_user.dart';
import 'features/auth/presentation/auth_page.dart';
import 'core/state/cart_controller.dart';
import 'core/state/order_controller.dart';
import 'core/presentation/main_layout.dart';
import 'features/farmer/presentation/farmer_dashboard.dart';

class AgroLinkApp extends StatefulWidget {

  const AgroLinkApp({super.key});

  @override
  State<AgroLinkApp> createState() => _AgroLinkAppState();
}

class _AgroLinkAppState extends State<AgroLinkApp> {
  AuthUser? _user;
  final _box = GetStorage();
  final _sessionKey = 'auth_session';

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  void _loadSession() {
    final sessionData = _box.read<Map<String, dynamic>>(_sessionKey);
    if (sessionData != null) {
      setState(() {
        _user = AuthUser.fromJson(sessionData);
      });
    }
  }

  void _setSession(AuthUser? user) {
    setState(() => _user = user);
    if (user != null) {
      _box.write(_sessionKey, user.toJson());
    } else {
      _box.remove(_sessionKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
      ],
      child: MaterialApp(
        title: 'AgroLink',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: _user == null
            ? AuthPage(onAuthenticated: _setSession)
            : (_user!.role == UserRole.farmer
                ? FarmerDashboard(
                    farmerName: _user!.displayName,
                    authUser: _user!,
                    onLogout: () => _setSession(null),
                  )
                : MainLayout(
                    authUser: _user!,
                    onLogout: () => _setSession(null),
                  )),
      ),
    );
  }
}
