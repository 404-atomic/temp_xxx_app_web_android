import 'package:flutter/cupertino.dart';
import 'package:framework/base/utils/event_bus.dart';

import 'base_event.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    EventManager.getInstance()
        .on<SystemEventLangChanged>((SystemEventLangChanged event) {
      onSystemEventLangChanged(event);
    });

    super.initState();
  }

  void onSystemEventLangChanged(SystemEventLangChanged event) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
