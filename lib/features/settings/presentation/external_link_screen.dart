import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';

/// Minimal screen that explains a destination and opens it externally.
///
/// Used for both Contact Us and Community so the two screens share one
/// simple, consistent layout instead of duplicating UI.
class ExternalLinkScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final String url;
  final String buttonLabel;

  const ExternalLinkScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.url,
    required this.buttonLabel,
  });

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _openLink(context),
                child: Text(buttonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
