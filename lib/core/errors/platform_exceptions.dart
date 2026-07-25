class DiLangPlatformException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const DiLangPlatformException(this.message, {this.code, this.details});

  @override
  String toString() => 'DiLangPlatformException($code): $message';
}

class StorageException extends DiLangPlatformException {
  const StorageException(super.message, {super.code, super.details});
}

class AiInferenceException extends DiLangPlatformException {
  const AiInferenceException(super.message, {super.code, super.details});
}

class SpeechException extends DiLangPlatformException {
  const SpeechException(super.message, {super.code, super.details});
}
