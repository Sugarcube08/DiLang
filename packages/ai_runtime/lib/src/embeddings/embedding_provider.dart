abstract class EmbeddingProvider {
  Future<void> loadModel(String modelPath);
  Future<List<double>> embedText(String text);
  Future<List<List<double>>> embedBatch(List<String> texts);
  Future<void> unloadModel();
}
