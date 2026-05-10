
// lib/features/settings/presentation/pages/faq_page.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

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
        title: Text('FAQ', style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          FAQItem(
            question: 'How accurate is the plant diagnosis?',
            answer: 'Our AI model has been trained on millions of plant images and '
                'achieves 94% accuracy in identifying common plant diseases and pests. '
                'However, for critical cases, we recommend consulting with a local plant expert.',
          ),
          FAQItem(
            question: 'Can I use the app offline?',
            answer: 'Some features like browsing your diagnosis history work offline. '
                'However, plant diagnosis requires an internet connection to access our AI model.',
          ),
          FAQItem(
            question: 'How do I get the best photo for diagnosis?',
            answer: 'Take a clear, well-lit photo of the affected area. Make sure the '
                'image is in focus and shows the symptoms clearly. Avoid shadows and blur.',
          ),
          FAQItem(
            question: 'Is my data secure?',
            answer: 'Yes, we take data security seriously. All your data is encrypted '
                'and stored securely. We never share your personal information without consent.',
          ),
          FAQItem(
            question: 'How much does the app cost?',
            answer: 'Munbat AI offers a free tier with basic features. Premium '
                'features are available through our subscription plans.',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(widget.question, style: AppTextStyles.h3.copyWith(fontSize: 15)),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.textSecondary,
        ),
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              widget.answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
