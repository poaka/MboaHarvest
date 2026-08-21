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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      authUser: AuthUser.fromJson(Map<String, dynamic>.from(json['authUser'])),
      email: json['email'] as String?,
      address: json['address'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authUser': authUser.toJson(),
      'email': email,
      'address': address,
      'bio': bio,
    };
  }
}
