// lib/features/chat/presentation/widgets/chat_message.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:munbat_ai/core/constants/app_icons.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';
import 'package:munbat_ai/features/chat/data/models/chat_message.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  // ✅ بتكتشف لو النص عربي
  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabic(message.text);
    final textDir = isArabic ? TextDirection.rtl : TextDirection.ltr;
    final textAlign = isArabic ? TextAlign.right : TextAlign.left;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          if (message.isBot)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Munbat AI',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isBot
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.isBot)
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: SvgIcon(
                    assetPath: AppIcons.logo,
                    color: AppColors.primary,
                  ),
                ),
              Flexible(
                child: Directionality(
                  textDirection: textDir,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          message.isBot ? AppColors.white : AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: message.isBot
                        ? MarkdownBody(
                            data: message.text,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                              textAlign: isArabic
                                  ? WrapAlignment.end
                                  : WrapAlignment.start,
                              p: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              strong: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              em: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontStyle: FontStyle.italic,
                              ),
                              listBullet: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              h1: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              h2: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              h3: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              blockSpacing: 8,
                              listIndent: 16,
                            ),
                          )
                        : Text(
                            message.text,
                            textDirection: textDir,
                            textAlign: textAlign,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          if (!message.isBot)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: Text(
                'Read ${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')} AM',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}