import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'file_chunk.dart';
import 'file_chunker.dart';
import 'file_metadata.dart';
import 'file_transfer_session.dart';

class PreparedFileTransfer {
  final FileMetadata metadata;
  final List<FileChunk> chunks;

  const PreparedFileTransfer({
    required this.metadata,
    required this.chunks,
  });
}

class FileTransferService {
  final _uuid = const Uuid();

  final Map<String, FileTransferSession> _sessions = {};

  final _progressController =
      StreamController<FileTransferSession>.broadcast();

  Stream<FileTransferSession> get progressStream =>
      _progressController.stream;

  Future<PreparedFileTransfer> prepareFile({
    required File file,
    required String senderId,
    required String receiverId,
    required String mimeType,
  }) async {
    final bytes = await file.readAsBytes();

    final transferId = _uuid.v4();

    final chunks = FileChunker.split(
      transferId: transferId,
      bytes: bytes,
    );

    final metadata = FileMetadata(
      transferId: transferId,
      fileName: file.uri.pathSegments.last,
      fileSize: bytes.length,
      mimeType: mimeType,
      totalChunks: chunks.length,
      senderId: senderId,
      receiverId: receiverId,
    );

    final session = FileTransferSession(
      metadata: metadata,
    );

    _sessions[transferId] = session;

    _progressController.add(session);

    return PreparedFileTransfer(
      metadata: metadata,
      chunks: chunks,
    );
  }

  FileTransferSession? session(String id) => _sessions[id];

  void updateProgress(String id, int receivedChunks) {
    final session = _sessions[id];
    if (session == null) return;

    session.receivedChunks = receivedChunks;
    _progressController.add(session);
  }

  void complete(String id) {
    final session = _sessions.remove(id);
    if (session != null) {
      _progressController.add(session);
    }
  }

  void dispose() {
    _progressController.close();
  }
}
