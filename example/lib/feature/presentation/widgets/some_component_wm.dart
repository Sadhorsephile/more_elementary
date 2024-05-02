import 'package:more_elementary/elementary.dart';

abstract interface class ISomeComponentWM implements IWidgetModel {
  String get title;
}

class SomeComponentWM extends LiteWidgetModel implements ISomeComponentWM {
  @override
  final String title;

  SomeComponentWM({required this.title});
}
