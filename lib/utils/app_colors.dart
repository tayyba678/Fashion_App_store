import 'package:flutter/material.dart';

//TODO:: All app colors live here. Change a color here and it changes everywhere.
class AppColors {
  AppColors._(); // TODO:: Private constructor so nobody creates an object of this class

  //TODO:: Background colors
  static const Color welcomeBg = Color(0xFFE3D5CA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color homeHeaderBg = Color(0xFFE3D5CA);
  static const Color homeBg = Color(0xFFEDEDE9);
  static const Color loadingOverlay = Color(0x40000000);
  static const Color transparent = Colors.transparent;

  //TODO:: Navigation and Tabs
  static const Color selectedTab = Color(0xFFD6CCC2);
  static const Color bottomNav = Color(0xFFD5BDAF);
  static const Color badge = Color(0xFFF59E0B);

  //TODO:: Primary and Action colors
  static const Color primary = Color(0xFFD7BCAB);
  static const Color pink = Color(0xFFFF8FA7);
  static const Color actionButton = Color(0xFFE3D5CA);

  //TODO:: Text and UI element colors
  static const Color grey = Color(0xFF8A8A8A);
  static const Color greyText = Color(0xFF777777);
  static const Color hintText = Color(0xFFBFBFCF);
  static const Color shadow = Color(0x0F000000);
  static const Color divider = Color(0x59777777);
  
  //TODO:: Product detail colors.
  static const Color selectedThumbnailBorder = Color(0xFF000000);
  static const Color quantityBackground = Color(0xFFE3D5CA);
  static const Color priceBlack = Color(0xFF1E1E1E);

  //TODO:: Used for error messages
  static const Color error = Color(0xFFD32F2F);
}
