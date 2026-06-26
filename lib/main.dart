// lib/main.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/core/theme/app_theme.dart';
import 'package:munbat_ai/features/auth/presentation/pages/welcom_screen.dart';
import 'package:munbat_ai/features/home/presentation/pages/main_navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final prefs = await SharedPreferences.getInstance();

  final token = await apiService.getToken();
  final keepSignedIn = prefs.getBool('keep_signed_in') ?? false;

  bool isLoggedIn = false;

  if (token != null && token.isNotEmpty) {
    if (keepSignedIn) {
      isLoggedIn = true;
    } else {
      // مفيش "keep me signed in" => امسح التوكن في أول تشغيل جديد للتطبيق
      await apiService.clearToken();
      isLoggedIn = false;
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  // ✅ isLoggedIn اختياري بـ default false — عشان الـ test يشتغل بدون تغيير
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Munbat AI',
      theme: AppTheme.lightTheme,
      home: isLoggedIn ? const MainNavigationPage() : WelcomeScreen(),
    );
  }
}