import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';

enum AuthMode { login, register }

class AuthController extends ChangeNotifier {
  AuthMode mode = AuthMode.login;
  UserRole role = UserRole.buyer;
  String? errorMessage;

  void setMode(AuthMode value) {
    mode = value;
    errorMessage = null;
    notifyListeners();
  }

  void setRole(UserRole value) {
    role = value;
    errorMessage = null;
    notifyListeners();
  }

  AuthUser? authenticate({
    required String name,
    required String phone,
    required String password,
  }) {
    var digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 12 && digits.startsWith('237')) {
      digits = digits.substring(3);
    }

    if (digits.length != 9 || !digits.startsWith('6')) {
      return _fail('Saisissez un numéro camerounais valide à 9 chiffres.');
    }
    if (password.length < 6) {
      return _fail('Le mot de passe doit contenir au moins 6 caractères.');
    }
    if (mode == AuthMode.register && name.trim().length < 2) {
      return _fail('Saisissez votre nom complet.');
    }

    errorMessage = null;
    notifyListeners();
    return AuthUser(
      displayName: mode == AuthMode.register
          ? name.trim()
          : role == UserRole.farmer
          ? 'Producteur AgroLink'
          : 'Acheteur AgroLink',
      phoneNumber: '+237 $digits',
      role: role,
    );
  }

  AuthUser? _fail(String message) {
    errorMessage = message;
    notifyListeners();
    return null;
  }
}
