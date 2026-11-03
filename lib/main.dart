import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ProviderScope(child: PortfolioApp()));

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Hardik - Flutter Developer',
    theme: AppTokens.theme(true),
    themeMode: ThemeMode.dark,
    home: const PortfolioScreen(),
  );
}
