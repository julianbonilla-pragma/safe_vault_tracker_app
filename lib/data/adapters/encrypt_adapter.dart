import 'dart:convert';
import 'dart:isolate';
import 'package:encrypt/encrypt.dart';

import '../../domain/services/encryption_service.dart';
import '../models/encrypted_payload.dart';

/// Adaptador que implementa EncryptionService usando la librería 'encrypt'.
/// 
/// Ejecuta las operaciones de cifrado/descifrado en Isolates para
/// evitar bloquear la UI durante operaciones CPU intensivas.
class EncryptAdapter implements EncryptionService {
  final Encrypter _encrypter;
  final IV _iv;

  EncryptAdapter(this._encrypter, this._iv);

  @override
  Future<EncryptedPayload> encrypt(String plainText) async {
    // Ejecutar cifrado en un Isolate (background thread)
    return await Isolate.run(() {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return EncryptedPayload(
        cipherText: encrypted.base64,
        iv: base64Encode(_iv.bytes),
      );
    });
  }

  @override
  Future<String> decrypt(EncryptedPayload payload) async {
    // Ejecutar descifrado en un Isolate (background thread)
    return await Isolate.run(() {
      final iv = IV(base64Decode(payload.iv));
      final decrypted = _encrypter.decrypt64(payload.cipherText, iv: iv);
      return decrypted;
    });
  }
}