import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rounded_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationPrefs = ref.watch(notificationPreferencesProvider);
    final userAsync = ref.watch(currentUserProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          RoundedCard(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark theme'),
              value: isDark,
              onChanged: (value) => ref.read(themeModeProvider.notifier).toggleTheme(),
              activeThumbColor: const Color(0xFFC89B3C),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          RoundedCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive booking updates'),
                  value: notificationPrefs.pushEnabled,
                  onChanged: (value) => _saveNotifications(
                    context,
                    ref,
                    notificationPrefs.copyWith(pushEnabled: value),
                  ),
                  activeThumbColor: const Color(0xFFC89B3C),
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 24),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive email updates'),
                  value: notificationPrefs.emailEnabled,
                  onChanged: (value) => _saveNotifications(
                    context,
                    ref,
                    notificationPrefs.copyWith(emailEnabled: value),
                  ),
                  activeThumbColor: const Color(0xFFC89B3C),
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 24),
                SwitchListTile(
                  title: const Text('Promotional Offers'),
                  subtitle: const Text('Receive special offers'),
                  value: notificationPrefs.promotionsEnabled,
                  onChanged: (value) => _saveNotifications(
                    context,
                    ref,
                    notificationPrefs.copyWith(promotionsEnabled: value),
                  ),
                  activeThumbColor: const Color(0xFFC89B3C),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          userAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LinearProgressIndicator(minHeight: 2),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Could not load account details.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            data: (user) {
              if (user == null) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Profile document missing or expired.'),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RoundedCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.account_circle_outlined),
                    title: Text(user.fullName),
                    subtitle: Text(user.email),
                  ),
                ),
              );
            },
          ),
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          RoundedCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () => _showPasswordDialog(context, ref),
                ),
                const Divider(height: 24),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailing: 'English',
                  onTap: () => context.push('/language'),
                ),
                const Divider(height: 24),
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Country',
                  trailing: userAsync.valueOrNull?.nationality ?? 'Egypt',
                  onTap: () => _showCountryDialog(context, ref, userAsync.valueOrNull?.nationality),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Privacy',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          RoundedCard(
            child: SwitchListTile(
              title: const Text('Share navigation insights'),
              subtitle: const Text('Help improve your experience by sharing journey analytics'),
              value: ref.watch(navigationTrackingConsentProvider),
              onChanged: (value) =>
                  ref.read(navigationTrackingConsentProvider.notifier).setConsent(value),
              activeThumbColor: const Color(0xFFC89B3C),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Support',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          RoundedCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  onTap: () => context.push('/help-center'),
                ),
                const Divider(height: 24),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => context.push('/privacy-policy'),
                ),
                const Divider(height: 24),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => context.push('/terms-of-service'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          RoundedCard(
            child: _SettingsTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Account',
              titleColor: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion is coming soon.')),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _saveNotifications(
    BuildContext context,
    WidgetRef ref,
    NotificationPreferences preferences,
  ) async {
    try {
      await ref.read(notificationPreferencesProvider.notifier).setPreferences(preferences);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification preferences saved.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save notifications: $error')),
        );
      }
    }
  }

  Future<void> _showCountryDialog(
    BuildContext context,
    WidgetRef ref,
    String? currentCountry,
  ) async {
    const countries = ['Egypt', 'Saudi Arabia', 'UAE', 'Jordan', 'Morocco', 'United Kingdom'];
    String selected = currentCountry ?? 'Egypt';

    final changedCountry = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update country'),
        content: StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 320,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final country in countries)
                  RadioListTile<String>(
                    value: country,
                    groupValue: selected,
                    onChanged: (value) => setState(() => selected = value ?? selected),
                    title: Text(country),
                    toggleable: true,
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, selected), child: const Text('Save')),
        ],
      ),
    );

    if (changedCountry == null) return;

    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Please sign in again.')));
      }
      return;
    }

    try {
      await ref.read(authServiceProvider).updateCountry(
            userId: user.uid,
            country: changedCountry,
          );
      ref.invalidate(currentUserProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Country updated successfully.')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not update country: $error')));
      }
    }
  }

  Future<void> _showPasswordDialog(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user?.email == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please sign in again first.')));
      return;
    }

    final formKey = GlobalKey<FormState>();
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final submitted = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Change password'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Current password'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Current password is required'
                        : null,
                  ),
                  TextFormField(
                    controller: newController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'New password'),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirm new password'),
                    validator: (value) => value != newController.text ? 'Passwords do not match' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  Navigator.pop(context, true);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ) ??
        false;

    if (!submitted) return;

    try {
      await ref.read(authServiceProvider).updatePassword(
            email: user!.email!,
            currentPassword: currentController.text,
            newPassword: newController.text,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Password updated successfully.')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not update password: $error')));
      }
    } finally {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    }
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: titleColor != null
              ? titleColor!.withValues(alpha: 0.1)
              : colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: titleColor ?? colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor ?? colorScheme.onSurface,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing!,
              style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
            ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: colorScheme.outlineVariant),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
