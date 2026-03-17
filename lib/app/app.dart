import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/localization/generated/app_localizations.dart';
import '../core/themes/theme.dart';
import 'providers.dart';

class DiscoverEgyptApp extends ConsumerWidget {
  const DiscoverEgyptApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pushTokenLifecycleProvider);
    ref.watch(authSessionSyncProvider);

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(languageProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Discover Egypt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
