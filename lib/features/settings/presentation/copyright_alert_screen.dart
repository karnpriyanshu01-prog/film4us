import 'package:flutter/material.dart';

/// Short, readable legal/copyright information screen.
///
/// Placeholder text only — intended to be replaced with the actual
/// rights owner's legal notice. Film4us makes no claims about content
/// licensing here.
class CopyrightAlertScreen extends StatelessWidget {
  const CopyrightAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(title: const Text('Copyright Alert')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Copyright & Content Notice', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(
            'Film4us does not host or own any media files displayed within '
            'the application. All sources are provided by third parties '
            'and are surfaced here for convenience only.',
            style: bodyStyle,
          ),
          const SizedBox(height: 12),
          Text(
            'If you are a rights holder and believe content accessible '
            'through Film4us infringes your copyright, please contact us '
            'via the Contact Us section with details of the content in '
            'question so it can be reviewed.',
            style: bodyStyle,
          ),
          const SizedBox(height: 12),
          Text(
            'This placeholder notice will be replaced with the full legal '
            'text provided by the application owner.',
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}
