import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more_elementary/src/core.dart';

/// Tests of the [ElementaryWidget].
void main() {
  late _TestWmWidget wmWidget;

  setUp(() {
    wmWidget = const _TestWmWidget(_testWmFactory);
  });

  test('ElementaryWidget should create correct type element', () {
    final result = wmWidget.createElement();

    expect(result, const TypeMatcher<Elementary>());
  });
}

_TestWidgetModel _testWmFactory(BuildContext context) {
  return _TestWidgetModel(_TestModel());
}

class _TestWmWidget extends ElementaryWidget {
  const _TestWmWidget(WidgetModelFactory wmFactory) : super(wmFactory);

  @override
  Widget build(BuildContext context, IWidgetModel wm) {
    throw UnimplementedError();
  }
}

class _TestWidgetModel extends WidgetModel<_TestWmWidget, _TestModel> {
  _TestWidgetModel(_TestModel model) : super(model);
}

class _TestModel extends ElementaryModel {}
