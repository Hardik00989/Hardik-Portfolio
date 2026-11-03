import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_providers.dart';
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/portfolio_data.dart';
import '../widgets/shared.dart';

class ContactSection extends ConsumerStatefulWidget {
  const ContactSection({super.key});
  @override
  ConsumerState<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends ConsumerState<ContactSection> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      message = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    message.dispose();
    super.dispose();
  }

  Future<void> send() async {
    if (!form.currentState!.validate()) return;
    await ref.read(contactSubmissionProvider.notifier).submit(() async {
      final uri = Uri(
        scheme: 'mailto',
        path: PortfolioData.email,
        query:
            'subject=${Uri.encodeComponent('Portfolio enquiry from ${name.text.trim()}')}&body=${Uri.encodeComponent('From: ${email.text.trim()}\n\n${message.text.trim()}')}',
      );
      try {
        final success = await launchUrl(uri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Your email app is ready. Send your message there.'
                    : 'No email app found. Please email ${PortfolioData.email} directly.',
              ),
            ),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please email ${PortfolioData.email} directly.'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sending = ref.watch(contactSubmissionProvider);
    return LayoutBuilder(
      builder: (context, box) {
        final intro = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              number: '08',
              label: 'LET’S MAKE SOMETHING',
              title: 'Good things start\nwith a hello.',
            ),
            const SizedBox(height: 25),
            Text(
              'Have a project in mind, a question, or just a good idea?\nI’d love to hear about it.',
              style: TextStyle(
                fontSize: 14,
                height: 1.8,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 25),
            SelectableText(
              PortfolioData.email,
              style: const TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AnimatedButton(
                  label: 'Email me',
                  filled: false,
                  icon: Icons.mail_outline,
                  onTap: () => launchUrl(
                    Uri(scheme: 'mailto', path: PortfolioData.email),
                  ),
                ),
                AnimatedButton(
                  label: 'Call',
                  filled: false,
                  icon: Icons.phone_outlined,
                  onTap: () => launchUrl(Uri.parse(PortfolioData.phoneUri)),
                ),
                AnimatedButton(
                  label: 'LinkedIn',
                  filled: false,
                  onTap: () => launchUrl(Uri.parse(PortfolioData.linkedin)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${PortfolioData.location} / ${PortfolioData.phone}',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        );
        final fields = Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTokens.glass(context),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: name,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(labelText: 'Your name'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter your name.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: email,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (v) =>
                      v == null ||
                          !RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(v.trim())
                      ? 'Enter a valid email address.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: message,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'Tell me about your idea',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => v == null || v.trim().length < 10
                      ? 'Please write at least 10 characters.'
                      : null,
                ),
                const SizedBox(height: 20),
                AnimatedButton(
                  label: sending ? 'Opening email…' : 'Let’s talk',
                  onTap: () {
                    if (!sending) send();
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Opens your email app. No messages are stored on this site.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        );
        return box.maxWidth < 750
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 35), fields],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: intro),
                  const SizedBox(width: 65),
                  Expanded(child: fields),
                ],
              );
      },
    );
  }
}
