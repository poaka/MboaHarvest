import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../controller/auth_controller.dart';
import '../models/auth_user.dart';
import '../widgets/auth_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({required this.onAuthenticated, super.key});

  final ValueChanged<AuthUser> onAuthenticated;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _controller = AuthController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 36),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: AppColors.leaf,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_outlined,
                          color: AppColors.canvas,
                          size: 29,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Du champ à votre tables.',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Achetez directement auprès des agriculteurs vérifiés du Cameroun.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthForm(
                        controller: _controller,
                        onAuthenticated: widget.onAuthenticated,
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'AgroLink CM · Marché local, échanges directs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF68756D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
