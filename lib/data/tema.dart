import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTema {
  // Identidad visual: verde como color principal y naranja como acento.
  static const Color verde = Color(0xFF286B45);
  static const Color verdeOscuro = Color(0xFF194B32);
  static const Color menta = Color(0xFF58A66A);
  static const Color mentaClaro = Color(0xFFEAF5EC);
  static const Color ambar = Color(0xFFF29A38);
  static const Color naranjaClaro = Color(0xFFFFF1E2);
  static const Color fondo = Color(0xFFF6F8F5);
  static const Color textoOscuro = Color(0xFF24342B);
  static const Color textoMedio = Color(0xFF5C6D61);
  static const Color textoClaro = Color(0xFF87968B);
  static const Color borde = Color(0xFFDCE7DE);
  static const Color circular = Color(0xFF347B68);
  static const Color circularClaro = Color(0xFFE6F3EF);

  static ThemeData get tema {
    final base = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: verde,
        brightness: Brightness.light,
        primary: verde,
        secondary: ambar,
        tertiary: menta,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: fondo,
      textTheme: base.copyWith(
        headlineSmall: GoogleFonts.inter(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: textoOscuro,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: textoOscuro,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textoOscuro,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textoMedio,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: textoClaro,
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: verdeOscuro,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: verdeOscuro,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verde,
          foregroundColor: Colors.white,
          disabledBackgroundColor: borde,
          disabledForegroundColor: textoClaro,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: verde,
          side: const BorderSide(color: borde),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borde, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: verde, width: 1.8),
        ),
        hintStyle: GoogleFonts.inter(color: textoClaro, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: verde,
        linearTrackColor: borde,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: verde,
        thumbColor: ambar,
        inactiveTrackColor: borde,
        overlayColor: Color(0x22F29A38),
      ),
      dividerTheme: const DividerThemeData(color: borde, thickness: 1),
    );
  }
}
