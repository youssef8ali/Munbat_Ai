
// Header Section Widget
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/utils/app_extensions.dart';
import 'package:munbat_ai/features/auth/presentation/widgets/app_logo.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: context.height * 0.4,
          width: context.width,
          decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: SafeArea(
            child: Column(
              children: [
             
                const SizedBox(height:55),
                const AppLogo(),
              ],
            ),
          ),
        ),
        Container(
          height:context.height * 0.6,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 247, 250, 250),
          ),
         
        ),
      ],
    );
  }
}
