import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/settings_tile.dart';

/// Settings screen. Intentionally limited to exactly three entries —
/// Contact Us, Community, Copyright Alert. No account/profile/theme/
/// notification settings, per the product scope.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsTile(
            icon: Icons.mail_outline,
            title: 'Contact Us',
            onTap: () => context.push('/settings/contact'),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.groups_outlined,
            title: 'Community',
            onTap: () => context.push('/settings/community'),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.shield_outlined,
            title: 'Copyright Alert',
            onTap: () => context.push('/settings/copyright'),
          ),
        ],
      ),
    );
  }
}
