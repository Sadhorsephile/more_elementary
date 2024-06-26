import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart' as helper;

Future<void> testExecutable(FutureOr<void> Function() testMain) {
  /// You can specify your own themes.
  /// Stringified is used for naming screenshots.
  final themes = [
    helper.TestingTheme(
      data: ThemeData.dark(),
      stringified: 'dark',
      type: helper.ThemeType.dark,
    ),
    helper.TestingTheme(
      data: ThemeData.light(),
      stringified: 'light',
      type: helper.ThemeType.light,
    ),
  ];

  /// You can specify your own devices.
  final devices = [
    helper.TestDevice(
      name: 'iphone11',
      size: const Size(414, 896),
      safeArea: const EdgeInsets.only(top: 44, bottom: 34),
    ),
    helper.TestDevice(
      name: 'pixel 4a',
      size: const Size(393, 851),
    ),
    helper.TestDevice(
      name: 'iphone_se_1',
      size: const Size(640 / 2, 1136 / 2),
    ),
  ];

  return helper.testExecutable(
    testMain: testMain,
    themes: themes,

    wrapper: (child, mode, theme, localizations, locales) => helper.BaseWidgetTestWrapper(
      childBuilder: child,
      mode: mode,
      themeData: theme,
      localizations: localizations,
      localeOverrides: locales,
      // You can specify dependencies here.
      dependencies: (child) => child,
    ),

    /// You can specify background color of golden test based on current theme.
    backgroundColor: (theme) => theme.colorScheme.background,
    devicesForTest: devices,

    /// You can specify tolerance for golden tests.
    tolerance: 0.5,
  );
}
