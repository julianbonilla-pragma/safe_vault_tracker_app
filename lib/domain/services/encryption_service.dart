import '../../data/models/encrypted_payload.dart';

/// Servicio de cifrado/descifrado de datos sensibles.
/// 
/// Las operaciones son asíncronas para permitir el uso de Isolates
/// y evitar bloquear la UI durante operaciones pesadas.
abstract interface class EncryptionService {
  /// Cifra un texto plano y retorna el resultado en base64.
  Future<EncryptedPayload> encrypt(String plainText);
  
  /// Descifra un texto cifrado en base64 y retorna el texto plano.
  Future<String> decrypt(EncryptedPayload payload);
}