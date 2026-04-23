// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'ui.dart';

typedef _ListStringArgFunction = Object? Function(List<String> args);

void runMain(
  Function startMainIsolateFunction,
  Function userMainFunction,
  List<String> args,
) {
  // ignore: avoid_dynamic_calls
  startMainIsolateFunction(() {
    if (userMainFunction is _ListStringArgFunction) {
      userMainFunction(args);
    } else {
      userMainFunction(); // ignore: avoid_dynamic_calls
    }
  }, null);
}

/// Invokes [callback] inside the given [zone].
void _invoke(void Function()? callback, Zone zone) {
  if (callback == null) {
    return;
  }
  if (identical(zone, Zone.current)) {
    callback();
  } else {
    zone.runGuarded(callback);
  }
}

/// Invokes [callback] inside the given [zone] passing it [arg].
///
/// The 1 in the name refers to the number of arguments expected by
/// the callback (and thus passed to this function, in addition to the
/// callback itself and the zone in which the callback is executed).
void _invoke1<A>(void Function(A a)? callback, Zone zone, A arg) {
  if (callback == null) {
    return;
  }
  if (identical(zone, Zone.current)) {
    callback(arg);
  } else {
    zone.runUnaryGuarded<A>(callback, arg);
  }
}

/// Invokes [callback] inside the given [zone] passing it [arg1] and [arg2].
///
/// The 2 in the name refers to the number of arguments expected by
/// the callback (and thus passed to this function, in addition to the
/// callback itself and the zone in which the callback is executed).
void _invoke2<A1, A2>(
  void Function(A1 a1, A2 a2)? callback,
  Zone zone,
  A1 arg1,
  A2 arg2,
) {
  if (callback == null) {
    return;
  }
  if (identical(zone, Zone.current)) {
    callback(arg1, arg2);
  } else {
    zone.runGuarded(() {
      callback(arg1, arg2);
    });
  }
}

/// Invokes [callback] inside the given [zone] passing it [arg1], [arg2], and [arg3].
///
/// The 3 in the name refers to the number of arguments expected by
/// the callback (and thus passed to this function, in addition to the
/// callback itself and the zone in which the callback is executed).
void _invoke3<A1, A2, A3>(
  void Function(A1 a1, A2 a2, A3 a3)? callback,
  Zone zone,
  A1 arg1,
  A2 arg2,
  A3 arg3,
) {
  if (callback == null) {
    return;
  }
  if (identical(zone, Zone.current)) {
    callback(arg1, arg2, arg3);
  } else {
    zone.runGuarded(() {
      callback(arg1, arg2, arg3);
    });
  }
}