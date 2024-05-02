import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';

/// A basic interface for every [WidgetModel].
///
/// The general approach for the [WidgetModel] is implement interface that
/// expanded from [IWidgetModel]. This expanded interface describes the contract
/// which the inheritor of the [WidgetModel] implemented this interface
/// is providing for the [ElementaryWidget]. The contract includes all
/// properties and methods which the [ElementaryWidget] can use for build a
/// part of the tree it describes.
///
/// {@tool snippet}
///
/// The following is a an example for the top-level factory function
/// that get dependencies using passed BuildContext.
///
/// ```dart
/// abstract interface class IExampleWidgetModel implements IWidgetModel {
///   ListenableState<int> get somePublisher;
///   Stream<String> get anotherPublisher;
///   Color get justProperty;
///
///   Future<void> doSomething();
///   Future<void> anotherOptionOfInteract();
/// }
/// ```
/// {@end-tool}
abstract interface class IWidgetModel {
  ElementaryWidget? _widget;

  // ignore: unused_field
  BuildContext? _element;

  /// Called while the first build for initialization of this [WidgetModel].
  ///
  /// This method is called only ones for the instance of [WidgetModel]
  /// during its lifecycle.
  @protected
  @visibleForTesting
  void initWidgetModel() {}

  /// Called whenever the widget configuration is changed.
  @protected
  @visibleForTesting
  void didUpdateWidget(ElementaryWidget oldWidget) {}

  /// Called when a dependency (by Build Context) of this Widget Model changes.
  ///
  /// For example, if Widget Model has reference on [InheritedWidget].
  /// This widget can change and method will called to notify about change.
  ///
  /// This method is also called immediately after [initWidgetModel].
  @protected
  @visibleForTesting
  void didChangeDependencies() {}

  /// Called when this [WidgetModel] and [Elementary] are removed from the tree.
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void deactivate() {}

  /// Called when this [WidgetModel] and [Elementary] are reinserted into
  /// the tree after having been removed via [deactivate].
  ///
  /// In most cases, after a [WidgetModel] has been deactivated, it is not
  /// reinserted into the tree, and its [dispose] method will be called to
  /// signal that it is ready to be garbage collected.
  ///
  /// In some cases, however, after a [WidgetModel] has been deactivated,
  /// it will reinserted it into another part of the tree (e.g., if there is a
  /// subtree uses a [GlobalKey] that match with key of the [Elementary]
  /// linked with this [WidgetModel]).
  ///
  /// This method does not called the first time a WidgetModel object
  /// is inserted into the tree. Instead, calls [initWidgetModel] in
  /// that situation.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void activate();

  /// Called when [Elementary] with this [WidgetModel] is removed from the tree
  /// permanently.
  /// Should be used for preparation to be garbage collected.
  @protected
  @visibleForTesting
  void dispose();

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload. Most cases therefore do not need to do
  /// anything in the [reassemble] method.
  ///
  /// See also:
  ///  * [Element.reassemble]
  ///  * [BindingBase.reassembleApplication]
  @protected
  @mustCallSuper
  @visibleForTesting
  void reassemble();
}

/// A widget that instantiates a [WidgetModel] in the top of the tree and provides
/// access to it across the subtree.
///
/// For inheritors of this widget is common to be parameterized by
/// the interface expanded from [IWidgetModel] that provides all special
/// information which needed for this widget for correctly describe the subtree.
///
/// Only one thing should be implemented in inheritors of this widget is a
/// build method. Build method in this case is pure function which gets the
/// [WidgetModel] as argument and based on this [WidgetModel] returns
/// the [Widget]. There isn't additional interactions with anything external,
/// everything needed for describe should be provided by [WidgetModel].
///
/// {@tool snippet}
///
/// The following widget shows a default example of Flutter app, which created
/// with a new Flutter project.
///
/// ```dart
/// class ExampleWidget extends ElementaryWidget<IExampleWidgetModel> {
///   const ExampleWidget({
///     Key? key,
///     WidgetModelFactory wmFactory = exampleWidgetModelFactory,
///   }) : super(wmFactory, key: key);
///
///   @override
///   Widget build(IExampleWidgetModel wm) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('Test'),
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             const Text('You have pushed the button this many times:'),
///             ValueListenableBuilder<int>(
///               valueListenable: wm.pressCountPublisher,
///               builder: (_, value, __) {
///                 return Text(value.toString());
///               },
///             ),
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: wm.increment,
///         tooltip: 'Increment',
///         child: const Icon(Icons.add),
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// ## wm
/// An instance of the [WidgetModel] must be provided to the widget
/// constructor. [WidgetModel] must implement [IWidgetModel] interface.
///
/// ## The part of Elementary Lifecycle
/// This widget is a starting and updating configuration for the [WidgetModel].
/// More details about using it while life cycle see in the methods docs of the
/// [WidgetModel].
///
/// ## Internal details
/// This widget doesn't have its own [RenderObject], and just describes a part
/// of the user interface using other widgets. It is a common approach for the
/// widgets those inflate to [ComponentElement].
///
/// See also: [StatelessWidget], [StatefulWidget], [InheritedWidget].
abstract class ElementaryWidget<I extends IWidgetModel> extends Widget with WMContext<I> {
  /// Instance of the [WidgetModel] for this widget.
  final I _widgetModel;

  /// Creates an instance of ElementaryWidget.
  const ElementaryWidget(this._widgetModel, {super.key});

  /// Creates a [Elementary] to manage this widget's location in the tree.
  ///
  /// It is uncommon for subclasses to override this method.
  @override
  Elementary createElement() {
    return Elementary(this, _widgetModel);
  }

  /// Builds the user interface.
  Widget build(BuildContext context);

  Widget _build(BuildContext context, I wm) {
    return WMInheritedWidget<I>(
      wm: wm,
      child: Builder(builder: build),
    );
  }
}

/// The basic implementation of the entity responsible for all
/// presentation logic, providing properties and data for the widget,
/// and keep relations with the business logic. Business logic represented in
/// the form of [ElementaryModel].
///
/// [WidgetModel] is a working horse of the Elementary library. It unites the
/// trio of 'widget - widget model - model'. So the inheritors of [WidgetModel]
/// parameterized by an inheritor of the ElementaryWidget and an inheritor
/// of the ElementaryModel. This mean that this WidgetModel subclass encapsulate
/// all required logic for the concrete ElementaryWidget subclass that
/// mentioned as parameter and only for it. Also this WidgetModel subclass uses
/// exactly the mentioned ElementaryModel subclass as an available contract of
/// business logic.
///
/// It is common for inheritors to implement the expanded from [IWidgetModel]
/// interface that describes special contract for the relevant
/// [ElementaryWidget] subclass. Moreover using the contract is preferable way
/// because this interface explicitly shows available properties and methods
/// for declarative part (for ElementaryWidget).
///
/// ## Approach to update
/// It is a rare case when [ElementaryWidget] completely rebuild. The most
/// common case is a partial rebuild of UI parts. In order to get this, using
/// publishers can be helpful. Declare any publishers which you prefer and
/// update their values in suitable conditions. In the declarative part just
/// use these publishers for describe parts of the UI, which depends on them.
/// Here is a far from complete list of options for use as publishers:
/// [Stream], [ChangeNotifier], StateNotifier, EntityStateNotifier.
///
/// ## The part of Elementary Lifecycle
/// Base class contains all internal mechanisms and process that need to
/// guarantee the conceived behavior for the Elementary library.
///
/// [initWidgetModel] is called only once for lifecycle
/// of the [WidgetModel] in the really beginning before the first build.
/// It can be used for initiate a starting state of the [WidgetModel].
///
/// [didUpdateWidget] called whenever widget instance in the tree has been
/// updated. Common case where rebuild comes from the top. This method is a good
/// place for update state of the [WidgetModel] based on the new configuration
/// of widget. When this method is called is just a signal for decide what
/// exactly should be updated or rebuilt. The fact of update doesn't mean that
/// build method of the widget will be called. Set new values to publishers
/// for rebuild concrete parts of the UI.
///
/// [didChangeDependencies] called whenever dependencies which [WidgetModel]
/// subscribed with [BuildContext] change.
/// When this method is called is just a signal for decide what
/// exactly should be updated or rebuilt. The fact of the call doesn't mean that
/// build method of the widget will be called. Set new values to publishers
/// for rebuild concrete parts of the UI.
///
/// [deactivate] called when the [WidgetModel] with [Elementary] removed from
/// the tree.
///
/// [activate] called when [WidgetModel] with [Elementary] are reinserted into
/// the tree after having been removed via [deactivate].
///
/// [dispose] called when [WidgetModel] is going to be permanently destroyed.
///
/// [reassemble] called whenever the application is reassembled during
/// debugging, for example during the hot reload.
///
/// [onErrorHandle] called when the [ElementaryModel] handle error with the
/// [ElementaryModel.handleError] method. Can be useful for general handling
/// errors such as showing snack-bars.
abstract class WidgetModel<W extends ElementaryWidget, M extends ElementaryModel>
    with Diagnosticable
    implements IWidgetModel {
  final M _model;

  /// Instance of [ElementaryModel] for this [WidgetModel].
  ///
  /// The only business logic dependency that is needed for the [WidgetModel].
  @protected
  @visibleForTesting
  M get model => _model;

  /// Widget that uses this [WidgetModel] for building part of the user interface.
  ///
  /// The [WidgetModel] has an associated [ElementaryWidget].
  /// This relation is managed by [Elementary], and in every time of lifecycle
  /// in this property is an actual widget. Before the first update this field
  /// contains a widget that created this [WidgetModel]. This instance can be
  /// changed during the lifecycle, and [didUpdateWidget] will be called each
  /// time it is changed.
  @protected
  @visibleForTesting
  ElementaryWidget get widget => _widget!;

  /// The location in the tree where this widget builds.
  ///
  /// The [WidgetModel] will be associated with the [BuildContext] by
  /// [Elementary] after creating and before calling [initWidgetModel].
  /// The association is permanent: the [WidgetModel] object will never
  /// change its [BuildContext]. However, the [BuildContext] itself can be
  /// moved around the tree.
  ///
  /// After calling [dispose] the association between the [WidgetModel] and
  /// the [BuildContext] will be broken.
  @protected
  @visibleForTesting
  BuildContext get context {
    assert(() {
      if (_element == null) {
        throw FlutterError('This widget has been unmounted');
      }
      return true;
    }());
    return _element!;
  }

  /// Whether [WidgetModel] and [Elementary] are currently mounted in the tree.
  @protected
  @visibleForTesting
  bool get isMounted => _element != null;

  @override
  BuildContext? _element;
  @override
  ElementaryWidget? _widget;

  /// Creates an instance of the [WidgetModel].
  WidgetModel(this._model);

  /// Called while the first build for initialization of this [WidgetModel].
  ///
  /// This method is called only ones for the instance of [WidgetModel]
  /// during its lifecycle.
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void initWidgetModel() {
    _model
      ..init()
      .._wmHandler = onErrorHandle;
  }

  /// Called whenever the widget configuration is changed.
  @override
  @protected
  @visibleForTesting
  void didUpdateWidget(ElementaryWidget oldWidget) {}

  /// Called when a dependency (by Build Context) of this Widget Model changes.
  ///
  /// For example, if Widget Model has reference on [InheritedWidget].
  /// This widget can change and method will called to notify about change.
  ///
  /// This method is also called immediately after [initWidgetModel].
  @override
  @protected
  @visibleForTesting
  void didChangeDependencies() {}

  /// Method for handling asynchronous operations.
  /// This method is a common place for handling errors. If the operation fails,
  /// the error will be passed to the [onError] callback (if it was provided) and
  /// the [logError] method will be called.
  ///
  /// [operation] - the asynchronous operation that should be handled.
  /// [onSuccess] - the callback that will be called if the operation is successful.
  /// [onError] - the callback that will be called if the operation fails.
  Future<void> handleCall<T>({
    required Future<T> Function() operation,
    required void Function(T) onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
    bool Function(T)? isResultError,
    bool displayableError = false,
  }) async {
    try {
      final result = await operation();
      if (isResultError?.call(result) ?? false) {
        if (result is Object) logError(result, null, displayableError: displayableError);
        return;
      }
      onSuccess(result);
    } on Exception catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      logError(error, stackTrace, displayableError: displayableError);
    }
  }

  /// Called whenever [handleCall] is called with an error. You can use this
  /// method for logging errors.
  void logError(Object error, StackTrace? stackTrace, {required bool displayableError}) {}

  /// Called whenever [ElementaryModel.handleError] is called.
  ///
  /// This method is a common place for presentation handling error like a
  /// showing a snack-bar, etc.
  @protected
  @mustCallSuper
  @visibleForTesting
  void onErrorHandle(Object error, StackTrace? stackTrace) {
    logError(error, stackTrace, displayableError: false);
  }

  /// Called when this [WidgetModel] and [Elementary] are removed from the tree.
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void deactivate() {}

  /// Called when this [WidgetModel] and [Elementary] are reinserted into
  /// the tree after having been removed via [deactivate].
  ///
  /// In most cases, after a [WidgetModel] has been deactivated, it is not
  /// reinserted into the tree, and its [dispose] method will be called to
  /// signal that it is ready to be garbage collected.
  ///
  /// In some cases, however, after a [WidgetModel] has been deactivated,
  /// it will reinserted it into another part of the tree (e.g., if there is a
  /// subtree uses a [GlobalKey] that match with key of the [Elementary]
  /// linked with this [WidgetModel]).
  ///
  /// This method does not called the first time a WidgetModel object
  /// is inserted into the tree. Instead, calls [initWidgetModel] in
  /// that situation.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void activate() {}

  /// Called when [Elementary] with this [WidgetModel] is removed from the tree
  /// permanently.
  /// Should be used for preparation to be garbage collected.
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void dispose() {
    _model.dispose();
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload. Most cases therefore do not need to do
  /// anything in the [reassemble] method.
  ///
  /// See also:
  ///  * [Element.reassemble]
  ///  * [BindingBase.reassembleApplication]
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void reassemble() {}

  /// Method for associate another instance of the widget to this [WidgetModel].
  /// MUST be used only for testing purposes.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestWidget(W? testWidget) {
    _widget = testWidget;
  }

  /// Method for associate another element to this [WidgetModel].
  /// MUST be used only for testing purposes.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestElement(BuildContext? testElement) {
    _element = testElement;
  }
}

abstract class LiteWidgetModel<W extends ElementaryWidget> extends WidgetModel<W, StubModel> {
  /// @nodoc
  LiteWidgetModel() : super(StubModel());
}

/// InheritedWidget provides access to the [WidgetModel] for all descendants of [ElementaryWidget].
class WMInheritedWidget<T extends IWidgetModel> extends InheritedWidget {
  /// The [WidgetModel] for the descendants of this [InheritedWidget].
  final T wm;

  /// Creates an instance of [WMInheritedWidget].
  const WMInheritedWidget({
    required this.wm,
    required super.child,
    super.key,
  });

  /// Get the [WidgetModel] from the [BuildContext].
  static T of<T extends IWidgetModel>(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<WMInheritedWidget<T>>();
    if (widget == null) {
      throw FlutterError('WMInheritedWidget.of() called with a context that does not contain a WidgetModel.');
    }
    return widget.wm;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

/// Mixin for providing access to the [WidgetModel] from the [BuildContext].
mixin WMContext<T extends IWidgetModel> on Widget {
  /// Get the [WidgetModel] from the [BuildContext].
  T wm(BuildContext context) => WMInheritedWidget.of<T>(context);
}

/// An element for managing a widget whose display depends on the Widget Model.
final class Elementary extends ComponentElement {
  @override
  ElementaryWidget get widget => super.widget as ElementaryWidget;

  final IWidgetModel _wm;

  // private _firstBuild hack
  bool _isInitialized = false;

  /// Create an instance of Elementary.
  Elementary(ElementaryWidget widget, this._wm) : super(widget);

  @override
  Widget build() {
    return widget._build(this, _wm);
  }

  @override
  void update(ElementaryWidget newWidget) {
    super.update(newWidget);

    final oldWidget = _wm._widget;
    _wm._widget = newWidget;
    if (oldWidget != null) _wm.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wm.didChangeDependencies();
  }

  @override
  void activate() {
    super.activate();
    _wm.activate();

    markNeedsBuild();
  }

  @override
  void deactivate() {
    _wm.deactivate();
    super.deactivate();
  }

  @override
  void unmount() {
    super.unmount();

    _wm
      ..dispose()
      .._element = null
      .._widget = null;
  }

  @override
  void performRebuild() {
    // private _firstBuild hack
    if (!_isInitialized) {
      _wm
        .._element = this
        .._widget = widget
        ..initWidgetModel()
        ..didChangeDependencies();

      _isInitialized = true;
    }

    super.performRebuild();
  }

  @override
  void reassemble() {
    super.reassemble();
    _wm.reassemble();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<IWidgetModel>(
        'widget model',
        _wm,
        defaultValue: null,
      ),
    );
  }
}

/// Mock that helps to prevent [NoSuchMethodError] exception when the
/// WidgetModel is mocked.
@visibleForTesting
mixin MockWidgetModelMixin implements WidgetModel {
  @override
  set _element(BuildContext? _) {}

  @override
  set _widget(ElementaryWidget? _) {}

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockWidgetModel';
  }
}

/// The base class for an entity that contains a business logic required for
/// a specific inheritor of [ElementaryWidget].
///
/// You can implement this class freestyle. It may be a bunch of methods,
/// streams or something else. Also it is not a mandatory for business logic
/// to be implemented right inside the class, this model can be proxy for other
/// responsible entities with business logic.
///
/// This class can take [ErrorHandler] as dependency for centralize handling
/// error (for example logging). The [handleError] method can be used for it.
/// When the [handleError] is called passed [ErrorHandler] handles exception.
/// Also the [WidgetModel] is notified about this exception with
/// [WidgetModel.onErrorHandle] method.
///
/// ## The part of Elementary Lifecycle
///
abstract class ElementaryModel {
  final ErrorHandler? _errorHandler;
  void Function(Object, StackTrace?)? _wmHandler;

  /// Create an instance of ElementaryModel.
  ElementaryModel({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  /// Can be used for send [error] to [ErrorHandler] if it defined and notify
  /// [WidgetModel].
  @protected
  @mustCallSuper
  @visibleForTesting
  void handleError(Object error, {StackTrace? stackTrace}) {
    _errorHandler?.handleError(error, stackTrace: stackTrace);
    _wmHandler?.call(error, stackTrace);
  }

  /// Initializes [ElementaryModel].
  ///
  /// Called once before the first build of the [ElementaryWidget].
  void init() {}

  /// Prepares the [ElementaryModel] to be completely destroyed.
  ///
  /// Called once when [Elementary] going to be destroyed. Should be used for
  /// clearing links, subscriptions, and preparation to be garbage collected.
  void dispose() {}

  /// Method for setup ElementaryModel for testing.
  /// This method can be used to WidgetModels error handler.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupWmHandler(void Function(Object, StackTrace?)? function) {
    _wmHandler = function;
  }
}

class StubModel extends ElementaryModel {}
