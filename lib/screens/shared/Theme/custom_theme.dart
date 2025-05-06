import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5E35B1), // Deep purple
        secondary: Color(0xFF00ACC1), // Teal
        surface: Colors.white,
        surfaceBright: Color(0xFFF5F5F5), // Light gray background
        error: Color(0xFFE53935), // Red
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onSurfaceVariant: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),

      // Text Theme (Using Google Fonts - Roboto is a safe choice for readability)
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5E35B1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5E35B1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme (for TextFields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5E35B1), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        hintStyle: GoogleFonts.roboto(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),

      // Card Theme (for message bubbles)
      cardTheme: CardTheme(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // side: BorderSide(color: Colors.black)
        ),
        color: Colors.blueGrey,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
        space: 0,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF5E35B1),
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5E35B1),
        unselectedItemColor: Colors.grey[600],
        elevation: 2,
        showUnselectedLabels: true,
      ),

      // Chip Theme (for message status, tags, etc.)
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200],
        disabledColor: Colors.grey[300],
        selectedColor: const Color(0xFF5E35B1),
        secondarySelectedColor: const Color(0xFF5E35B1),
        labelStyle: GoogleFonts.roboto(
          color: Colors.black87,
          fontSize: 12,
        ),
        secondaryLabelStyle: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 12,
        ),
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        contentTextStyle: GoogleFonts.roboto(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final lightTheme = CustomTheme.lightTheme;
    return lightTheme.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9575CD), // Lighter purple
        secondary: Color(0xFF4DD0E1), // Lighter teal
        surface: Color(0xFF121212),
        surfaceBright: Color(0xFF121212),
        error: Color(0xFFEF5350),
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white,
        onError: Colors.black87,
        brightness: Brightness.dark,
      ),
      cardTheme: lightTheme.cardTheme.copyWith(
        color: const Color(0xFF1E1E1E),
      ),
      textTheme: lightTheme.textTheme.copyWith(
        displayLarge: lightTheme.textTheme.displayLarge?.copyWith(
          color: Colors.white,
        ),
        displayMedium: lightTheme.textTheme.displayMedium?.copyWith(
          color: Colors.white,
        ),
        bodyLarge: lightTheme.textTheme.bodyLarge?.copyWith(
          color: Colors.white,
        ),
        bodyMedium: lightTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white70,
        ),
        titleMedium: lightTheme.textTheme.titleMedium?.copyWith(
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: const Color(0xFF1E1E1E),
        hintStyle: lightTheme.inputDecorationTheme.hintStyle?.copyWith(
          color: Colors.grey[400],
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF9575CD),
        unselectedItemColor: Colors.grey[500],
      ),
    );
  }
}
