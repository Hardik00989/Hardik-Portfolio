import 'package:flutter/material.dart';
import '../widgets/rotating_role.dart';
import '../widgets/app_development_illustration.dart';
import '../utils/portfolio_data.dart';
import '../widgets/shared.dart';
import '../theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback viewWork, download;
  final ValueNotifier<double> scroll;
  const HeroSection({
    super.key,
    required this.viewWork,
    required this.download,
    required this.scroll,
  });
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final mobile = box.maxWidth < 700;
      final copy = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: AppTokens.cyan, size: 7),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'FLUTTER DEVELOPER / INDIA',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Thoughtful code.\nMeaningful\nexperiences.',
            style: TextStyle(
              fontSize: mobile ? (box.maxWidth < 330 ? 43 : 52) : 76,
              height: 1.02,
              fontWeight: FontWeight.w500,
              letterSpacing: -2.5,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Hey, I'm ${PortfolioData.name}.",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 48, child: RotatingRole()),
          const SizedBox(height: 16),
          const Text(
            'Cross-platform apps, team tools, and mobile games.\nBuilt with Flutter, Dart, and attention to detail.',
            style: TextStyle(fontSize: 14, height: 1.8),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AnimatedButton(label: 'Explore my work', onTap: viewWork),
              AnimatedButton(
                label: 'Download CV',
                onTap: download,
                filled: false,
                icon: Icons.south,
              ),
            ],
          ),
        ],
      );
      final notes = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Built with care.\nMade to matter.',
            style: const TextStyle(
              fontSize: 26,
              height: 1.3,
              letterSpacing: -.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'DESIGN  ×  DEVELOPMENT',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.4,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '\u2726  A little detail. A lot of intention.',
            style: TextStyle(
              fontSize: 11,
              height: 1.7,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\u2197  Always curious. Always building.',
            style: TextStyle(
              fontSize: 11,
              height: 1.7,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      );
      return Padding(
        padding: const EdgeInsets.only(top: 72, bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (box.maxWidth >= 1000)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 7, child: RevealOnScroll(child: copy)),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppDevelopmentIllustration(),
                        const SizedBox(height: 28),
                        notes,
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              RevealOnScroll(child: copy),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: const AppDevelopmentIllustration(),
                ),
              ),
              const SizedBox(height: 28),
              notes,
            ],
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 20,
              runSpacing: 12,
              children: [
                Text(
                  'FLUTTER / FIREBASE / FLAME',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.4,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                TextButton(
                  onPressed: viewWork,
                  child: const Text(
                    'SCROLL TO EXPLORE  \u2193',
                    style: TextStyle(fontSize: 9, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
