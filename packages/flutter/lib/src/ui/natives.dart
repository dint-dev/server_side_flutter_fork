// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
part of 'ui.dart';

/// Helper functions for Dart Plugin Registrants.
abstract final class DartPluginRegistrant {
  /// Makes sure the that the Dart Plugin Registrant has been called for this
  /// isolate. This can safely be executed multiple times on the same isolate,
  /// but should not be called on the Root isolate.
  static void ensureInitialized() {}
}

void _printDebug(String arg) {
  _Logger._printDebugString(arg);
}

class _Logger {
  static void _printDebugString(String? s) {

  }
}

// If we actually run on big endian machines, we'll need to do something smarter
// here. We don't use [Endian.Host] because it's not a compile-time
// constant and can't propagate into the set/get calls.
const Endian _kFakeHostEndian = Endian.little;

const bool _impellerEnabled = false;

const int _implicitViewId = 0;
