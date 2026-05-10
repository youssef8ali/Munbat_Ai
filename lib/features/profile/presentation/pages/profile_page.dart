// lib/features/profile/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/features/auth/presentation/pages/login_page.dart';
import 'package:munbat_ai/features/diagnosis/presentation/pages/diagnosis_history_page.dart';
import 'package:munbat_ai/features/profile/data/models/user_profile_model.dart';
import 'package:munbat_ai/features/profile/data/repositories/profile_repository.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_state.dart';
import 'package:munbat_ai/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:munbat_ai/features/settings/presentation/pages/help_support_page.dart';
import 'package:munbat_ai/features/settings/presentation/pages/my_order.dart';
import 'package:munbat_ai/features/settings/presentation/pages/privacy_security_page.dart';

// ✅ ProfilePage لما تُفتح من غير MainNavigation (مثلاً direct push)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..loadProfile(),
      child: const ProfilePageView(),
    );
  }
}

// ✅ ProfilePageView هي الـ UI الحقيقية — بتاخد الـ Cubit من الـ parent
class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  Future<void> _logout(BuildContext context) async {
    // ✅ مسح الـ token
    await ApiService().clearToken();

    if (!context.mounted) return;

    // ✅ روح للـ Login وامسح كل الـ stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
   appBar: AppBar(
  backgroundColor: AppColors.white,
  elevation: 0,
  automaticallyImplyLeading: false, // ✅ مفيش back button
  title: Text(
    'Profile',
    style: Theme.of(context)
        .textTheme
        .headlineSmall
        ?.copyWith(fontWeight: FontWeight.w700),
  ),
  centerTitle: true,
),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColors.primary,
              ),
            );
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          UserProfileModel? profile;
          if (state is ProfileSuccess) profile = state.profile;
          if (state is ProfileUpdateLoading) profile = state.profile;
          if (state is ProfileUpdateSuccess) profile = state.profile;

          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.textSecondary, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load profile',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileCubit>().loadProfile(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: const Text('Retry',
                        style: TextStyle(color: AppColors.white)),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Profile Picture
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
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
                      child: const CircleAvatar(
                        backgroundColor: AppColors.greyLight,
                        child: Icon(Icons.person,
                            size: 60, color: AppColors.textSecondary),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            color: AppColors.white, size: 18),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  profile.name.isNotEmpty ? profile.name : 'No Name',
                  style: AppTextStyles.h1.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  [
                    if (profile.email.isNotEmpty) profile.email,
                    if (profile.phone.isNotEmpty) profile.phone,
                  ].join('  |  '),
                  style: AppTextStyles.caption.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Edit Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileCubit>(),
                            child: EditProfilePage(profile: profile!),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Edit Profile',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 20),

                // Account Information
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACCOUNT INFORMATION',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ProfileMenuItem(
                        icon: Icons.history,
                        title: 'Diagnosis History',
                        iconBgColor: AppColors.primary.withOpacity(0.1),
                        iconColor: AppColors.primary,
                        onTap: () => context.push(DiagnosisHistoryPage()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // App Settings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APP SETTINGS',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ProfileMenuItem(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        iconBgColor: AppColors.greyLight,
                        iconColor: AppColors.textSecondary,
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ProfileMenuItem(
                        icon: Icons.security,
                        title: 'Privacy & Security',
                        iconBgColor: AppColors.greyLight,
                        iconColor: AppColors.textSecondary,
                        onTap: () => context.push(PrivacySecurityPage()),
                      ),
                      const SizedBox(height: 12),
                      _ProfileMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Order',
                        iconBgColor: AppColors.greyLight,
                        iconColor: AppColors.textSecondary,
                        onTap: () => context.push(MyOrderPage()),
                      ),
                      const SizedBox(height: 12),
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        iconBgColor: AppColors.greyLight,
                        iconColor: AppColors.textSecondary,
                        onTap: () => context.push(HelpSupportPage()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Logout صح — بيمسح الـ token ويروح للـ Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text('Version 1.0.0',
                    style: AppTextStyles.caption.copyWith(fontSize: 12)),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBgColor;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.iconBgColor,
    required this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: AppTextStyles.h3.copyWith(fontSize: 16)),
            ),
            trailing ??
                const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}