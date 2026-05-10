// lib/features/settings/presentation/pages/privacy_security_page.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/section_header_settings.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/setting_tile.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _biometricAuth = false;
  bool _saveLoginInfo = true;


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
          style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Security Section
            SectionHeader(title: 'SECURITY'),

            SettingTile(
              icon: Icons.fingerprint,
              iconColor: AppColors.primary,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID to login',
              trailing: Switch(
                value: _biometricAuth,
                onChanged: (value) {
                  setState(() => _biometricAuth = value);
                },
                activeColor: AppColors.primary,
              ),
            ),

            SettingTile(
              icon: Icons.lock,
              iconColor: AppColors.primary,
              title: 'Change Password',
              subtitle: 'Update your account password',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),

            SettingTile(
              icon: Icons.save,
              iconColor: AppColors.primary,
              title: 'Save Login Info',
              subtitle: 'Remember login credentials',
              trailing: Switch(
                value: _saveLoginInfo,
                onChanged: (value) {
                  setState(() => _saveLoginInfo = value);
                },
                activeColor: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            // Privacy Section
            SectionHeader(title: 'PRIVACY'),

            SettingTile(
              icon: Icons.policy,
              iconColor: const Color(0xFF5D9CEC),
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                // Navigate to privacy policy
              },
            ),

            SettingTile(
              icon: Icons.description,
              iconColor: const Color(0xFF5D9CEC),
              title: 'Terms of Service',
              subtitle: 'Review terms and conditions',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                // Navigate to terms of service
              },
            ),

            SettingTile(
              icon: Icons.analytics,
              iconColor: const Color(0xFF5D9CEC),
              title: 'Data Usage',
              subtitle: 'See how your data is used',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                _showDataUsageDialog(context);
              },
            ),

            const SizedBox(height: 24),

            // Account Management Section
            SectionHeader(title: 'ACCOUNT MANAGEMENT'),

            SettingTile(
              icon: Icons.download,
              iconColor: const Color(0xFF48C9B0),
              title: 'Download My Data',
              subtitle: 'Get a copy of your data',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                _showDownloadDataDialog(context);
              },
            ),

            SettingTile(
              icon: Icons.delete_forever,
              iconColor: Colors.red,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDataUsageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Usage'),
        content: const SingleChildScrollView(
          child: Text(
            'We collect and use your data to:\n\n'
            '• Provide plant diagnosis services\n'
            '• Improve AI accuracy\n'
            '• Personalize your experience\n'
            '• Send relevant notifications\n'
            '• Analyze usage patterns\n\n'
            'Your data is encrypted and stored securely. '
            'We never share your personal information with third parties without your consent.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We\'ll prepare a copy of your data including:\n\n'
          '• Profile information\n'
          '• Diagnosis history\n'
          '• Saved plants\n'
          '• Chat conversations\n\n'
          'You\'ll receive an email with a download link within 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted'),
                ),
              );
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
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
              // Implement account deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
