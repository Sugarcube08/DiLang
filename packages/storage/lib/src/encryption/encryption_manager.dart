class StorageEncryptionManager {
  List<int> encryptPayload(List<int> rawBytes, String key) {
    // Simple XOR cipher fallback for pure Dart demonstration
    final keyBytes = key.codeUnits;
    final result = <int>[];
    for (var i = 0; i < rawBytes.length; i++) {
      result.add(rawBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    return result;
  }

  List<int> decryptPayload(List<int> encryptedBytes, String key) {
    return encryptPayload(encryptedBytes, key); // Symmetric XOR
  }
}
