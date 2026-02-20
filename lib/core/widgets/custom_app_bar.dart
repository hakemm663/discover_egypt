import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/image_urls.dart';

enum CustomAppBarVariant { light, dark }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showMenuButton;
  final bool showProfileButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final List<Widget>? additionalActions;
  final bool transparent;
  final Color? backgroundColor;
  final String? backgroundImageUrl;
  final CustomAppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showMenuButton = true,
    this.showProfileButton = true,
    this.onBackPressed,
    this.onMenuTap,
    this.onSettingsTap,
    this.onProfileTap,
    this.additionalActions,
    this.transparent = false,
    this.backgroundColor,
    this.backgroundImageUrl,
    this.variant = CustomAppBarVariant.light,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  bool get _isDark => variant == CustomAppBarVariant.dark;

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = transparent
        ? Colors.transparent
        : backgroundColor ??
            (_isDark
                ? Colors.black.withValues(alpha: 0.75)
                : Theme.of(context).scaffoldBackgroundColor);

    return Container(
      decoration: BoxDecoration(
        image: backgroundImageUrl != null
            ? DecorationImage(
                image: NetworkImage(backgroundImageUrl ?? Img.pyramidsMain),
                fit: BoxFit.cover,
              )
            : null,
        color: backgroundImageUrl == null ? effectiveBackground : null,
        boxShadow: transparent || _isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Container(
        color: backgroundImageUrl != null
            ? Colors.black.withValues(alpha: 0.45)
            : null,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (showBackButton)
                  _AppBarButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    isDark: _isDark || backgroundImageUrl != null,
                    onPressed: onBackPressed ??
                        () {
                          if (context.canPop()) {
                            context.pop();
                          }
                        },
                  ),
                if (showBackButton) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isDark || backgroundImageUrl != null
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (additionalActions != null) ...additionalActions!,
                if (showProfileButton) ...[
                  const SizedBox(width: 8),
                  _AppBarButton(
                    icon: Icons.person_outline_rounded,
                    isDark: _isDark || backgroundImageUrl != null,
                    onPressed: onProfileTap ?? () => context.push('/profile'),
                  ),
                ],
                if (showMenuButton) ...[
                  const SizedBox(width: 8),
                  _AppBarButton(
                    icon: Icons.menu_rounded,
                    isDark: _isDark || backgroundImageUrl != null,
                    onPressed: onMenuTap ?? () => _showMenu(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _MenuBottomSheet(
        onProfileTap: onProfileTap,
        onSettingsTap: onSettingsTap,
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;

  const _AppBarButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isDark ? Colors.white : Colors.black87;
    final background = isDark
        ? Colors.white.withValues(alpha: 0.22)
        : Colors.white.withValues(alpha: 0.95);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      elevation: isDark ? 0 : 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: foreground),
        ),
      ),
    );
  }
}

class _MenuBottomSheet extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;

  const _MenuBottomSheet({
    this.onSettingsTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              if (onSettingsTap != null) {
                onSettingsTap!();
                return;
              }
              context.push('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              if (onProfileTap != null) {
                onProfileTap!();
                return;
              }
              context.push('/profile');
            },
          ),
        ],
      ),
    );
  }
}
