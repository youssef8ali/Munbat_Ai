import 'dart:io';
import 'package:flutter/material.dart';

// Disease image section
class DiagnosisImageSection extends StatelessWidget {
  final String imagePath;

  const DiagnosisImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey[300],
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      ),
    );
  }
}
