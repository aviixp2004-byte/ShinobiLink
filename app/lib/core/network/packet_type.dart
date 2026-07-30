enum PacketType {
  handshake,
  message,
  image,

  file, // Legacy / generic file message

  fileMetadata,
  fileChunk,
  fileComplete,

  ack,
  read,
  typing,
  pong,
  ping,
  disconnect,
}
