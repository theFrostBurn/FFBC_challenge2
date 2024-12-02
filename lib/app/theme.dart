import 'package:flutter/material.dart';

class AppTheme {
  // 색상 상수
  static const Color primaryColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFF0095F6);
  static const Color greyColor = Color(0xFF262626);
  static const Color darkGreyColor = Color(0xFF121212);
  static const Color errorColor = Color(0xFFED4956);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color linkColor = Color(0xFF2196F3);

  // 애니메이션 지속 시간
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: secondaryColor,
      surface: greyColor,
      surfaceContainerHighest: primaryColor,
      error: errorColor,
      onSurface: secondaryColor,
    ),

    // AppBar 테마
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: secondaryColor),
      titleTextStyle: TextStyle(
        color: secondaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
    ),

    // 텍스트 테마
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: secondaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        color: secondaryColor,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: Colors.grey,
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      labelLarge: TextStyle(
        color: secondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),

    // 하단 네비게이션 바 테마
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: secondaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
    ),

    // 카드 테마
    cardTheme: CardTheme(
      color: greyColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: greyColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(
        color: secondaryColor.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),

    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: secondaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // 아이콘 테마
    iconTheme: const IconThemeData(
      color: secondaryColor,
      size: 24,
    ),

    // 디바이더 테마
    dividerTheme: DividerThemeData(
      color: greyColor.withOpacity(0.2),
      thickness: 1,
      space: 1,
    ),

    // 페이지 전환 애니메이션
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
