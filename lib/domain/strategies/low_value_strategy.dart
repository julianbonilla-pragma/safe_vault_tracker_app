import '../../core/errors/invalid_asset_exception.dart';
import '../entities/asset.dart';
import 'validation_strategy.dart';

/// Estrategia de validación para assets de bajo valor (≤ 10000).
/// 
/// Aplica reglas más relajadas para activos de menor valor.
class LowValueStrategy implements ValidationStrategy {
  static const double _maxValue = 10000.0;
  
  @override
  void validate(Asset asset) {
    // Validación 1: El valor debe ser menor o igual a 10000
    if (asset.value > _maxValue) {
      throw InvalidAssetException(
        'Low value assets must be $_maxValue or less. Current value: ${asset.value}'
      );
    }
    
    // Validación 2: El nombre debe tener al menos 3 caracteres (menos estricto)
    if (asset.name.length < 3) {
      throw InvalidAssetException(
        'Asset name must have at least 3 characters'
      );
    }
    
    // Para assets de bajo valor, no hay validaciones adicionales
    // (más relajado que HighValueStrategy)
  }
}
