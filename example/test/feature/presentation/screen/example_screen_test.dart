import 'package:counter/feature/presentation/screen/example/example_screen.dart';
import 'package:counter/feature/presentation/screen/example/i_example_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:more_elementary/elementary.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:union_state/union_state.dart';

class ExampleWMMock extends Mock with MockWidgetModelMixin implements IExampleWM {}

class SomeComponentWMMock extends Mock with MockWidgetModelMixin implements ISomeComponentWM {}

void main() {
  final wm = ExampleWMMock();
  final someComponentWM = SomeComponentWMMock();

  setUpAll(() {
    when(() => wm.someComponentWM).thenReturn(someComponentWM);
    when(() => wm.title).thenReturn('title');
    when(() => wm.filterController).thenReturn(TextEditingController(text: 'filter'));
    when(() => wm.todoData).thenReturn(UnionStateNotifier.failure());
    when(() => someComponentWM.title).thenReturn('...loading');
  });

  testWidget(
    widgetBuilder: (_, __) => ExampleScreen(wm),
    customPump: (p0) => p0.pumpAndSettle(const Duration(milliseconds: 500)),
  );
}
