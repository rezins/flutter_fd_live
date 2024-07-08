import 'dart:math';

extension LivenessListExtension on List<Point<int>> {
    List<List<Point<int>>> splitInChunks({required int chunkSize}) {
    List<List<Point<int>>> chunks = [];
    for (var i = 0; i < length; i += chunkSize) {
      chunks.add(
        sublist(
          i,
          i + chunkSize > length ? length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}

