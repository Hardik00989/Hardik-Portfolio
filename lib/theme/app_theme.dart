import 'package:flutter/material.dart';

abstract final class AppTokens {
  static const cyan = Color(0xFF53F5FF);
  static const violet = Color(0xFFB69CFF);
  static const ink = Color(0xFF080D1B);
  static const cream = Color(0xFFF1F3FC);
  static const maxWidth = 1200.0;
  static const sectionGap = 110.0;

  static BoxDecoration glass(BuildContext context, {double radius = 16}) {
    final colors = Theme.of(context).colorScheme;
    final dark = colors.brightness == Brightness.dark;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          dark
              ? colors.onSurface.withValues(alpha: .065)
              : Colors.white.withValues(alpha: .85),
          dark
              ? colors.onSurface.withValues(alpha: .025)
              : Colors.white.withValues(alpha: .45),
        ],
      ),
      border: Border.all(
        color: colors.primary.withValues(alpha: dark ? .22 : .18),
      ),
      boxShadow: [
        BoxShadow(
          color: colors.shadow.withValues(alpha: dark ? .12 : .035),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData theme(bool dark) {
    final colors =
        ColorScheme.fromSeed(
          seedColor: cyan,
          brightness: dark ? Brightness.dark : Brightness.light,
          surface: dark ? ink : cream,
        ).copyWith(
          primary: dark ? cyan : const Color(0xFF006B79),
          onPrimary: dark ? ink : Colors.white,
          secondary: dark ? violet : const Color(0xFF6843C8),
          tertiary: dark ? violet : const Color(0xFF6843C8),
          onSurface: dark ? const Color(0xFFEAF0FF) : const Color(0xFF19233C),
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      dividerColor: colors.primary.withValues(alpha: dark ? .2 : .14),
      hintColor: dark ? const Color(0xFFA6B4D0) : const Color(0xFF52617D),
      textTheme: ThemeData().textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dark ? const Color(0xFF111A2E) : cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.primary.withValues(alpha: .25)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: dark ? const Color(0xFF10182A) : cream,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.primary.withValues(alpha: .08),
        side: BorderSide(color: colors.primary.withValues(alpha: .22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.onSurface.withValues(alpha: dark ? .045 : .035),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: .2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: .2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
