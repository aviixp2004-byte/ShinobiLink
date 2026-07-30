import 'dart:typed_data';

import 'file_chunk.dart';

class FileChunker {
  static const int chunkSize = 64 * 1024;

  static List<FileChunk> split({
    required String transferId,
    required Uint8List bytes,
  }) {
    final chunks = <FileChunk>[];

    int index = 0;

    for (int offset = 0; offset < bytes.length; offset += chunkSize) {
      final end = (offset + chunkSize < bytes.length)
          ? offset + chunkSize
          : bytes.length;

      chunks.add(
        FileChunk(
          transferId: transferId,
          index: index++,
          data: Uint8List.sublistView(bytes, offset, end),
          isLast: end == bytes.length,
        ),
      );
    }

    return chunks;
  }
}
