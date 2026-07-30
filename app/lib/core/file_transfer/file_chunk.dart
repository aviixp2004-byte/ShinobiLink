import 'dart:typed_data';

class FileChunk {
  final String transferId;
  final int index;
  final Uint8List data;
  final bool isLast;

  const FileChunk({
    required this.transferId,
    required this.index,
    required this.data,
    required this.isLast,
  });
}
