import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = const ColorScheme.light().copyWith(
  primary: const Color(0xFF2C459E),
  onPrimary: Colors.white,
  secondary: const Color(0xFF15A4DE),
  onSecondary: Colors.white,
  shadow: Colors.black.withOpacity(0.05),
  tertiary: const Color.fromARGB(255, 2, 169, 8),
  error: const Color.fromARGB(255, 227, 15, 0),
  onBackground: const Color.fromARGB(255, 35, 35, 35),
);

final kAppTheme = ThemeData.light().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ),
  ),
  scaffoldBackgroundColor: kColorScheme.background,
  textTheme: GoogleFonts.poppinsTextTheme(),
);
