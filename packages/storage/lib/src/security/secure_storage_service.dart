import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract class SecureStorageContract {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}

class MemorySecureStorage implements SecureStorageContract {
  final Map<String, String> _store = {};
  final String masterKey;

  MemorySecureStorage({String? masterKey})
      : masterKey = masterKey ?? 'dilang_sec_key_${DateTime.now().millisecondsSinceEpoch}';

  String _hashKey(String key) {
    return sha256.convert(utf8.encode('$masterKey:$key')).toString();
  }

  @override
  Future<String?> read(String key) async {
    final hashed = _hashKey(key);
    return _store[hashed];
  }

  @override
  Future<void> write(String key, String value) async {
    final hashed = _hashKey(key);
    _store[hashed] = value;
  }

  @override
  Future<void> delete(String key) async {
    final hashed = _hashKey(key);
    _store.remove(hashed);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}
