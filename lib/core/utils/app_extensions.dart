import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // MediaQuery
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  
  // Navigation
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }
}

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}