// lib/features/settings/presentation/pages/help_support_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/features/settings/presentation/pages/faq_page.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/section_header_settings.dart';
import 'package:munbat_ai/features/settings/presentation/widgets/setting_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const _supportEmail = 'manbutsystem@gmail.com';
  static const _supportPhone = '01283360357';

  Future<void> _launchEmail(BuildContext context, {String? subject, String? body}) async {
    final subjectEncoded = Uri.encodeComponent(subject ?? '');
    final bodyEncoded = Uri.encodeComponent(body ?? '');
    final url = 'mailto:$_supportEmail?subject=$subjectEncoded&body=$bodyEncoded';
    try {
      await launchUrlString(url);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: _supportPhone);
    try {
      await launchUrl(uri);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open phone app')),
        );
      }
    }
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
          'Help & Support',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            SectionHeader(title: 'GET HELP'),

            SettingTile(
              icon: Icons.email,
              iconColor: AppColors.primary,
              title: 'Email Support',
              subtitle: _supportEmail,
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => _launchEmail(context, subject: 'Support Request'),
            ),

            SettingTile(
              icon: Icons.phone,
              iconColor: AppColors.primary,
              title: 'Call Us',
              subtitle: _supportPhone,
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => _launchPhone(context),
            ),

            const SizedBox(height: 12),

            SectionHeader(title: 'RESOURCES'),

            SettingTile(
              icon: Icons.help_outline,
              iconColor: const Color(0xFF5D9CEC),
              title: 'FAQ',
              subtitle: 'Find answers to common questions',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FAQPage()),
              ),
            ),

            SettingTile(
              icon: Icons.school,
              iconColor: const Color(0xFF5D9CEC),
              title: 'User Guide',
              subtitle: 'Learn how to use the app',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => _showUserGuideDialog(context),
            ),

            const SizedBox(height: 12),

            SectionHeader(title: 'FEEDBACK'),

            SettingTile(
              icon: Icons.feedback,
              iconColor: const Color(0xFFFFB74D),
              title: 'Send Feedback',
              subtitle: 'Help us improve',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => _showFeedbackDialog(context),
            ),

            SettingTile(
              icon: Icons.bug_report,
              iconColor: const Color(0xFFFFB74D),
              title: 'Report a Bug',
              subtitle: 'Let us know about issues',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => _showBugReportDialog(context),
            ),

            const SizedBox(height: 12),

            SectionHeader(title: 'ABOUT'),

            SettingTile(
              icon: Icons.info,
              iconColor: const Color(0xFF9575CD),
              title: 'About Munbat AI',
              subtitle: 'Version 1.0.0',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => _showAboutDialog(context),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showUserGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('User Guide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _GuideStep(
                number: '1',
                title: 'Diagnose a Plant',
                description:
                    'Go to the Diagnosis tab, take or upload a photo of your plant, and let our AI analyze it instantly.',
              ),
              _GuideStep(
                number: '2',
                title: 'Chat with AI',
                description:
                    'Use the AI Chat feature to ask any plant-related questions. Our assistant answers only plant care, diseases, and treatment topics.',
              ),
              _GuideStep(
                number: '3',
                title: 'Browse the Store',
                description:
                    'Visit the Store tab to find treatments and products recommended for your plant\'s condition.',
              ),
              _GuideStep(
                number: '4',
                title: 'Place an Order',
                description:
                    'Add products to your cart, go to checkout, enter your shipping address and phone number, then place your order.',
              ),
              _GuideStep(
                number: '5',
                title: 'Track Your Orders',
                description:
                    'Check your order history anytime from Profile → My Order.',
              ),
              _GuideStep(
                number: '6',
                title: 'View Diagnosis History',
                description:
                    'All your past diagnoses are saved under Profile → Diagnosis History.',
              ),
            ],
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

  void _showFeedbackDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Send Feedback'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
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
            onPressed: () async {
              final text = controller.text.trim();
              Navigator.pop(context);
              if (text.isEmpty) return;
              await _launchEmail(
                context,
                subject: 'App Feedback',
                body: text,
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Report a Bug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Bug Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
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
            onPressed: () async {
              final title = titleController.text.trim();
              final desc = descController.text.trim();
              Navigator.pop(context);
              if (title.isEmpty && desc.isEmpty) return;
              await _launchEmail(
                context,
                subject: 'Bug Report: $title',
                body: 'Bug Title: $title\n\nDescription:\n$desc',
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('About Munbat AI'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Munbat AI',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('Version 1.0.0'),
              SizedBox(height: 12),
              Text(
                'Munbat AI uses advanced artificial intelligence to help you '
                'identify and treat plant diseases, pests, and other issues.\n\n'
                'Our mission is to make plant care accessible to everyone through '
                'the power of AI technology.',
              ),
              SizedBox(height: 12),
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

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(description,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}