import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/image_urls.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/custom_app_bar.dart';

class ProfileWalletPage extends StatelessWidget {
  const ProfileWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'Sarah';
    const membership = 'Premium Member';
    const walletBalance = 70.00;
    const credits = 20.00;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile & Wallet',
        showBackButton: false,
        onSettingsTap: () {
          // Navigate to settings or show settings dialog
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header profile card
          RoundedCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(Img.avatarWoman),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        membership,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Online',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Wallet summary
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
                  value: '\$${walletBalance.toStringAsFixed(2)}',
                  valueColor: Colors.green.shade700,
                ),
                const SizedBox(height: 10),
                _AmountRow(
                  icon: Icons.card_giftcard_outlined,
                  label: 'Credits',
                  value: '\$${credits.toStringAsFixed(2)}',
                  valueColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add Funds'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => context.go('/booking-summary'),
                        icon: const Icon(Icons.receipt_long_outlined),
                        label: const Text('My Bookings'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Quick actions / menu like the mock
          RoundedCard(
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Bookings',
                  trailingText: '\$3,800',
                  trailingColor: Colors.green.shade700,
                  onTap: () => context.go('/booking-summary'),
                ),
                _divider(),
                _MenuTile(
                  icon: Icons.rate_review_outlined,
                  title: 'Reviews',
                  trailingText: '20',
                  trailingColor: Colors.red.shade700,
                  onTap: () {},
                ),
                _divider(),
                _MenuTile(
                  icon: Icons.support_agent_outlined,
                  title: 'Support',
                  trailingText: 'Chat',
                  trailingColor: Theme.of(context).colorScheme.primary,
                  onTap: () {},
                ),
                _divider(),
                _MenuTile(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  trailingText: '',
                  trailingColor: Colors.black54,
                  onTap: () => context.go('/sign-in'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Tip: This is UI-only for now. Next we will connect it to real user data, bookings, and payments.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 18, color: Colors.black.withValues(alpha: 0.08));
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
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
