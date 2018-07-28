import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import "package:gifencoder/gifencoder.dart" as gifencoder;

const int size = 200;
const int frameCount = 32;
const int framesPerSecond = 15;

void drawSquare(CanvasRenderingContext2D ctx, int frameNumber) {
  final frameFraction = (frameNumber / frameCount);
  final green = 0;
  final blue = 0;
  for (int i = 0; i < size / 2; i++) {
    final drawnFraction = i / (size / 2);
    final red = (256 * (frameFraction + drawnFraction)).floor() % 256;
    ctx
      ..fillStyle = "rgb($red,$green,$blue)"
      ..fillRect(i, i, size - i * 2, size - i * 2);
  }
}

Future<String> createDataUrl(Uint8List bytes) {
  final c = new Completer<String>();
  final f = new FileReader();
  f.onLoadEnd.listen((ProgressEvent e) {
    if (f.readyState == FileReader.DONE) {
      final String url = f.result;
      c.complete(url.replaceFirst("data:;", "data:image/gif;"));
    }
  });
  f.readAsDataUrl(new Blob([bytes]));
  return c.future;
}

void main() {
  final ctx = new CanvasElement(width: size, height: size).context2D;
  final frames = new gifencoder.GifBuffer(size, size);
  for (var i = 0; i < frameCount; i++) {
    drawSquare(ctx, i);
    frames.add(ctx.getImageData(0, 0, size, size).data);
  }
  final Uint8List gif = frames.build(framesPerSecond);
  createDataUrl(gif).then((dataUrl) {
    (querySelector("#gif") as ImageElement)..src = dataUrl;
  });
}
