import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptionConfig {
  static const String _storageKey = 'encryption_key';
  static const String _ivStorageKey = 'encryption_iv';

  final SharedPreferences _prefs;

  EncryptionConfig(this._prefs);

  Future<Key> getOrCreateKey() async {
    String? storedKey = _prefs.getString(_storageKey);

    if (storedKey != null) {
      return Key.fromBase64(storedKey);
    }

    final key = Key.fromSecureRandom(32); // AES-256
    await _prefs.setString(_storageKey, key.base64);

    return key;
  }

  Future<IV> getOrCreateIV() async {
    String? storedIV = _prefs.getString(_ivStorageKey);

    if (storedIV != null) {
      return IV.fromBase64(storedIV);
    }

    final iv = IV.fromSecureRandom(16); // AES block size
    await _prefs.setString(_ivStorageKey, iv.base64);

    return iv;
  }

  Encrypter createEncrypter(Key key) {
    return Encrypter(AES(key));
  }
}