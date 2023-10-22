import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFFD30C54);
const errorColor = Color(0xFFB62828);
const darkBgColor = Color(0xff0a0206);

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.grey.shade200,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.normal
      ),
      bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500
      ),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
      headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
      labelMedium: GoogleFonts.poppins(
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none
      ),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
    )
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBgColor,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: darkBgColor,
      onBackground: Colors.white,
      surface: Colors.grey.shade900,
      onSurface: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all<Color>(Colors.grey),
      thumbColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.normal
      ),
      bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500
      ),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
      headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
      labelMedium: GoogleFonts.poppins(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none
      ),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
    )
);