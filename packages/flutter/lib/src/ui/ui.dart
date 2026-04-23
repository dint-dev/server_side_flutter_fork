// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Built-in types and core primitives for a Flutter application.
///
/// To use, import `package:flutter/ui.dart`.
///
/// This library exposes the lowest-level services that Flutter frameworks use
/// to bootstrap applications, such as classes for driving the input, graphics
/// text, layout, and rendering subsystems.
library;

import 'dart:async';
import 'dart:collection' as collection;
import 'dart:convert';
import 'dart:isolate' show Isolate, SendPort;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/src/server_side_flutter_state.dart';

part 'annotations.dart';
part 'channel_buffers.dart';
part 'compositing.dart';
part 'geometry.dart';
part 'hooks.dart';
part 'isolate_name_server.dart';
part 'key.dart';
part 'lerp.dart';
part 'math.dart';
part 'natives.dart';
part 'painting.dart';
part 'platform_dispatcher.dart';
part 'platform_isolate.dart';
part 'plugins.dart';
part 'pointer.dart';
part 'semantics.dart';
part 'text.dart';
part 'window.dart';
