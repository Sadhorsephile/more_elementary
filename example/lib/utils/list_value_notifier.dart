import 'package:flutter/foundation.dart';

class ListValueNotifier<T> extends ValueNotifier<List<T>> {
  ListValueNotifier(super.value);

  @override
  set value(List<T> newValue) {
    super.value = List.from(newValue);
  }
}


