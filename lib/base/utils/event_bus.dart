import 'dart:async';

import 'package:event_bus/event_bus.dart';

/**
 * eventbus事件管理器
 */
class EventManager {
  EventBus _eventBus = EventBus();

  static EventManager? _instance;

  static EventManager getInstance() {
    if (_instance == null) {
      _instance = EventManager();
    }
    return _instance!;
  }

  void post(event) {
    try {
      _eventBus.fire(event);
    } catch (e) {
      print(e);
    }
  }

  StreamSubscription<T> on<T>(Function(T) onEvent) {
   return _eventBus.on<T>().listen((event) {
      onEvent(event);
    });
  }

  void destroy() {
    _eventBus.destroy();
  }
}
