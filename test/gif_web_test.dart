@TestOn("browser")

library gif_web_test;

import 'dart:html';

import "package:gifencoder/gifencoder.dart" as gif;
import 'package:test/test.dart';

void main() {
  test('one black pixel', () {
    final ctx = new CanvasElement(width: 1, height: 1).context2D
      ..fillStyle = "black"
      ..fillRect(0, 0, 1, 1);
    final data = ctx.getImageData(0, 0, 1, 1);
    final blob = new Blob([gif.makeGif(data.width, data.height, data.data)]);

    final f = new FileReader();

    void loadedDataUrl(ProgressEvent e) {
      expect(f.error, null);
      expect(f.readyState, FileReader.DONE);
      String url = f.result;
      expect(url, startsWith("data:;"));
      url = url.replaceFirst("data:;", "data:image/gif;");
      final img = new ImageElement(src: url);
      img.onLoad.listen(expectAsync1((e) {
        expect(img.width, 1);
        expect(img.height, 1);
        checkPixel(img, 0, 0, [0, 0, 0, 255]);
      }));
    }

    f.onLoadEnd.listen(expectAsync1(loadedDataUrl));
    f.readAsDataUrl(blob);
  });
}

void checkPixel(ImageElement img, int x, int y, List<int> expectedRGBA) {
  final ctx = new CanvasElement(width: x + 1, height: y + 1).context2D
    ..fillStyle = "white"
    ..fillRect(0, 0, x + 1, y + 1)
    ..drawImage(img, 0, 0);
  final data = ctx.getImageData(0, 0, 1, 1).data;
  expect(data, expectedRGBA);
}
