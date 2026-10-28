import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;
  const ProjectDetails({super.key, required this.project});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(project.title),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.category,
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              project.description,
              style: const TextStyle(fontSize: 15, height: 1.8),
            ),
            const SizedBox(height: 24),
            const Text(
              'What I built',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            ...project.highlights.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 17,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(fontSize: 13, height: 1.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Technology',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.stack
                  .map(
                    (name) => Chip(
                      label: Text(name, style: const TextStyle(fontSize: 11)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Technical notes',
                style: TextStyle(fontSize: 14),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    project.details,
                    style: const TextStyle(fontSize: 13, height: 1.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      if (project.url.isNotEmpty)
        TextButton.icon(
          onPressed: () => launchUrl(
            Uri.parse(project.url),
            mode: LaunchMode.externalApplication,
            webOnlyWindowName: '_blank',
          ),
          icon: const Icon(Icons.north_east, size: 17),
          label: Text(project.linkLabel),
        ),
    ],
  );
}
