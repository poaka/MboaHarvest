enum UserRole { buyer, farmer }

extension UserRoleLabel on UserRole {
  String get label => this == UserRole.buyer ? 'Acheteur' : 'Agriculteur';
}

class AuthUser {
  const AuthUser({
    required this.displayName,
    required this.phoneNumber,
    required this.role,
  });

  final String displayName;
  final String phoneNumber;
  final UserRole role;
}
