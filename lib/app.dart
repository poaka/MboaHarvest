import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/models/auth_user.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/home/presentation/home_page.dart';

class AgroLinkApp extends StatefulWidget {
  const AgroLinkApp({super.key});

  @override
  State<AgroLinkApp> createState() => _AgroLinkAppState();
}

class _AgroLinkAppState extends State<AgroLinkApp> {
  AuthUser? _user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _user == null
          ? AuthPage(onAuthenticated: (user) => setState(() => _user = user))
          : HomePage(
              displayName: _user!.displayName,
              isFarmer: _user!.role == UserRole.farmer,
              onLogout: () => setState(() => _user = null),
            ),
    );
  }
}
