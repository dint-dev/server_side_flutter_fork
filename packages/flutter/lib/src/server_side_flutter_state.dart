import 'dart:async';

import 'package:flutter/widgets.dart';

import '../foundation.dart';
import '../gestures.dart';
import '../rendering.dart';
import '../scheduler.dart';
import '../services.dart';

class ServerSideFlutterState {
  static final zoneKey = _zoneKey ??= Object();

  static Object? _zoneKey;

  static final _root = ServerSideFlutterState();

  static ServerSideFlutterState get instance {
    final zoneKey = _zoneKey;
    if (zoneKey!=null) {
      final zoned = Zone.current[zoneKey] as ServerSideFlutterState?;
      if (zoned!=null) {
        return zoned;
      }
    }
    return _root;
  }

  GestureBinding? gestureBinding;
  PaintingBinding? paintingBinding;
  RendererBinding? rendererBinding;
  SchedulerBinding? schedulerBinding;
  SemanticsBinding? semanticsBinding;
  ServicesBinding? servicesBinding;
  WidgetsBinding? widgetsBinding;

  late final platformDispatcher = PlatformDispatcher();
}