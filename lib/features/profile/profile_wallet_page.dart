import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/image_urls.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rounded_card.dart';

class ProfileWalletPage extends ConsumerWidget {
  const ProfileWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile & Wallet',
        showBackButton: false,
        showProfileButton: false,
        variant: CustomAppBarVariant.dark,
        backgroundImageUrl: Img.pyramidsMain,
        onSettingsTap: () {},
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ProfileEmptyState(
          title: 'Could not load your profile',
          message: 'Please try again or sign in again.',
          buttonLabel: 'Retry',
          onPressed: () => ref.invalidate(currentUserProvider),
        ),
        data: (user) {
          if (user == null) {
            return _ProfileEmptyState(
              title: 'Profile not found',
              message:
                  'Your account is signed in, but profile details are missing or expired.',
              buttonLabel: 'Back to Sign In',
              onPressed: () => context.go('/sign-in'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RoundedCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(user.avatarUrl ?? Img.avatarWoman),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.isPremium ? 'Premium Member' : 'Member',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.6),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              RoundedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _AmountRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Balance',
                      value: '\$${user.walletBalance.toStringAsFixed(2)}',
                      valueColor: Colors.green.shade700,
                    ),
                    const SizedBox(height: 10),
                    _AmountRow(
                      icon: Icons.card_giftcard_outlined,
                      label: 'Credits',
                      value: '\$${user.credits.toStringAsFixed(2)}',
                      valueColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              RoundedCard(
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      trailingText: '',
                      trailingColor: Colors.black54,
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _divider(),
                    _MenuTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      trailingText: '',
                      trailingColor: Colors.black54,
                      onTap: () => context.push('/settings'),
                    ),
                    _divider(),
                    _MenuTile(
                      icon: Icons.logout_outlined,
                      title: 'Logout',
                      trailingText: '',
                      trailingColor: Colors.black54,
                      onTap: () => _logout(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authServiceProvider).signOut();
      if (context.mounted) {
        context.go('/sign-in');
      }
    } catch (e) {
      if (context.mounted) {
        Helpers.showSnackBar(context, 'Logout failed: $e', isError: true);
      }
    }
  }

  Widget _divider() =>
      Divider(height: 18, color: Colors.black.withValues(alpha: 0.08));
}

class _ProfileEmptyState extends StatelessWidget {
  const _ProfileEmptyState({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined, size: 60),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _AmountRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black.withValues(alpha: 0.7)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailingText;
  final Color trailingColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.trailingText,
    required this.trailingColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.black.withValues(alpha: 0.06),
        child: Icon(
          icon,
          size: 18,
          color: Colors.black.withValues(alpha: 0.75),
        ),
      ),
      title: Text(
        title,
        style:
            Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      trailing: trailingText.isEmpty
          ? const Icon(Icons.chevron_right)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailingText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: trailingColor,
                      ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right),
              ],
            ),
      onTap: onTap,
    );
  }
}
