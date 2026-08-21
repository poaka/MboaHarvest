import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/models/auth_user.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.authUser,
    required this.onLogout,
    super.key,
  });

  final AuthUser authUser;
  final VoidCallback onLogout;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _controller;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(widget.authUser);
    _initControllers();
  }
  
  void _initControllers() {
    _nameController.text = _controller.profile.authUser.displayName;
    _phoneController.text = _controller.profile.authUser.phoneNumber;
    _emailController.text = _controller.profile.email ?? '';
    _addressController.text = _controller.profile.address ?? '';
    _bioController.text = _controller.profile.bio ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<ProfileController>(
        builder: (context, controller, child) {
          final isFarmer = controller.profile.authUser.role == UserRole.farmer;
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mon Profil'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (!controller.isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.leafDark),
                    onPressed: () {
                      _initControllers();
                      controller.toggleEdit();
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: controller.toggleEdit,
                  ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.leaf.withValues(alpha: 0.2),
                      child: Text(
                        controller.profile.authUser.displayName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 40, color: AppColors.leafDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.profile.authUser.displayName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isFarmer ? 'Producteur' : 'Acheteur',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    if (controller.isEditing) ...[
                      _buildTextField('Nom complet', _nameController),
                      _buildTextField('Téléphone', _phoneController, TextInputType.phone),
                      _buildTextField('Email', _emailController, TextInputType.emailAddress),
                      _buildTextField('Adresse', _addressController),
                      if (isFarmer) _buildTextField('Bio (Vos produits, votre ferme)', _bioController, TextInputType.multiline, 3),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.leaf,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  await controller.saveProfile(
                                    name: _nameController.text,
                                    phone: _phoneController.text,
                                    email: _emailController.text,
                                    address: _addressController.text,
                                    bio: _bioController.text,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Profil mis à jour avec succès')),
                                    );
                                  }
                                },
                          child: controller.isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ] else ...[
                      _buildInfoRow(Icons.phone, 'Téléphone', controller.profile.authUser.phoneNumber),
                      _buildInfoRow(Icons.email_outlined, 'Email', controller.profile.email ?? 'Non renseigné'),
                      _buildInfoRow(Icons.location_on_outlined, 'Adresse', controller.profile.address ?? 'Non renseignée'),
                      if (isFarmer) _buildInfoRow(Icons.info_outline, 'Bio', controller.profile.bio ?? 'Aucune description'),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text('Se déconnecter', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: widget.onLogout,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, [TextInputType type = TextInputType.text, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.leaf, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.leafDark, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
