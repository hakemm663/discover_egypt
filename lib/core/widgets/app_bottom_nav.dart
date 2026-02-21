import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final locale = Localizations.localeOf(context);
    final labels = _BottomNavLabels.fromLocale(locale);

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
              label: labels.home,
            ),
            _destination(
              context,
              icon: Icons.hotel_outlined,
              selectedIcon: Icons.hotel,
              label: labels.hotels,
            ),
            _destination(
              context,
              icon: Icons.tour_outlined,
              selectedIcon: Icons.tour,
              label: labels.tours,
            ),
            _destination(
              context,
              icon: Icons.directions_car_outlined,
              selectedIcon: Icons.directions_car,
              label: labels.cars,
            ),
            _destination(
              context,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: labels.profile,
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

class _BottomNavLabels {
  const _BottomNavLabels({
    required this.home,
    required this.hotels,
    required this.tours,
    required this.cars,
    required this.profile,
  });

  final String home;
  final String hotels;
  final String tours;
  final String cars;
  final String profile;

  factory _BottomNavLabels.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return const _BottomNavLabels(
          home: 'الرئيسية',
          hotels: 'الفنادق',
          tours: 'الجولات',
          cars: 'السيارات',
          profile: 'الملف الشخصي',
        );
      default:
        return const _BottomNavLabels(
          home: 'Home',
          hotels: 'Hotels',
          tours: 'Tours',
          cars: 'Cars',
          profile: 'Profile',
        );
    }
  }
}
