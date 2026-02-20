import 'dart:io';

import 'package:discover_egypt/app/app.dart';
import 'package:discover_egypt/app/providers.dart';
import 'package:discover_egypt/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('discover_egypt_test');
    Hive.init(tempDir.path);
    await Hive.openBox(AppConstants.settingsBox);
  });

  tearDown(() async {
    await Hive.box(AppConstants.settingsBox).clear();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('App boot + language update refreshes MaterialApp locale', (
    WidgetTester tester,
  ) async {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    await settingsBox.put(AppConstants.languageKey, 'de_DE');

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const DiscoverEgyptApp(),
      ),
    );
    await tester.pumpAndSettle();

    final initialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(initialApp.locale, const Locale('de'));

    container.read(languageProvider.notifier).setLanguage('ar_EG');
    await tester.pumpAndSettle();

    final updatedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedApp.locale, const Locale('ar'));
  });
}
