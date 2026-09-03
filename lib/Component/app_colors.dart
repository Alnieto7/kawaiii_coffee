import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─────────────────────────────────────────
  // Brand
  // ─────────────────────────────────────────
  static const Color primary        = Color(0xFF1D7A44); // hijau utama
  static const Color primaryDark    = Color(0xFF125028); // hijau gelap
  static const Color primaryLight   = Color(0xFF4CAF72); // hijau terang
  static const Color primarySurface = Color(0xFFE8F5ED); // hijau sangat muda (background card)

  static const Color secondary      = Color(0xFF1A5C30); // hijau tua (logo, aksen)
  static const Color secondaryLight = Color(0xFFB4C8AF); // hijau abu muda

  // ─────────────────────────────────────────
  // Background
  // ─────────────────────────────────────────
  static const Color backgroundDark    = Color(0xFF0D1A0F); // splash
  static const Color backgroundLight   = Color(0xFFF7F9F7); // halaman utama
  static const Color backgroundWhite   = Color(0xFFFFFFFF);
  static const Color backgroundCard    = Color(0xFFFFFFFF);
  static const Color backgroundOverlay = Color(0x801A1A1A); // overlay modal

  // ─────────────────────────────────────────
  // Text
  // ─────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A1A); // judul utama
  static const Color textSecondary = Color(0xFF5A5A5A); // subjudul / label
  static const Color textHint      = Color(0xFFAAAAAA); // placeholder
  static const Color textDisabled  = Color(0xFFCCCCCC);
  static const Color textOnPrimary = Color(0xFFFFFFFF); // teks di atas warna primary
  static const Color textOnDark    = Color(0xFFF0ECE3); // teks di atas background gelap

  // ─────────────────────────────────────────
  // Status
  // ─────────────────────────────────────────
  static const Color success        = Color(0xFF2E7D32);
  static const Color successSurface = Color(0xFFE8F5E9);
  static const Color warning        = Color(0xFFF57C00);
  static const Color warningSurface = Color(0xFFFFF3E0);
  static const Color error          = Color(0xFFC62828);
  static const Color errorSurface   = Color(0xFFFFEBEE);
  static const Color info           = Color(0xFF1565C0);
  static const Color infoSurface    = Color(0xFFE3F2FD);

  // ─────────────────────────────────────────
  // Border & Divider
  // ─────────────────────────────────────────
  static const Color border        = Color(0xFFE0E0E0);
  static const Color borderFocus   = Color(0xFF1D7A44);
  static const Color divider       = Color(0xFFF0F0F0);

  // ─────────────────────────────────────────
  // Input
  // ─────────────────────────────────────────
  static const Color inputFill     = Color(0xFFF5F5F5);
  static const Color inputBorder   = Color(0xFFE0E0E0);

  // ─────────────────────────────────────────
  // Shadow
  // ─────────────────────────────────────────
  static const Color shadow        = Color(0x1A000000);
  static const Color shadowDark    = Color(0x66000000);

  // ─────────────────────────────────────────
  // Splash spesifik
  // ─────────────────────────────────────────
  static const Color splashGlowTop    = Color(0xFF125028);
  static const Color splashGlowBottom = Color(0xFF0A371C);
  static const Color splashSubtitle   = Color(0x66B4C8AF);
  static const Color splashDivider    = Color(0x1AFFFFFF);
  static const Color splashTagline    = Color(0x4DB4C8AF);
  static const Color loaderTrack      = Color(0x14FFFFFF);
}