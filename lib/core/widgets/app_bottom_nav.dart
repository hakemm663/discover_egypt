import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../localization/l10n.dart';
import '../themes/app_colors.dart';

class AppBottomNavShell extends StatelessWidget {
  const AppBottomNavShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: AppColors.chipSelectedBackground(context),
          labelTextStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.labelMedium,
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: <NavigationDestination>[
            _destination(
              context,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: l10n.navHome,
            ),
            _destination(
              context,
              icon: Icons.search_outlined,
              selectedIcon: Icons.search,
              label: l10n.navSearch,
            ),
            _destination(
              context,
              icon: Icons.travel_explore_outlined,
              selectedIcon: Icons.travel_explore,
              label: l10n.navExplore,
            ),
            _destination(
              context,
              icon: Icons.route_outlined,
              selectedIcon: Icons.route,
              label: l10n.navTrips,
            ),
            _destination(
              context,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _destination(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    return NavigationDestination(
      icon: Semantics(
        label: label,
        button: true,
        child: Icon(icon),
      ),
      selectedIcon: Semantics(
        label: label,
        button: true,
        child: Icon(
          selectedIcon,
          color: AppColors.brandGold,
        ),
      ),
      label: label,
    );
  }
}
