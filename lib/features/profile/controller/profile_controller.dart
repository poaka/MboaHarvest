import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../../auth/models/auth_user.dart';
import '../models/user_profile.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(AuthUser authUser) {
    _loadProfile(authUser);
  }

  final _box = GetStorage();
  final String _storageKey = 'user_profile';

  late UserProfile _profile;
  UserProfile get profile => _profile;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _loadProfile(AuthUser authUser) {
    final storedData = _box.read<Map<String, dynamic>>(_storageKey);
    if (storedData != null) {
      final storedProfile = UserProfile.fromJson(storedData);
      if (storedProfile.authUser.phoneNumber == authUser.phoneNumber) {
        _profile = storedProfile;
        return;
      }
    }
    _profile = UserProfile(authUser: authUser);
  }

  void _saveProfile() {
    _box.write(_storageKey, _profile.toJson());
  }

  void toggleEdit() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  Future<void> saveProfile({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? bio,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final updatedAuth = AuthUser(
      displayName: name ?? _profile.authUser.displayName,
      phoneNumber: phone ?? _profile.authUser.phoneNumber,
      role: _profile.authUser.role,
    );

    _profile = _profile.copyWith(
      authUser: updatedAuth,
      email: email,
      address: address,
      bio: bio,
    );

    _saveProfile();

    _isLoading = false;
    _isEditing = false;
    notifyListeners();
  }
}
