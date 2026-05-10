// lib/core/widgets/icon_button_svg.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';

class IconButtonSvg extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double? size;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const IconButtonSvg({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.size = 24,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: padding ?? const EdgeInsets.all(8),
      icon: SvgIcon(
        assetPath: assetPath,
        size: size,
        color: color,
      ),
    );
  }
}