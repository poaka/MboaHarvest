import '../../auth/models/auth_user.dart';

class UserProfile {
  UserProfile({
    required this.authUser,
    this.email,
    this.address,
    this.bio,
  });

  final AuthUser authUser;
  final String? email;
  final String? address;
  final String? bio;

  UserProfile copyWith({
    AuthUser? authUser,
    String? email,
    String? address,
    String? bio,
  }) {
    return UserProfile(
      authUser: authUser ?? this.authUser,
      email: email ?? this.email,
      address: address ?? this.address,
      bio: bio ?? this.bio,
    );
  }
}
