import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rounded_card.dart';

class InterestsPage extends ConsumerStatefulWidget {
  const InterestsPage({super.key});

  @override
  ConsumerState<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends ConsumerState<InterestsPage> {
  final Set<String> _selectedInterests = {'History'};

  final List<Map<String, dynamic>> _interests = [
    {
      'id': 'history',
      'name': 'History',
      'icon': Icons.account_balance_rounded,
      'emoji': '🏛️',
    },
    {
      'id': 'adventure',
      'name': 'Adventure',
      'icon': Icons.landscape_rounded,
      'emoji': '🏔️',
    },
    {
      'id': 'relaxation',
      'name': 'Relaxation',
      'icon': Icons.spa_rounded,
      'emoji': '🧘',
    },
    {
      'id': 'beaches',
      'name': 'Beaches',
      'icon': Icons.beach_access_rounded,
      'emoji': '🏖️',
    },
    {
      'id': 'diving',
      'name': 'Diving',
      'icon': Icons.scuba_diving_rounded,
      'emoji': '🤿',
    },
    {
      'id': 'culture',
      'name': 'Culture',
      'icon': Icons.theater_comedy_rounded,
      'emoji': '🎭',
    },
    {
      'id': 'food',
      'name': 'Food & Cuisine',
      'icon': Icons.restaurant_rounded,
      'emoji': '🍽️',
    },
    {
      'id': 'shopping',
      'name': 'Shopping',
      'icon': Icons.shopping_bag_rounded,
      'emoji': '🛍️',
    },
    {
      'id': 'photography',
      'name': 'Photography',
      'icon': Icons.camera_alt_rounded,
      'emoji': '📸',
    },
    {
      'id': 'nightlife',
      'name': 'Nightlife',
      'icon': Icons.nightlife_rounded,
      'emoji': '🌙',
    },
    {
      'id': 'cruises',
      'name': 'Cruises',
      'icon': Icons.directions_boat_rounded,
      'emoji': '🚢',
    },
    {
      'id': 'museums',
      'name': 'Museums',
      'icon': Icons.museum_rounded,
      'emoji': '🖼️',
    },
    {
      'id': 'temples',
      'name': 'Temples',
      'icon': Icons.temple_hindu_rounded,
      'emoji': '⛩️',
    },
    {
      'id': 'desert',
      'name': 'Desert Safari',
      'icon': Icons.terrain_rounded,
      'emoji': '🏜️',
    },
    {
      'id': 'wellness',
      'name': 'Wellness',
      'icon': Icons.self_improvement_rounded,
      'emoji': '💆',
    },
  ];

  Future<void> _completeOnboardingAndContinue() async {
    await ref.read(onboardingCompletedProvider.notifier).setCompleted(true);

    if (!mounted) {
      return;
    }

    context.go('/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover Egypt',
        showBackButton: true,
        showMenuButton: false,
        showProfileButton: false,
        onBackPressed: () => context.go('/nationality'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What Are You Interested In?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your interests to personalize recommendations',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_selectedInterests.length} selected',
                style: const TextStyle(
                  color: Color(0xFFC89B3C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RoundedCard(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: _interests.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final interest = _interests[index];
                      final isSelected = _selectedInterests.contains(interest['name']);

                      return _InterestTile(
                        name: interest['name'],
                        emoji: interest['emoji'],
                        icon: interest['icon'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedInterests.remove(interest['name']);
                            } else {
                              _selectedInterests.add(interest['name']);
                            }
                          });
                        },
                      ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().scale(
                            begin: const Offset(0.8, 0.8),
                            duration: 300.ms,
                          );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed:
                    _selectedInterests.isNotEmpty ? _completeOnboardingAndContinue : null,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: _completeOnboardingAndContinue,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestTile extends StatelessWidget {
  final String name;
  final String emoji;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestTile({
    required this.name,
    required this.emoji,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFC89B3C).withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFC89B3C)
                  : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC89B3C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFFC89B3C) : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
