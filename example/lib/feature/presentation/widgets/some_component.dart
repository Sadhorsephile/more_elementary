import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';

class SomeComponent extends ElementaryWidget<ISomeComponentWM> {
  const SomeComponent(super.widgetModel, {super.key});

  @override
  Widget build(BuildContext context, ISomeComponentWM wm) {
    return const CircularProgressIndicator();
  }
}
