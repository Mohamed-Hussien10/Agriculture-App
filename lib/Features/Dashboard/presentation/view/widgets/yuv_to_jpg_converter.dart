import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

Uint8List convertYUV420ToJPG(CameraImage image) {
  final width = image.width;
  final height = image.height;
  final yPlane = image.planes[0].bytes;
  final uPlane = image.planes[1].bytes;
  final vPlane = image.planes[2].bytes;

  final imgRGB = img.Image(width: width, height: height);

  int yp = 0;
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      final y = yPlane[yp];
      final u = uPlane[(i ~/ 2) * (width ~/ 2) + (j ~/ 2)];
      final v = vPlane[(i ~/ 2) * (width ~/ 2) + (j ~/ 2)];

      int r = (y + 1.402 * (v - 128)).clamp(0, 255).toInt();
      int g =
          (y - 0.344136 * (u - 128) - 0.714136 * (v - 128))
              .clamp(0, 255)
              .toInt();
      int b = (y + 1.772 * (u - 128)).clamp(0, 255).toInt();

      imgRGB.setPixel(j, i, img.ColorUint8.rgba(r, g, b, 255));
      yp++;
    }
  }

  return Uint8List.fromList(img.encodeJpg(imgRGB, quality: 70));
}
