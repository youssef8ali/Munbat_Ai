class AppConstants {
  // API
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border Radius
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Image Sizes
  static const double featuredImageHeight = 200.0;
  static const double listImageSize = 120.0;
  
  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Categories
  static const List<String> categories = ['All', 'Fruits', 'Vegetables', 'Other'];
}
