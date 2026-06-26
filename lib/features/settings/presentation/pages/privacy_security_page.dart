// lib/features/settings/presentation/pages/privacy_security_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:munbat_ai/features/auth/presentation/pages/login_page.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/section_header_settings.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/setting_tile.dart';
import 'package:munbat_ai/features/auth/presentation/pages/change_password_page.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _isDeletingAccount = false;
  final _authRepository = AuthRepository();

  Future<void> _deleteAccount() async {
    setState(() => _isDeletingAccount = true);
    final result = await _authRepository.deleteAccount();
    if (!mounted) return;
    setState(() => _isDeletingAccount = false);
    if (result.success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Failed to delete account'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account?\n\n'
          'This action is permanent and cannot be undone. '
          'All your data, including diagnosis history and saved plants, will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showTextSheet(
      context,
      title: 'Privacy Policy',
      content: '''Last updated: June 2026

1. Information We Collect
We collect information you provide when using Munbat AI, including plant images you upload for diagnosis, your account details (name, email), and usage data to improve our services.

2. How We Use Your Information
We use your data to provide AI-powered plant diagnosis, improve our detection models, send you relevant notifications, and maintain your account. We do not sell your personal data to third parties.

3. Plant Images & AI Diagnosis
Images you submit are processed by our AI models to identify plant diseases and pests. Images may be stored temporarily to improve model accuracy and are never shared publicly.

4. Data Storage & Security
Your data is stored on secure servers with industry-standard encryption. We implement technical and organizational measures to protect your information against unauthorized access.

5. Data Retention
We retain your account data for as long as your account is active. Diagnosis history is kept for 12 months. You may request deletion of your data at any time through the app settings.

6. Third-Party Services
We may use third-party services (e.g., cloud storage, analytics) that process data on our behalf. These providers are bound by strict data protection agreements.

7. Your Rights
You have the right to access, correct, or delete your personal data. You may also request a copy of your data by contacting us at manbutsystem@gmail.com.

8. Contact Us
For any privacy-related questions, contact us at manbutsystem@gmail.com.''',
    );
  }

  void _showTermsOfService(BuildContext context) {
    _showTextSheet(
      context,
      title: 'Terms of Service',
      content: '''Last updated: June 2026

1. Acceptance of Terms
By using Munbat AI, you agree to these Terms of Service. If you do not agree, please discontinue use of the application.

2. Description of Service
Munbat AI provides AI-powered plant disease diagnosis, treatment recommendations, and a store for agricultural products. The service is intended for informational and educational purposes.

3. User Responsibilities
You agree to provide accurate information, use the app for lawful purposes only, not attempt to reverse-engineer or misuse the AI models, and not upload images that violate any laws or third-party rights.

4. AI Diagnosis Disclaimer
Our AI diagnosis tool provides suggestions based on image analysis. Results are not a substitute for professional agricultural advice. Always consult a qualified agronomist for critical plant health decisions.

5. Store & Purchases
Products purchased through the Munbat AI store are subject to separate purchase terms. Prices and availability may change without notice.

6. Intellectual Property
All content, logos, and AI models within Munbat AI are the property of Munbat and are protected by applicable intellectual property laws.

7. Limitation of Liability
Munbat AI is provided "as is" without warranties of any kind. We are not liable for any crop losses, damages, or decisions made based on AI diagnosis results.

8. Account Termination
We reserve the right to suspend or terminate accounts that violate these terms. You may delete your account at any time through the app settings.

9. Changes to Terms
We may update these terms periodically. Continued use of the app after changes constitutes acceptance of the updated terms.

10. Contact Us
For questions about these terms, contact us at manbutsystem@gmail.com.''',
    );
  }

  void _showTextSheet(BuildContext context,
      {required String title, required String content}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF444444),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy & Security',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                SectionHeader(title: 'SECURITY'),

                SettingTile(
                  icon: Icons.lock,
                  iconColor: AppColors.primary,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage()),
                  ),
                ),

                const SizedBox(height: 12),

                SectionHeader(title: 'PRIVACY'),

                SettingTile(
                  icon: Icons.policy,
                  iconColor: const Color(0xFF5D9CEC),
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => _showPrivacyPolicy(context),
                ),

                SettingTile(
                  icon: Icons.description,
                  iconColor: const Color(0xFF5D9CEC),
                  title: 'Terms of Service',
                  subtitle: 'Review terms and conditions',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => _showTermsOfService(context),
                ),

                const SizedBox(height: 12),

                SectionHeader(title: 'ACCOUNT MANAGEMENT'),

                SettingTile(
                  icon: Icons.delete_forever,
                  iconColor: Colors.red,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: _isDeletingAccount
                      ? null
                      : () => _showDeleteAccountDialog(context),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          if (_isDeletingAccount)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Deleting account...',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}