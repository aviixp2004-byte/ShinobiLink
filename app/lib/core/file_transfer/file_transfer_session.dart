import 'file_metadata.dart';

class FileTransferSession {
  final FileMetadata metadata;
  int receivedChunks;

  FileTransferSession({
    required this.metadata,
    this.receivedChunks = 0,
  });

  double get progress =>
      metadata.totalChunks == 0
          ? 0
          : receivedChunks / metadata.totalChunks;

  bool get completed =>
      receivedChunks >= metadata.totalChunks;
}
