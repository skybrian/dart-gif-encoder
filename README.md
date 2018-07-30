# gifencoder

[![Pub Package Version](https://img.shields.io/pub/v/gifencoder.svg)](https://pub.dartlang.org/packages/gifencoder)
[![Latest Dartdocs](https://img.shields.io/badge/dartdocs-latest-blue.svg)](https://pub.dartlang.org/documentation/gifencoder/latest)

A gif encoder written in Dart.

## Usage

To create a regular GIF:

```dart
import 'dart:html';
import 'package:gifencoder/gifencoder.dart';

int width = ...;
int height = ...;
var ctx = new CanvasElement(width: width, height: height).context2D;
// draw your image in the canvas context
var data = ctx.getImageData(0, 0, width, height);
List<int> bytes = gifencoder.makeGif(width, height, data.data)
```

To create an animated Gif, use a GifBuffer instead:

```dart
int framesPerSecond = ...;
var frames = new gifencoder.GifBuffer(width, height);
for (var i = 0; i < myFrameCount; i++) {
    // draw the next frame on the canvas context
    frames.add(ctx.getImageData(0, 0, width, height).data);
}
List<int> bytes = frames.build(framesPerSecond);
```

Once you have the bytes of the GIF, you can save it somewhere or convert it into a data URL. See `example/example.dart` for how to do that. You can run the example by running the following: `pub run build_runner serve` and then connecting to localhost in the browser on port 8081.

## Testing

To test in the VM:

```bash
pub run test -p vm
```

To run browser tests in Chrome:

```bash
pub run build_runner test --release -- -p chrome
```

You can also access the tests from a browser by running `pub run build_runner serve` and then connecting to localhost in the browser on port 8080.