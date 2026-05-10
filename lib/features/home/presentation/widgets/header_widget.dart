// lib/features/home/presentation/widgets/header_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:munbat_ai/core/constants/app_icons.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';
import 'package:munbat_ai/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:munbat_ai/features/profile/presentation/cubit/profile_state.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getFormattedDate(), style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // ✅ بيقرأ الاسم من ProfileCubit الموجود بالفعل
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          String name = 'Gardener';
                          if (state is ProfileSuccess) {
                            name = state.profile.name;
                          } else if (state is ProfileUpdateSuccess) {
                            name = state.profile.name;
                          } else if (state is ProfileUpdateLoading) {
                            name = state.profile.name;
                          }
                          return Text(
                            'Hello, $name ',
                            style: AppTextStyles.h1,
                          );
                        },
                      ),
                      const Text('🌿', style: TextStyle(fontSize: 28)),
                    ],
                  ),
                ],
              ),
              SvgIcon(assetPath: AppIcons.notification),
            ],
          ),
          const SizedBox(height: 16),
          const SearchBarWidget(),
        ],
      ),
    );
  }
}