// lib/features/home/presentation/pages/main_navigation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/constants/app_icons.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';
import 'package:munbat_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:munbat_ai/features/home/presentation/pages/home.dart';
import 'package:munbat_ai/features/profile/data/repositories/profile_repository.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:munbat_ai/features/profile/presentation/pages/profile_page.dart';
import 'package:munbat_ai/features/store/presentation/pages/store_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ ProfileCubit هنا عشان يكون متاح في HomePage و ProfilePage الاتنين
      create: (_) => ProfileCubit(ProfileRepository())..loadProfile(),
      child: WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
            return false;
          }
          return true;
        },
        child: Builder(
          builder: (context) {
            // ✅ الـ pages جوه الـ Builder عشان تاخد الـ context بعد الـ BlocProvider
            final pages = [
              const HomePage(),
              const ChatPage(),
              const StorePage(),
              // ✅ ProfilePage بتاخد الـ ProfileCubit من الـ parent مش بتعمل واحد جديد
              const _ProfilePageWrapper(),
            ];

            return Scaffold(
              body: pages[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textSecondary,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgIcon(
                      assetPath: AppIcons.homeOutlined,
                      size: 24,
                      color: AppColors.textSecondary,
                    ),
                    activeIcon: SvgIcon(
                      assetPath: AppIcons.home,
                      size: 24,
                      color: AppColors.primary,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgIcon(assetPath: AppIcons.chatOutlined, size: 24),
                    activeIcon: SvgIcon(
                        assetPath: AppIcons.chat, color: AppColors.primary),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgIcon(assetPath: AppIcons.storeOutlined),
                    activeIcon: SvgIcon(
                        assetPath: AppIcons.store, color: AppColors.primary),
                    label: 'Store',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgIcon(assetPath: AppIcons.profileOutlined),
                    activeIcon: SvgIcon(
                        assetPath: AppIcons.profile, color: AppColors.primary),
                    label: 'Profile',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ✅ ProfilePage wrapper بتاخد الـ ProfileCubit من الـ parent بدل ما تعمل جديد
class _ProfilePageWrapper extends StatelessWidget {
  const _ProfilePageWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileCubit>(),
      child: const ProfilePageView(),
    );
  }
}