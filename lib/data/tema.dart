import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTema {
  static const Color verde = Color(0xFF1B4332);
  static const Color menta = Color(0xFF52B788);
  static const Color mentaClaro = Color(0xFFD8F3DC);
  static const Color ambar = Color(0xFFF4A261);
  static const Color fondo = Color(0xFFF8F9F4);
  static const Color textoOscuro = Color(0xFF1C2926);
  static const Color textoMedio = Color(0xFF4A6358);
  static const Color textoClaro = Color(0xFF8AAE9E);
  static const Color borde = Color(0xFFD5E8DF);
  static const Color circular = Color(0xFF0D7377);
  static const Color circularClaro = Color(0xFFE0F5F5);

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: verde,
        secondary: menta,
        tertiary: ambar,
        surface: fondo,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: fondo,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textoOscuro,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textoOscuro,
        ),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: textoMedio),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: textoClaro),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: verde,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verde,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borde, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: menta, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textoClaro, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
