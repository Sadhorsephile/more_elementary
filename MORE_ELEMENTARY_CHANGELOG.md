## Что нового

Этот репозиторий - небольшое переосмысление Elementary.

Основные изменения:

1. Возможность использовать `LiteWidgetModel` для кейсов, когда модель избыточна и/или является простым прокси между виджет-моделью и истинными объектами бизнес-логики.

2. Теперь фабрика, которая осуществляет внедрение виджет-модели в виджет, имеет возвращаемый тип интерфейса виджет-модели, а не реализации:
```dart
typedef WidgetModelFactory<T extends IWidgetModel> = T Function(
  BuildContext context,
);
```

3. Теперь у `ElementaryWidget`'а есть доступ и к контексту, и к виджет-модели:
```dart
class ExampleScreen extends ElementaryWidget<IExampleWM> {
  const ExampleScreen(
    super.widgetModelFactory, {
    super.key,
  });

  @override
  Widget build(BuildContext context, IExampleWM wm) {
    ...
  }
}
```

4. Теперь в `ElementaryWidget` включён `InheritedWidget`, который содержит в себе виджет-модель. Таким образом, доступ к виджет-модели есть не только у `ElementaryWidget`'а, но и у всех его потомков. 

Используя миксин `WMStless` (`WMStful` в случае `StatefulWidget`'ов), вместо метода `build` вы должны реализовать метод `buildWithWm`, в котором есть доступ как к контексту, так и к виджет-модели:
```dart

class _TodosList extends StatelessWidget with WMStless<IExampleWM> {
  const _TodosList();

  @override
  Widget buildWithWm(BuildContext context, IExampleWM wm) {
    ...
  }
}
```

<details>
<summary>Сниппеты для удобства</summary>
    
```json
    "Create StatelessWidget with WidgetModel": {
        "prefix": "wmst",
        "body": [
            "",
            "class $1 extends StatelessWidget with WMStless<$2> {",
            "  @override",
            "  Widget buildWithWm(BuildContext context, $2 wm) {",
            "    return $3",
            "  }",
            "}"
        ],
        "description": "Create StatelessWidget with WidgetModel"
    },
    "Create StatefulWidget with WidgetModel": {
        "prefix": "wmstf",
        "body": [
            "",
            "class $1 extends StatefulWidget {",
            "  @override",
            "  _${1}State createState() => _${1}State();",
            "}",
            "",
            "class _${1}State extends State<$1> with WMStful<$2, $1> {",
            "  @override",
            "  Widget buildWithWm(BuildContext context, $2 wm) {",
            "    return $3",
            "  }",
            "}"
        ],
        "description": "Create StatefulWidget with WidgetModel"
    },
```
</details>