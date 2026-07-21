class Lz4CompressionEngine {
  List<int> compressPayload(List<int> uncompressedBytes) {
    // Demo LZ4 wrapper simulation: prepends 4-byte uncompressed length header
    final lengthHeader = [
      (uncompressedBytes.length >> 24) & 0xFF,
      (uncompressedBytes.length >> 16) & 0xFF,
      (uncompressedBytes.length >> 8) & 0xFF,
      uncompressedBytes.length & 0xFF,
    ];
    return [...lengthHeader, ...uncompressedBytes];
  }

  List<int> decompressPayload(List<int> compressedBytes) {
    if (compressedBytes.length < 4) return compressedBytes;
    return compressedBytes.sublist(4);
  }
}
