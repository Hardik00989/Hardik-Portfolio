import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/portfolio_data.dart';
import '../widgets/shared.dart';
import '../widgets/skill_icon.dart';
import '../theme/app_theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final portrait = HoverSurface(
        tilt: true,
        child: Container(
          height: 370,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/hardik.jpg',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -.25),
                  semanticLabel: 'Portrait of Hardik, Flutter developer',
                  filterQuality: FilterQuality.medium,
                ),
              ),
              Positioned(
                left: 22,
                bottom: 22,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: .9),
                  child: Text(
                    'HARDIK / FLUTTER DEVELOPER',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            number: '01',
            label: 'A LITTLE ABOUT ME',
            title: 'Cross-platform apps.\nPlayful experiences.',
          ),
          const SizedBox(height: 25),
          const Text(
            PortfolioData.bio,
            style: TextStyle(fontSize: 15, height: 1.9),
          ),
          const SizedBox(height: 16),
          Text(
            PortfolioData.about,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 30),
          const Wrap(
            spacing: 45,
            runSpacing: 20,
            children: [
              CountStat(value: 3, label: 'Featured projects', suffix: ''),
              CountStat(value: 2, label: 'Professional roles', suffix: ''),
              CountStat(value: 2, label: 'Degrees earned', suffix: ''),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Based in ${PortfolioData.location} / ${PortfolioData.languages}',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => launchUrl(
              Uri.base.resolve(PortfolioData.cvFile),
              webOnlyWindowName: '_blank',
            ),
            icon: const Icon(Icons.description_outlined, size: 18),
            label: const Text('View r\u00e9sum\u00e9'),
          ),
        ],
      );
      return box.maxWidth < 700
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 35), portrait],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: portrait),
                const SizedBox(width: 75),
                Expanded(flex: 6, child: text),
              ],
            );
    },
  );
}

class CountStat extends StatefulWidget {
  final int value;
  final String label, suffix;
  const CountStat({
    super.key,
    required this.value,
    required this.label,
    this.suffix = '+',
  });
  @override
  State<CountStat> createState() => _CountStatState();
}

class _CountStatState extends State<CountStat> {
  bool started = false;
  @override
  Widget build(BuildContext context) => RevealOnScroll(
    onReveal: () => setState(() => started = true),
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: started ? widget.value.toDouble() : 0),
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 1800,
      ),
      builder: (context, value, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${value.round()}${widget.suffix}',
            style: const TextStyle(fontSize: 37, letterSpacing: -2),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    ),
  );
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '02',
        label: 'MY TOOLKIT',
        title: 'The right tools.\nThe right touch.',
      ),
      const SizedBox(height: 20),
      Text(
        'The technologies I use, grouped by what they help me build.',
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 14,
          height: 1.7,
        ),
      ),
      const SizedBox(height: 32),
      LayoutBuilder(
        builder: (context, box) {
          final columns = box.maxWidth >= 800 ? 2 : 1;
          final width = (box.maxWidth - (columns - 1) * 20) / columns;
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(PortfolioData.skillGroups.length, (i) {
              final group = PortfolioData.skillGroups[i];
              return SizedBox(
                width: width,
                child: RevealOnScroll(
                  delay: i * 70,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: AppTokens.glass(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.title,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          group.description,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children: group.skills
                              .map(
                                (skill) => HoverSurface(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: .035),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SkillIcon(skill: skill),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            skill,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    ],
  );
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '04',
        label: 'EXPERIENCE & EDUCATION',
        title: 'Where I have worked.\nWhat I have learned.',
      ),
      const SizedBox(height: 20),
      Text(
        'Professional work and the education behind it.',
        style: TextStyle(
          fontSize: 14,
          height: 1.7,
          color: Theme.of(context).hintColor,
        ),
      ),
      const SizedBox(height: 35),
      LayoutBuilder(
        builder: (context, box) {
          final work = _JourneyColumn(
            label: 'PROFESSIONAL EXPERIENCE',
            entries: PortfolioData.timeline.take(2).toList(),
          );
          final education = _JourneyColumn(
            label: 'EDUCATION',
            entries: PortfolioData.timeline.skip(2).toList(),
          );
          return box.maxWidth < 800
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [work, const SizedBox(height: 28), education],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: work),
                    const SizedBox(width: 28),
                    Expanded(child: education),
                  ],
                );
        },
      ),
    ],
  );
}

class _JourneyColumn extends StatelessWidget {
  final String label;
  final List<({String date, String title, String description})> entries;
  const _JourneyColumn({required this.label, required this.entries});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.8,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 20),
      ...List.generate(entries.length, (i) {
        final entry = entries[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RevealOnScroll(
            delay: i * 100,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTokens.glass(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 7, color: AppTokens.cyan),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.date,
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    entry.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.8,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ],
  );
}
