import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = const ColorScheme.light().copyWith(
  primary: const Color(0xFF137A91),
  onPrimary: Colors.white,
  secondary: const Color(0xFF1AB6D9),
  onSecondary: Colors.white,
  shadow: Colors.black.withOpacity(0.05),
  tertiary: const Color(0xFF02A966),
  error: const Color(0xFFE35300),
  onBackground: const Color(0xFF232323),
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
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: Get.textTheme.bodySmall,
  ),
);
