import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:nekotomatatabi/services/camera_photo_geometry.dart';

img.Image pattern(int width, int height) {
  final result = img.Image(width: width, height: height);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      result.setPixelRgb(x, y, x * 20, y * 20, 10);
    }
  }
  return result;
}

void main() {
  test('Android avoids the iOS extra 90-degree preview rotation', () {
    for (var i = 0; i < 20; i++) {
      final landscape = i.isOdd;
      expect(
        cameraPreviewCorrectionQuarterTurns(TargetPlatform.android, landscape),
        0,
      );
      expect(
        cameraPreviewCorrectionQuarterTurns(TargetPlatform.iOS, landscape),
        landscape ? 3 : 0,
      );
      expect(
        cameraPreviewCorrectionQuarterTurns(TargetPlatform.windows, landscape),
        landscape ? 3 : 0,
      );
    }
  });
  test('landscape JPEG preserves scenery direction and pixel proportions', () {
    final result = prepareCameraPhoto(
      pattern(8, 4),
      const Size(200, 100),
      platform: TargetPlatform.android,
    );
    expect((result.width, result.height), (8, 4));
    expect(result.getPixel(7, 0).r, 140);
    expect(result.getPixel(0, 3).g, 60);
  });
  test('portrait and landscape EXIF orientation is baked exactly once', () {
    for (final orientation in [1, 3, 6, 8]) {
      final raw = pattern(8, 4)..exif.imageIfd.orientation = orientation;
      // Round-trip actual JPEG EXIF, rather than only an in-memory flag.
      final decoded = img.decodeJpg(img.encodeJpg(raw, quality: 100))!;
      final expected = img.bakeOrientation(decoded);
      final size = Size(expected.width.toDouble(), expected.height.toDouble());
      final actual = prepareCameraPhoto(
        decoded,
        size,
        platform: TargetPlatform.android,
      );
      expect((actual.width, actual.height), (expected.width, expected.height));
      expect(actual.getPixel(0, 0).r, expected.getPixel(0, 0).r);
      expect(
        actual.getPixel(actual.width - 1, actual.height - 1).g,
        expected.getPixel(expected.width - 1, expected.height - 1).g,
      );
      expect(actual.exif.imageIfd.orientation ?? 1, 1);
    }
  });
  test('cover crop cuts the center without stretching', () {
    final actual = prepareCameraPhoto(
      pattern(8, 4),
      const Size(100, 100),
      platform: TargetPlatform.android,
    );
    expect((actual.width, actual.height), (4, 4));
    expect(actual.getPixel(0, 0).r, 40);
    expect(actual.getPixel(3, 3).r, 100);
    expect(actual.getPixel(3, 3).g, 60);
  });
  test('front camera photo can match the mirrored Android preview', () {
    final actual = prepareCameraPhoto(
      pattern(8, 4),
      const Size(200, 100),
      platform: TargetPlatform.android,
      mirrorHorizontally: true,
    );
    expect(actual.getPixel(0, 0).r, 140);
    expect(actual.getPixel(7, 0).r, 0);
  });
  test('iOS legacy landscape fallback remains separate', () {
    final raw = pattern(4, 8);
    final actual = prepareCameraPhoto(
      raw,
      const Size(200, 100),
      platform: TargetPlatform.iOS,
    );
    final expected = img.copyRotate(raw, angle: -90);
    expect((actual.width, actual.height), (8, 4));
    expect(actual.getPixel(0, 0).r, expected.getPixel(0, 0).r);
    expect(actual.getPixel(0, 0).g, expected.getPixel(0, 0).g);
  });
}
