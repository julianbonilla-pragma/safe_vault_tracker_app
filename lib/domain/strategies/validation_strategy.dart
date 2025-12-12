import '../entities/asset.dart';

/// Interfaz para estrategias de validación de assets.
/// 
/// Cada implementación define reglas específicas de validación
/// según el tipo o valor del asset.
abstract interface class ValidationStrategy {
  /// Valida un asset según las reglas específicas de la estrategia.
  /// 
  /// Lanza [InvalidAssetException] si la validación falla.
  void validate(Asset asset);
}
