import 'model_descriptor.dart';

class ModelRegistry {
  final Map<String, ModelDescriptor> _registeredModels = {};

  List<ModelDescriptor> get allModels => List.unmodifiable(_registeredModels.values);

  void registerModel(ModelDescriptor descriptor) {
    _registeredModels[descriptor.modelId] = descriptor;
  }

  ModelDescriptor? getModel(String modelId) => _registeredModels[modelId];

  List<ModelDescriptor> findByCapability(String capability) {
    return _registeredModels.values.where((m) => m.supportedCapabilities.contains(capability)).toList();
  }

  List<ModelDescriptor> findByLanguage(String languageCode) {
    return _registeredModels.values.where((m) => m.targetLanguages.contains(languageCode)).toList();
  }
}
