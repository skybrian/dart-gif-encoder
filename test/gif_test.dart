library gif_test;

import "package:gifencoder/gifencoder.dart" as gif;
import 'package:test/test.dart';

void main() {
  // Based on: http://www.matthewflickinger.com/lab/whatsinagif/bits_and_bytes.asp
  // Also see: http://en.wikipedia.org/wiki/File:Quilt_design_as_46x46_uncompressed_GIF.gif
  const headerBlock = const [0x47, 0x49, 0x46, 0x38, 0x39, 0x61]; // GIF 89a
  const oneByOneTwoColor = const [
    0x1, 0, 0x1, 0, 0xF0, 0, 0 // 1x1, 2 colors, background index 0
  ];
  const blackBlack = const [0, 0, 0, 0, 0, 0]; // 3 bytes per color
  const startOneByOneImage = const [0x2c, 0, 0, 0, 0, 1, 0, 1, 0, 0];
  const startData2 = const [0x02]; // two bit pixels, indexes are 0-3.
  const clear2 = "100"; // clear code for two bit data
  const end2 = "101"; // end code for two bit data
  const trailer = const [0x3b];

  int bits(String s) => int.parse(s, radix: 2);

  test('one black pixel', () {
    final List<int> bytes = gif.makeGif(1, 1, [0, 0, 0, 0]);

    final expected = <int>[]
      ..addAll(headerBlock)
      ..addAll(oneByOneTwoColor)
      ..addAll(blackBlack)
      ..addAll(startOneByOneImage)
      ..addAll(startData2)
      ..addAll([2, bits("01000$clear2"), bits("1"), 0x00])
      ..addAll(trailer);

    expect(bytes, expected);
  });

  const oneByTwoTwoColor = const [
    0x1, 0, 0x2, 0, 0xF0, 0, 0 // 1x2, 2 colors, background index 0
  ];
  const startOneByTwoImage = const [0x2c, 0, 0, 0, 0, 1, 0, 2, 0, 0];

  test('two black pixels', () {
    final List<int> bytes = gif.makeGif(1, 2, [0, 0, 0, 0, 0, 0, 0, 0]);

    final expected = <int>[]
      ..addAll(headerBlock)
      ..addAll(oneByTwoTwoColor)
      ..addAll(blackBlack)
      ..addAll(startOneByTwoImage)
      ..addAll(startData2)
      ..addAll([2, bits("00000$clear2"), bits("${end2}0"), 0x00])
      ..addAll(trailer);

    expect(bytes, expected);
  });

  const oneByThreeTwoColor = const [
    0x1, 0, 0x3, 0, 0xF0, 0, 0 // 1x3, 2 colors, background index 0
  ];
  const startOneByThreeImage = const [0x2c, 0, 0, 0, 0, 1, 0, 3, 0, 0];

  test('three black pixels', () {
    final bytes = gif.makeGif(1, 3, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

    final expected = <int>[]
      ..addAll(headerBlock)
      ..addAll(oneByThreeTwoColor)
      ..addAll(blackBlack)
      ..addAll(startOneByThreeImage)
      ..addAll(startData2)
      ..addAll([2, bits("10000$clear2"), bits("${end2}1"), 0x00])
      ..addAll(trailer);

    expect(bytes, expected);
  });

  const oneByFourTwoColor = const [
    0x1, 0, 0x4, 0, 0xF0, 0, 0 // 1x4, 2 colors, background index 0
  ];
  const startOneByFourImage = const [0x2c, 0, 0, 0, 0, 1, 0, 4, 0, 0];

  test('four black pixels', () {
    final List<int> bytes =
        gif.makeGif(1, 4, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

    final expected = <int>[]
      ..addAll(headerBlock)
      ..addAll(oneByFourTwoColor)
      ..addAll(blackBlack)
      ..addAll(startOneByFourImage)
      ..addAll(startData2)
      ..addAll([2, bits("10000$clear2"), bits("${end2}0001"), 0x00])
      ..addAll(trailer);

    expect(bytes, expected);
  });

  const oneBySevenTwoColor = const [
    0x1, 0, 0x7, 0, 0xF0, 0, 0 // 1x7, 2 colors, background index 0
  ];
  const startOneBySevenImage = const [0x2c, 0, 0, 0, 0, 1, 0, 7, 0, 0];

  test('seven black pixels', () {
    final List<int> bytes =
        gif.makeGif(1, 7, new List<int>.generate(28, (_) => 0));

    // bumps to 4-bit codes at the last pixel
    final expected = <int>[]
      ..addAll(headerBlock)
      ..addAll(oneBySevenTwoColor)
      ..addAll(blackBlack)
      ..addAll(startOneBySevenImage)
      ..addAll(startData2)
      ..addAll([3, bits("10000$clear2"), bits("00001111"), bits("0101"), 0x00])
      ..addAll(trailer);

    expect(bytes, expected);
  });

  const threeByOneFourColor = const [
    0x3, 0, 0x1, 0, 0xF1, 0, 0 // 1x2, 4 colors, background index 0
  ];
  const startThreeByOneImage = const [0x2c, 0, 0, 0, 0, 3, 0, 1, 0, 0];
  const redGreenBlueBlack = const [
    0xff, 0, 0, 0, 0xff, 0, 0, 0, 0xff, 0, 0, 0 // 3 bytes per color
  ];

  test('rgb', () {
    final List<int> bytes =
        gif.makeGif(3, 1, [0xff, 0, 0, 0, 0, 0xff, 0, 0, 0, 0, 0xff, 0]);

    final expected = <int>[]
      ..addAll(headerBlock)
      ..addAll(threeByOneFourColor)
      ..addAll(redGreenBlueBlack)
      ..addAll(startThreeByOneImage)
      ..addAll(startData2)
      ..addAll([2, bits("01000$clear2"), bits("1010100"), 0x00])
      ..addAll(trailer);

    expect(bytes, expected);
  });
}
