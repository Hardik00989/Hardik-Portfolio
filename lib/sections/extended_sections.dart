import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/download.dart';
import '../utils/portfolio_data.dart';
import '../widgets/scroll_driven_case_studies.dart';
import '../widgets/shared.dart';

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
      ...PortfolioData.capabilities.map(
        (item) => Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, box) {
              final heading = Text(
                item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -.6,
                ),
              );
              final detail = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _muted(context, item.description),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 7,
                    runSpacing: 8,
                    children: item.tools
                        .map((tool) => _tag(context, tool))
                        .toList(),
                  ),
                ],
              );
              return box.maxWidth < 650
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [heading, const SizedBox(height: 18), detail],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: heading),
                        const SizedBox(width: 44),
                        Expanded(flex: 6, child: detail),
                      ],
                    );
            },
          ),
        ),
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

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '07',
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
