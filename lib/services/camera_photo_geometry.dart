import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Android's CameraPreview already applies its own orientation rotation.
/// Preserve existing iOS/desktop behavior without applying it to Android.
int cameraPreviewCorrectionQuarterTurns(
  TargetPlatform platform,
  bool landscape,
) =>
    platform != TargetPlatform.android && landscape ? 3 : 0;

/// Bake JPEG orientation once, then apply the same centered cover crop as preview.
/// CameraX uses display rotation for JPEG orientation. Its EXIF is authoritative;
/// aspect ratio alone must not trigger another rotation.
img.Image prepareCameraPhoto(
  img.Image source,
  Size previewSize, {
  required TargetPlatform platform,
  bool mirrorHorizontally = false,
}) {
  var oriented = img.bakeOrientation(source);
  if (mirrorHorizontally) oriented = img.flipHorizontal(oriented);
  if (previewSize.width <= 1 || previewSize.height <= 1) return oriented;
  final targetLandscape = previewSize.width > previewSize.height;
  if (platform != TargetPlatform.android &&
      targetLandscape != (oriented.width > oriented.height)) {
    oriented = img.copyRotate(
      oriented,
      angle: targetLandscape ? -90 : 90,
      interpolation: img.Interpolation.linear,
    );
  }
  final targetAspect = previewSize.width / previewSize.height;
  final sourceAspect = oriented.width / oriented.height;
  if ((sourceAspect - targetAspect).abs() < .0001) return oriented;
  if (sourceAspect > targetAspect) {
    final width = (oriented.height * targetAspect)
        .round()
        .clamp(1, oriented.width)
        .toInt();
    return img.copyCrop(
      oriented,
      x: ((oriented.width - width) / 2).round(),
      y: 0,
      width: width,
      height: oriented.height,
    );
  }
  final height =
      (oriented.width / targetAspect).round().clamp(1, oriented.height).toInt();
  return img.copyCrop(
    oriented,
    x: 0,
    y: ((oriented.height - height) / 2).round(),
    width: oriented.width,
    height: height,
  );
}
