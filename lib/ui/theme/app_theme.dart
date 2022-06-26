import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = const ColorScheme.light().copyWith(
  primary: const Color(0xFF2C459E),
  onPrimary: Colors.white,
  secondary: const Color(0xFF15A4DE),
  onSecondary: Colors.white,
  shadow: Colors.black.withOpacity(0.05),
);

final kAppTheme = ThemeData.light().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);
