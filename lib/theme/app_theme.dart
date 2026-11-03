import 'package:flutter/material.dart';

abstract final class AppTokens {
  static const cyan = Color(0xFF75B7C7);
  static const violet = Color(0xFF75B7C7);
  static const ink = Color(0xFF111518);
  static const cream = Color(0xFFEFEFEB);
  static const navbarHeight = 64.0;
  static const maxWidth = 1200.0;
  static const sectionGap = 110.0;

  static BoxDecoration glass(BuildContext context, {double radius = 8}) {
    final colors = Theme.of(context).colorScheme;
    final dark = colors.brightness == Brightness.dark;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: dark ? const Color(0xFF171D21) : const Color(0xFFF7F6F2),
      border: Border.all(color: colors.onSurface.withValues(alpha: .09)),
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
          secondary: dark ? violet : const Color(0xFF346D7A),
          tertiary: dark ? violet : const Color(0xFF346D7A),
          onSurface: dark ? const Color(0xFFE5E9EA) : const Color(0xFF19233C),
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      dividerColor: colors.onSurface.withValues(alpha: dark ? .1 : .14),
      hintColor: dark ? const Color(0xFFA1ABB0) : const Color(0xFF52617D),
      textTheme: ThemeData().textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dark ? const Color(0xFF191F23) : cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.primary.withValues(alpha: .25)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: dark ? const Color(0xFF171D21) : cream,
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
