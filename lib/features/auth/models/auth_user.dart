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

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      displayName: json['displayName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => UserRole.buyer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role.toString(),
    };
  }
}
