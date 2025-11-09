import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

/// Settings screen for app preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // User profile section
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.primary,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    currentUser?.email[0].toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentUser?.email ?? 'No email',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: currentUser?.emailVerified ?? false
                        // ignore: deprecated_member_use
                        ? AppColors.success.withOpacity(0.2)
                        // ignore: deprecated_member_use
                        : AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentUser?.emailVerified ?? false
                        ? 'Email Verified'
                        : 'Email Not Verified',
                    style: TextStyle(
                      fontSize: 12,
                      color: currentUser?.emailVerified ?? false
                          ? AppColors.success
                          : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notification settings
          _SettingsSection(
            title: 'Notifications',
            children: [
              SwitchListTile(
                title: const Text(AppStrings.notificationReminders),
                subtitle: const Text('Get notified about swap updates'),
                value: settings.notificationReminders,
                activeThumbColor: AppColors.secondary,
                onChanged: (_) => settingsNotifier.toggleNotificationReminders(),
              ),
              SwitchListTile(
                title: const Text(AppStrings.emailUpdates),
                subtitle: const Text('Receive updates via email'),
                value: settings.emailUpdates,
                activeThumbColor: AppColors.secondary,
                onChanged: (_) => settingsNotifier.toggleEmailUpdates(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // About section
          _SettingsSection(
            title: AppStrings.about,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: AppStrings.appName,
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    children: [
                      const Text(
                        'A marketplace for students to swap textbooks with each other.',
                      ),
                    ],
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy Policy coming soon'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms of Service coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sign out section
          _SettingsSection(
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  AppStrings.signOut,
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () => _showSignOutDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authNotifier = ref.read(authNotifierProvider.notifier);
              await authNotifier.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

/// Settings section widget
class _SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SettingsSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }
}