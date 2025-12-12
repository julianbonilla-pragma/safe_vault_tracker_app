import 'package:safe_vault_tracker_app/domain/entities/asset.dart';

import '../repositories/asset_repository.dart';
import '../strategies/validation_strategy.dart';

/// Use Case para crear un nuevo asset.
/// 
/// Utiliza el patrón Strategy para aplicar diferentes
/// validaciones según las reglas de negocio.
class CreateAssetUsecase {
  final AssetRepository _repository;
  final ValidationStrategy _validationStrategy;

  const CreateAssetUsecase(
    this._repository,
    this._validationStrategy,
  );

  /// Ejecuta la creación de un asset.
  /// 
  /// 1. Crea el asset con validaciones básicas (Factory Method)
  /// 2. Aplica validaciones adicionales según la estrategia
  /// 3. Guarda el asset en el repositorio
  Future<void> execute({
    required String name,
    required double value,
    required String type,
  }) async {
    // Paso 1: Crear asset (validaciones básicas del Factory)
    final asset = Asset.create(
      name: name,
      value: value,
      type: type,
    );
    
    // Paso 2: Aplicar estrategia de validación (validaciones adicionales)
    _validationStrategy.validate(asset);
    
    // Paso 3: Guardar si todas las validaciones pasaron
    await _repository.save(asset);
  }
}