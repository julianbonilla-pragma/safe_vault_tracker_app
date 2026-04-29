import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

/// Estrategia de validación para assets de alto valor (> 10000).
/// 
/// Aplica reglas estrictas para garantizar la seguridad de
/// activos valiosos.
class HighValueStrategy implements ValidationStrategy {
  @override
  bool appliesTo(double value) => value > AssetConstants.highValue;
  
  @override
  void validate(Asset asset) {
    // Validación 1: El valor debe ser mayor a 10000
    if (asset.value <= AssetConstants.highValue) {
      throw InvalidAssetException(
        'High value assets must exceed ${AssetConstants.highValue}. Current value: ${asset.value}'
      );
    }
    
    // Validación 2: El nombre debe tener al menos 5 caracteres (más descriptivo)
    if (asset.name.length < 5) {
      throw InvalidAssetException(
        'High value assets must have a descriptive name (min 5 characters)'
      );
    }
    
    // Validación 3: Para cryptos de alto valor, debe mencionar 'wallet' o 'address'
    if (asset.type == AssetType.crypto) {
      final nameLower = asset.name.toLowerCase();
      if (!nameLower.contains('wallet') && !nameLower.contains('address')) {
        throw InvalidAssetException(
          'High value crypto assets should include "wallet" or "address" in the name'
        );
      }
    }
  }
}
