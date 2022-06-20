import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? inactiveCallBack;
  final AsyncCallback? pauseCallBack;
  final AsyncCallback? detachCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.inactiveCallBack,
    this.pauseCallBack,
    this.detachCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
        if (inactiveCallBack != null) {
          await inactiveCallBack!();
        }
        break;
      case AppLifecycleState.paused:
        if (pauseCallBack != null) {
          await pauseCallBack!();
        }
        break;
      case AppLifecycleState.detached:
        if (detachCallBack != null) {
          await detachCallBack!();
        }
        break;
    }
  }
}
