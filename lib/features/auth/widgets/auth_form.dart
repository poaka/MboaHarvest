import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../controller/auth_controller.dart';
import '../models/auth_user.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    required this.controller,
    required this.onAuthenticated,
    super.key,
  });

  final AuthController controller;
  final ValueChanged<AuthUser> onAuthenticated;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final user = widget.controller.authenticate(
      name: _nameController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );
    if (user != null) widget.onAuthenticated(user);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final isRegister = widget.controller.mode == AuthMode.register;
        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<AuthMode>(
                segments: const [
                  ButtonSegment(
                    value: AuthMode.login,
                    label: Text('Connexion'),
                  ),
                  ButtonSegment(
                    value: AuthMode.register,
                    label: Text('Créer un compte'),
                  ),
                ],
                selected: {widget.controller.mode},
                onSelectionChanged: (value) {
                  widget.controller.setMode(value.first);
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Je suis',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _RoleOption(
                      label: 'Acheteur',
                      icon: Icons.shopping_basket_outlined,
                      selected: widget.controller.role == UserRole.buyer,
                      onTap: () => widget.controller.setRole(UserRole.buyer),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RoleOption(
                      label: 'Agriculteur',
                      icon: Icons.agriculture_outlined,
                      selected: widget.controller.role == UserRole.farmer,
                      onTap: () => widget.controller.setRole(UserRole.farmer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isRegister) ...[
                TextField(
                  key: const Key('auth_name'),
                  controller: _nameController,
                  autofillHints: const [AutofillHints.name],
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                key: const Key('auth_phone'),
                controller: _phoneController,
                autofillHints: const [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  prefixText: '+237  ',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '6 XX XX XX XX',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                key: const Key('auth_password'),
                controller: _passwordController,
                autofillHints: const [AutofillHints.password],
                obscureText: _obscurePassword,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'Afficher le mot de passe'
                        : 'Masquer le mot de passe',
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              if (widget.controller.errorMessage case final error?) ...[
                const SizedBox(height: 14),
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(error)),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton(
                key: const Key('auth_submit'),
                onPressed: _submit,
                child: Text(isRegister ? 'Créer mon compte' : 'Se connecter'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE0EEE5) : const Color(0xFFF0EEE6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Semantics(
          selected: selected,
          button: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              children: [
                Icon(icon, color: selected ? AppColors.leaf : AppColors.ink),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.leafDark : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
