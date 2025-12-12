import 'dart:isolate';
import 'package:encrypt/encrypt.dart';

import '../../domain/services/encryption_service.dart';

/// Adaptador que implementa EncryptionService usando la librería 'encrypt'.
/// 
/// Ejecuta las operaciones de cifrado/descifrado en Isolates para
/// evitar bloquear la UI durante operaciones CPU intensivas.
class EncryptAdapter implements EncryptionService {
  final Encrypter _encrypter;
  final IV _iv;

  EncryptAdapter(this._encrypter, this._iv);

  @override
  Future<String> encrypt(String plainText) async {
    // Ejecutar cifrado en un Isolate (background thread)
    return await Isolate.run(() {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    });
  }

  @override
  Future<String> decrypt(String cipherText) async {
    // Ejecutar descifrado en un Isolate (background thread)
    return await Isolate.run(() {
      final decrypted = _encrypter.decrypt64(cipherText, iv: _iv);
      return decrypted;
    });
  }
}