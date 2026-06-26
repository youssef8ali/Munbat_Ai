// lib/features/profile/presentation/pages/edit_profile_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/profile/data/models/user_profile_model.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfileModel profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  File? _pickedImage;           // صورة جديدة من الجهاز
  bool _removeImage = false;    // ✅ فلاج لما المستخدم يضغط Remove Photo
  bool _isLoading = false;      // ✅ loading محلي عشان نتحكم فيه هنا
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController    = TextEditingController(text: widget.profile.name);
    _phoneController   = TextEditingController(text: widget.profile.phone);
    _addressController = TextEditingController(text: widget.profile.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ✅ Save — بيشغل loading ويبعت الريكويست
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    await context.read<ProfileCubit>().updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          imagePath: _removeImage ? null : _pickedImage?.path,
          removeImage: _removeImage, // ✅ لو Remove ابعت flag للسيرفر
        );

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  void _changePhoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // ✅ نمسح الصورة المحلية ونشعل فلاج الحذف
                setState(() {
                  _pickedImage  = null;
                  _removeImage  = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
          _removeImage = false; // ✅ لو اختار صورة جديدة، ألغِ الحذف
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ بيعرض: صورة جديدة > صورة السيرفر (لو مفيش remove) > placeholder
  Widget _buildAvatar() {
    if (_pickedImage != null) {
      return CircleAvatar(backgroundImage: FileImage(_pickedImage!));
    }

    if (!_removeImage && widget.profile.imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.profile.imageUrl),
        onBackgroundImageError: (_, __) {},
      );
    }

    // placeholder — لما مفيش صورة أو بعد Remove
    return const CircleAvatar(
      backgroundColor: AppColors.greyLight,
      child: Icon(Icons.person, size: 70, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ─── Profile Picture ──────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(child: _buildAvatar()),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _changePhoto,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: AppColors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading ? null : _changePhoto,
                child: Text(
                  'Change Photo',
                  style: AppTextStyles.h3
                      .copyWith(color: AppColors.primary, fontSize: 16),
                ),
              ),

              const SizedBox(height: 32),

              // ─── Email (Read Only) ────────────────────────────────
              _buildFieldLabel('EMAIL ADDRESS'),
              const SizedBox(height: 12),
              _buildReadOnlyField(
                icon: Icons.email,
                value: widget.profile.email,
              ),

              const SizedBox(height: 24),

              // ─── Full Name ────────────────────────────────────────
              _buildFieldLabel('FULL NAME'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                icon: Icons.person,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 24),

              // ─── Phone ────────────────────────────────────────────
              _buildFieldLabel('PHONE NUMBER'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              // ─── Address ──────────────────────────────────────────
              _buildFieldLabel('ADDRESS'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _addressController,
                icon: Icons.location_on_outlined,
                keyboardType: TextInputType.streetAddress,
              ),

              const SizedBox(height: 48),

              // ─── Save Button ──────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // ✅ بيعرض spinner لما _isLoading يكون true
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: AppTextStyles.h3
                              .copyWith(color: AppColors.white, fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Cancel Button ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: BorderSide.none,
                    backgroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.h3.copyWith(
                        color: AppColors.textSecondary, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: !_isLoading,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: AppColors.textSecondary.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(width: 12),
          Text(
            value.isNotEmpty ? value : '—',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}