
// lib/features/settings/presentation/pages/help_support_page.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/settings/presentation/pages/faq_page.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/section_header_settings.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/setting_tile.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
          'Help & Support',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Get Help Section
            SectionHeader(title: 'GET HELP'),

            SettingTile(
              icon: Icons.chat_bubble,
              iconColor: AppColors.primary,
              title: 'Chat with Support',
              subtitle: 'Get instant help from our team',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Navigate to support chat
              },
            ),

            SettingTile(
              icon: Icons.email,
              iconColor: AppColors.primary,
              title: 'Email Support',
              subtitle: 'support@Munbat.com',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Open email client
              },
            ),

            SettingTile(
              icon: Icons.phone,
              iconColor: AppColors.primary,
              title: 'Call Us',
              subtitle: '+20 100 6978 914',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Make phone call
              },
            ),

            const SizedBox(height: 24),

            // Resources Section
            SectionHeader(title: 'RESOURCES'),

            SettingTile(
              icon: Icons.help_outline,
              iconColor: const Color(0xFF5D9CEC),
              title: 'FAQ',
              subtitle: 'Find answers to common questions',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQPage()),
                );
              },
            ),

            SettingTile(
              icon: Icons.school,
              iconColor: const Color(0xFF5D9CEC),
              title: 'User Guide',
              subtitle: 'Learn how to use the app',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Navigate to user guide
              },
            ),

            SettingTile(
              icon: Icons.video_library,
              iconColor: const Color(0xFF5D9CEC),
              title: 'Video Tutorials',
              subtitle: 'Watch step-by-step guides',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Navigate to video tutorials
              },
            ),

            SettingTile(
              icon: Icons.article,
              iconColor: const Color(0xFF5D9CEC),
              title: 'Plant Care Articles',
              subtitle: 'Read expert plant care tips',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Navigate to articles
              },
            ),

            const SizedBox(height: 24),

            // Feedback Section
            SectionHeader(title: 'FEEDBACK'),

            SettingTile(
              icon: Icons.rate_review,
              iconColor: const Color(0xFFFFB74D),
              title: 'Rate the App',
              subtitle: 'Share your experience',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
             
              },
            ),

            SettingTile(
              icon: Icons.feedback,
              iconColor: const Color(0xFFFFB74D),
              title: 'Send Feedback',
              subtitle: 'Help us improve',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),

            SettingTile(
              icon: Icons.bug_report,
              iconColor: const Color(0xFFFFB74D),
              title: 'Report a Bug',
              subtitle: 'Let us know about issues',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                _showBugReportDialog(context);
              },
            ),

            const SizedBox(height: 24),

            // About Section
            SectionHeader(title: 'ABOUT'),

            SettingTile(
              icon: Icons.info,
              iconColor: const Color(0xFF9575CD),
              title: 'About Munbat AI',
              subtitle: 'Version 1.0.0',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                _showAboutDialog(context);
              },
            ),

            SettingTile(
              icon: Icons.new_releases,
              iconColor: const Color(0xFF9575CD),
              title: 'What\'s New',
              subtitle: 'Latest updates and features',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                // Show changelog
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
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
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Bug Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the issue...',
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
                const SnackBar(content: Text('Bug report submitted. Thank you!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Munbat AI'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Munbat AI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Version 1.0.2'),
              SizedBox(height: 16),
              Text(
                'Munbat AI uses advanced artificial intelligence to help you '
                'identify and treat plant diseases, pests, and other issues.\n\n'
                'Our mission is to make plant care accessible to everyone through '
                'the power of AI technology.',
              ),
              SizedBox(height: 16),
              Text('© 2026 Munbat AI. All rights reserved.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

