import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/portfolio_providers.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ProviderScope(child: PortfolioApp()));

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Hardik - Flutter Developer',
    theme: AppTokens.theme(false),
    darkTheme: AppTokens.theme(true),
    themeMode: ref.watch(themeModeProvider),
    themeAnimationDuration: const Duration(milliseconds: 450),
    home: const PortfolioScreen(),
  );
}
