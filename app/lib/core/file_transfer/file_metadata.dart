class FileMetadata {
  final String transferId;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final int totalChunks;
  final String senderId;
  final String receiverId;

  const FileMetadata({
    required this.transferId,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.totalChunks,
    required this.senderId,
    required this.receiverId,
  });

  Map<String, dynamic> toJson() => {
        'transferId': transferId,
        'fileName': fileName,
        'fileSize': fileSize,
        'mimeType': mimeType,
        'totalChunks': totalChunks,
        'senderId': senderId,
        'receiverId': receiverId,
      };

  factory FileMetadata.fromJson(Map<String, dynamic> json) {
    return FileMetadata(
      transferId: json['transferId'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      mimeType: json['mimeType'],
      totalChunks: json['totalChunks'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
    );
  }
}
