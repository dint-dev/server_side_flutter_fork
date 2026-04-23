// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
part of 'ui.dart';

/// An opaque object representing a composited scene.
///
/// To create a Scene object, use a [SceneBuilder].
///
/// Scene objects can be displayed on the screen using the [FlutterView.render]
/// method.
abstract class Scene {
  /// Synchronously creates a handle to an image from this scene.
  ///
  /// {@macro dart.ui.painting.Picture.toImageSync}
  Image toImageSync(int width, int height);

  /// Creates a raster image representation of the current state of the scene.
  ///
  /// This is a slow operation that is performed on a background thread.
  ///
  /// Callers must dispose the [Image] when they are done with it. If the result
  /// will be shared with other methods or classes, [Image.clone] should be used
  /// and each handle created must be disposed.
  Future<Image> toImage(int width, int height);

  /// Releases the resources used by this scene.
  ///
  /// After calling this function, the scene is cannot be used further.
  ///
  /// This can't be a leaf call because the native function calls Dart API
  /// (Dart_SetNativeInstanceField).
  void dispose();
}

// Lightweight wrapper of a native layer object.
//
// This is used to provide a typed API for engine layers to prevent
// incompatible layers from being passed to [SceneBuilder]'s push methods.
// For example, this prevents a layer returned from `pushOpacity` from being
// passed as `oldLayer` to `pushTransform`. This is achieved by having one
// concrete subclass of this class per push method.
abstract class _EngineLayerWrapper implements EngineLayer {
  _EngineLayerWrapper._(EngineLayer nativeLayer) : _nativeLayer = nativeLayer;

  EngineLayer? _nativeLayer;

  @override
  void dispose() {
    assert(_nativeLayer != null, 'Object disposed');
    _nativeLayer!.dispose();
    assert(() {
      _nativeLayer = null;
      return true;
    }());
  }
}

/// An opaque handle to a transform engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushTransform].
///
/// {@template dart.ui.sceneBuilder.oldLayerCompatibility}
/// `oldLayer` parameter in [SceneBuilder] methods only accepts objects created
/// by the engine. [SceneBuilder] will throw an [AssertionError] if you pass it
/// a custom implementation of this class.
/// {@endtemplate}
class TransformEngineLayer extends _EngineLayerWrapper {
  TransformEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to an offset engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushOffset].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class OffsetEngineLayer extends _EngineLayerWrapper {
  OffsetEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a clip rect engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushClipRect].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ClipRectEngineLayer extends _EngineLayerWrapper {
  ClipRectEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a clip rounded rect engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushClipRRect].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ClipRRectEngineLayer extends _EngineLayerWrapper {
  ClipRRectEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a clip rounded superellipse engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushClipRSuperellipse].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ClipRSuperellipseEngineLayer extends _EngineLayerWrapper {
  ClipRSuperellipseEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a clip path engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushClipPath].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ClipPathEngineLayer extends _EngineLayerWrapper {
  ClipPathEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to an opacity engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushOpacity].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class OpacityEngineLayer extends _EngineLayerWrapper {
  OpacityEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a color filter engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushColorFilter].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ColorFilterEngineLayer extends _EngineLayerWrapper {
  ColorFilterEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to an image filter engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushImageFilter].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ImageFilterEngineLayer extends _EngineLayerWrapper {
  ImageFilterEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a backdrop filter engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushBackdropFilter].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class BackdropFilterEngineLayer extends _EngineLayerWrapper {
  BackdropFilterEngineLayer._(super.nativeLayer) : super._();
}

/// An opaque handle to a shader mask engine layer.
///
/// Instances of this class are created by [SceneBuilder.pushShaderMask].
///
/// {@macro dart.ui.sceneBuilder.oldLayerCompatibility}
class ShaderMaskEngineLayer extends _EngineLayerWrapper {
  ShaderMaskEngineLayer._(super.nativeLayer) : super._();
}

/// Builds a [Scene] containing the given visuals.
///
/// A [Scene] can then be rendered using [FlutterView.render].
///
/// To draw graphical operations onto a [Scene], first create a
/// [Picture] using a [PictureRecorder] and a [Canvas], and then add
/// it to the scene using [addPicture].
///
/// ## Use with the Flutter framework
///
/// The Flutter framework's [RendererBinding] provides a hook for creating
/// [SceneBuilder] objects ([RendererBinding.createSceneBuilder]) that allows
/// tests to hook into the scene creation logic. When creating a [SceneBuilder]
/// in the context of the Flutter framework, consider calling
/// [RendererBinding.createSceneBuilder] instead of calling the
/// [SceneBuilder.new] constructor directly.
///
/// This does not apply when using the `package:flutter/ui.dart` API directly, without using the
/// Flutter framework bindings, `flutter_test` framework, et al.
abstract class SceneBuilder {
  factory SceneBuilder() {
    throw UnimplementedError();
  }

  /// Pushes a transform operation onto the operation stack.
  ///
  /// The objects are transformed by the given matrix before rasterization.
  ///
  /// {@template dart.ui.sceneBuilder.oldLayer}
  /// If `oldLayer` is not null the engine will attempt to reuse the resources
  /// allocated for the old layer when rendering the new layer. This is purely
  /// an optimization. It has no effect on the correctness of rendering.
  /// {@endtemplate}
  ///
  /// {@template dart.ui.sceneBuilder.oldLayerVsRetained}
  /// Passing a layer to [addRetained] or as `oldLayer` argument to a push
  /// method counts as _usage_. A layer can be used no more than once in a scene.
  /// For example, it may not be passed simultaneously to two push methods, or
  /// to a push method and to `addRetained`.
  ///
  /// When a layer is passed to [addRetained] all descendant layers are also
  /// considered as used in this scene. The same single-usage restriction
  /// applies to descendants.
  ///
  /// When a layer is passed as an `oldLayer` argument to a push method, it may
  /// no longer be used in subsequent frames. If you would like to continue
  /// reusing the resources associated with the layer, store the layer object
  /// returned by the push method and use that in the next frame instead of the
  /// original object.
  /// {@endtemplate}
  ///
  /// See [pop] for details about the operation stack.
  TransformEngineLayer pushTransform(Float64List matrix4, {TransformEngineLayer? oldLayer});

  /// Pushes an offset operation onto the operation stack.
  ///
  /// This is equivalent to [pushTransform] with a matrix with only translation.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack.
  OffsetEngineLayer pushOffset(double dx, double dy, {OffsetEngineLayer? oldLayer});

  /// Pushes a rectangular clip operation onto the operation stack.
  ///
  /// Rasterization outside the given rectangle is discarded.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack, and [Clip] for different clip modes.
  /// By default, the clip will be anti-aliased (clip = [Clip.antiAlias]).
  ClipRectEngineLayer pushClipRect(
    Rect rect, {
    Clip clipBehavior = Clip.antiAlias,
    ClipRectEngineLayer? oldLayer,
  });

  /// Pushes a rounded-rectangular clip operation onto the operation stack.
  ///
  /// Rasterization outside the given rounded rectangle is discarded.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack, and [Clip] for different clip modes.
  /// By default, the clip will be anti-aliased (clip = [Clip.antiAlias]).
  ClipRRectEngineLayer pushClipRRect(
    RRect rrect, {
    Clip clipBehavior = Clip.antiAlias,
    ClipRRectEngineLayer? oldLayer,
  });

  /// Pushes a rounded-superellipse clip operation onto the operation stack.
  ///
  /// Rasterization outside the given rounded superellipse is discarded.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack, and [Clip] for different clip modes.
  /// By default, the clip will be anti-aliased (clip = [Clip.antiAlias]).
  ClipRSuperellipseEngineLayer pushClipRSuperellipse(
    RSuperellipse rsuperellipse, {
    Clip clipBehavior = Clip.antiAlias,
    ClipRSuperellipseEngineLayer? oldLayer,
  });

  /// Pushes a path clip operation onto the operation stack.
  ///
  /// Rasterization outside the given path is discarded.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack. See [Clip] for different clip modes.
  /// By default, the clip will be anti-aliased (clip = [Clip.antiAlias]).
  ClipPathEngineLayer pushClipPath(
    Path path, {
    Clip clipBehavior = Clip.antiAlias,
    ClipPathEngineLayer? oldLayer,
  });

  /// Pushes an opacity operation onto the operation stack.
  ///
  /// The given alpha value is blended into the alpha value of the objects'
  /// rasterization. An alpha value of 0 makes the objects entirely invisible.
  /// An alpha value of 255 has no effect (i.e., the objects retain the current
  /// opacity).
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack.
  OpacityEngineLayer pushOpacity(
    int alpha, {
    Offset? offset = Offset.zero,
    OpacityEngineLayer? oldLayer,
  });

  /// Pushes a color filter operation onto the operation stack.
  ///
  /// The given color is applied to the objects' rasterization using the given
  /// blend mode.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack.
  ColorFilterEngineLayer pushColorFilter(ColorFilter filter, {ColorFilterEngineLayer? oldLayer});

  /// Pushes an image filter operation onto the operation stack.
  ///
  /// The given filter is applied to the children's rasterization before compositing them into
  /// the scene.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack.
  ImageFilterEngineLayer pushImageFilter(
    ImageFilter filter, {
    Offset offset = Offset.zero,
    ImageFilterEngineLayer? oldLayer,
  });

  /// Pushes a backdrop filter operation onto the operation stack.
  ///
  /// The given filter is applied to the current contents of the scene as far back as
  /// the most recent save layer and rendered back to the scene using the indicated
  /// [blendMode] prior to rasterizing the child layers.
  ///
  /// If [backdropId] is provided and not null, then this value is treated
  /// as a unique identifier for the backdrop. When the first backdrop filter with
  /// a given id is processed during rasterization, the state of the backdrop is
  /// recorded and cached. All subsequent backdrop filters with the same identifier
  /// will apply their filter to the cached backdrop. The correct usage of the
  /// backdrop id has the benefit of dramatically improving performance for
  /// applications with multiple backdrop filters. For example, an application
  /// that uses a backdrop blur filter for each item in a list view should set
  /// all filters to have the same backdrop id.
  ///
  /// If overlapping backdrop filters use the same backdropId, then each filter
  /// will apply to the backdrop before the overlapping filter components were
  /// rendered.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack.
  BackdropFilterEngineLayer pushBackdropFilter(
    ImageFilter filter, {
    BlendMode blendMode = BlendMode.srcOver,
    BackdropFilterEngineLayer? oldLayer,
    int? backdropId,
  });

  /// Pushes a shader mask operation onto the operation stack.
  ///
  /// The given shader is applied to the object's rasterization in the given
  /// rectangle using the given blend mode.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayer}
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  ///
  /// See [pop] for details about the operation stack.
  ShaderMaskEngineLayer pushShaderMask(
    Shader shader,
    Rect maskRect,
    BlendMode blendMode, {
    ShaderMaskEngineLayer? oldLayer,
    FilterQuality filterQuality = FilterQuality.low,
  });

  /// Ends the effect of the most recently pushed operation.
  ///
  /// Internally the scene builder maintains a stack of operations. Each of the
  /// operations in the stack applies to each of the objects added to the scene.
  /// Calling this function removes the most recently added operation from the
  /// stack.
  void pop();

  /// Add a retained engine layer subtree from previous frames.
  ///
  /// All the engine layers that are in the subtree of the retained layer will
  /// be automatically appended to the current engine layer tree.
  ///
  /// Therefore, when implementing a subclass of the [Layer] concept defined in
  /// the rendering layer of Flutter's framework, once this is called, there's
  /// no need to call [Layer.addToScene] for its children layers.
  ///
  /// {@macro dart.ui.sceneBuilder.oldLayerVsRetained}
  void addRetained(EngineLayer retainedLayer);

  /// Adds an object to the scene that displays performance statistics.
  ///
  /// Useful during development to assess the performance of the application.
  /// The enabledOptions controls which statistics are displayed. The bounds
  /// controls where the statistics are displayed.
  ///
  /// enabledOptions is a bit field with the following bits defined:
  ///  - 0x01: displayRasterizerStatistics - show raster thread frame time
  ///  - 0x02: visualizeRasterizerStatistics - graph raster thread frame times
  ///  - 0x04: displayEngineStatistics - show UI thread frame time
  ///  - 0x08: visualizeEngineStatistics - graph UI thread frame times
  /// Set enabledOptions to 0x0F to enable all the currently defined features.
  ///
  /// The "UI thread" is the thread that includes all the execution of the main
  /// Dart isolate (the isolate that can call [FlutterView.render]). The UI
  /// thread frame time is the total time spent executing the
  /// [PlatformDispatcher.onBeginFrame] callback. The "raster thread" is the
  /// thread (running on the CPU) that subsequently processes the [Scene]
  /// provided by the Dart code to turn it into GPU commands and send it to the
  /// GPU.
  ///
  /// See also the [PerformanceOverlayOption] enum in the rendering library.
  /// for more details.
  // Values above must match constants in //engine/src/sky/compositor/performance_overlay_layer.h
  void addPerformanceOverlay(int enabledOptions, Rect bounds);

  /// Adds a [Picture] to the scene.
  ///
  /// The picture is rasterized at the given `offset`.
  ///
  /// The rendering _may_ be cached to reduce the cost of painting the picture
  /// if it is reused in subsequent frames. Whether a picture is cached or not
  /// depends on the backend implementation. When caching is considered, the
  /// choice to cache or not cache is a heuristic based on how often the picture
  /// is being painted and the cost of painting the picture. To disable this
  /// caching, set `willChangeHint` to true. To force the caching to happen (in
  /// backends that do caching), set `isComplexHint` to true. When both are set,
  /// `willChangeHint` prevails.
  ///
  /// In general, setting these hints is not very useful. Backends that cache
  /// pictures only do so for pictures that have been rendered three times
  /// already; setting `willChangeHint` to true to avoid caching an animating
  /// picture that changes every frame is therefore redundant, the picture
  /// wouldn't have been cached anyway. Similarly, backends that cache pictures
  /// are relatively aggressive about doing so, such that any image complicated
  /// enough to warrant caching is probably already being cached even without
  /// `isComplexHint` being set to true.
  void addPicture(
    Offset offset,
    Picture picture, {
    bool isComplexHint = false,
    bool willChangeHint = false,
  });

  /// Adds a backend texture to the scene.
  ///
  /// The texture is scaled to the given size and rasterized at the given offset.
  ///
  /// If `freeze` is true the texture that is added to the scene will not
  /// be updated with new frames. `freeze` is used when resizing an embedded
  /// Android view: When resizing an Android view there is a short period during
  /// which the framework cannot tell if the newest texture frame has the
  /// previous or new size, to workaround this the framework "freezes" the
  /// texture just before resizing the Android view and un-freezes it when it is
  /// certain that a frame with the new size is ready.
  void addTexture(
    int textureId, {
    Offset offset = Offset.zero,
    double width = 0.0,
    double height = 0.0,
    bool freeze = false,
    FilterQuality filterQuality = FilterQuality.low,
  });

  /// Adds a platform view (e.g an iOS UIView) to the scene.
  ///
  /// On iOS this layer splits the current output surface into two surfaces, one for the scene nodes
  /// preceding the platform view, and one for the scene nodes following the platform view.
  ///
  /// ## Performance impact
  ///
  /// Adding an additional surface doubles the amount of graphics memory directly used by Flutter
  /// for output buffers. Quartz might allocated extra buffers for compositing the Flutter surfaces
  /// and the platform view.
  ///
  /// With a platform view in the scene, Quartz has to composite the two Flutter surfaces and the
  /// embedded UIView. In addition to that, on iOS versions greater than 9, the Flutter frames are
  /// synchronized with the UIView frames adding additional performance overhead.
  ///
  /// The `offset` argument is not used for iOS and Android.
  void addPlatformView(
    int viewId, {
    Offset offset = Offset.zero,
    double width = 0.0,
    double height = 0.0,
  });

  /// Finishes building the scene.
  ///
  /// Returns a [Scene] containing the objects that have been added to
  /// this scene builder. The [Scene] can then be displayed on the
  /// screen with [FlutterView.render].
  ///
  /// After calling this function, the scene builder object is invalid and
  /// cannot be used further.
  Scene build();
}