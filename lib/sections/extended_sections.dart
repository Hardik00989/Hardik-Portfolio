import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/download.dart';
import '../utils/portfolio_data.dart';
import '../widgets/scroll_driven_case_studies.dart';
import '../widgets/shared.dart';
import '../widgets/skill_icon.dart';

class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '02',
        label: 'WHAT I BUILD',
        title: 'Apps. Games.\nConnected experiences.',
      ),
      const SizedBox(height: 20),
      _muted(
        context,
        'Three areas where my application work and game engineering come together.',
      ),
      const SizedBox(height: 32),
      _TileGrid(
        maxColumns: 3,
        children: PortfolioData.capabilities
            .map(
              (item) => Container(
                padding: const EdgeInsets.all(26),
                decoration: AppTokens.glass(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SkillIcon(skill: item.icon),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _muted(context, item.description),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 7,
                      runSpacing: 8,
                      children: item.tools
                          .map((tool) => _tag(context, tool))
                          .toList(),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

class CaseStudiesSection extends StatelessWidget {
  const CaseStudiesSection({super.key});
  @override
  Widget build(BuildContext context) => const ScrollDrivenCaseStudies();
}

class _StoryPoint extends StatelessWidget {
  final String label, text;
  const _StoryPoint({required this.label, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 9),
        _muted(context, text),
      ],
    ),
  );
}

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '07',
        label: 'ENGINEERING HIGHLIGHTS',
        title: 'Small details.\nSubstantial systems.',
      ),
      const SizedBox(height: 20),
      _muted(
        context,
        'Selected implementation details from my projects and résumé.',
      ),
      const SizedBox(height: 32),
      _TileGrid(
        maxColumns: 4,
        children: PortfolioData.engineeringHighlights
            .map(
              (item) => Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTokens.glass(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _muted(context, item.detail),
                    const SizedBox(height: 20),
                    _tag(context, item.project),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '08',
        label: 'TAKE A CLOSER LOOK',
        title: 'The full picture.\nReady to download.',
      ),
      const SizedBox(height: 32),
      Container(
        padding: const EdgeInsets.all(28),
        decoration: AppTokens.glass(context, radius: 20),
        child: LayoutBuilder(
          builder: (context, box) {
            final intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 46,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hardik / Flutter Developer',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.8,
                  ),
                ),
                const SizedBox(height: 16),
                _muted(
                  context,
                  'A portable overview of my professional experience, application and game projects, technical skills, and education.',
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AnimatedButton(
                      label: 'View résumé',
                      icon: Icons.open_in_new,
                      onTap: () => launchUrl(
                        Uri.base.resolve(PortfolioData.cvFile),
                        webOnlyWindowName: '_blank',
                      ),
                    ),
                    AnimatedButton(
                      label: 'Download CV',
                      filled: false,
                      icon: Icons.download_outlined,
                      onTap: downloadCv,
                    ),
                  ],
                ),
              ],
            );
            final facts = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StoryPoint(
                  label: 'PROFESSIONAL EXPERIENCE',
                  text:
                      'Flutter Developer at VR Automations and SGN Solutions.',
                ),
                const _StoryPoint(
                  label: 'SELECTED WORK',
                  text: 'Team Pulse / Blocktopus / NovaStrike',
                ),
                const _StoryPoint(
                  label: 'EDUCATION',
                  text:
                      'Master of Computer Applications and Bachelor of Computer Applications, Mullana.',
                ),
                _StoryPoint(
                  label: 'BASED IN',
                  text: '${PortfolioData.location}\n${PortfolioData.languages}',
                ),
              ],
            );
            return box.maxWidth < 760
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      intro,
                      const SizedBox(height: 36),
                      const Divider(),
                      const SizedBox(height: 24),
                      facts,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: intro),
                      const SizedBox(width: 60),
                      Expanded(flex: 4, child: facts),
                    ],
                  );
          },
        ),
      ),
    ],
  );
}

class _TileGrid extends StatelessWidget {
  final int maxColumns;
  final List<Widget> children;
  const _TileGrid({required this.maxColumns, required this.children});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final count = (box.maxWidth / 260).floor().clamp(1, maxColumns);
      final width = (box.maxWidth - (count - 1) * 20) / count;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: List.generate(
          children.length,
          (i) => SizedBox(
            width: width,
            child: RevealOnScroll(delay: i * 70, child: children[i]),
          ),
        ),
      );
    },
  );
}

Widget _muted(BuildContext context, String text) => Text(
  text,
  style: TextStyle(
    fontSize: 14,
    height: 1.8,
    color: Theme.of(context).hintColor,
  ),
);

Widget _tag(BuildContext context, String text) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary.withValues(alpha: .07),
    borderRadius: BorderRadius.circular(6),
  ),
  child: Text(
    text,
    style: TextStyle(
      fontSize: 10,
      color: Theme.of(context).colorScheme.primary,
    ),
  ),
);
