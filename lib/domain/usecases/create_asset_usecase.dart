import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

/// Use Case para crear un nuevo asset.
/// 
/// Utiliza el patrón Strategy para aplicar diferentes
/// validaciones según las reglas de negocio.
class CreateAssetUsecase {
  final AssetRepository _repository;
  final ValidationStrategyFactory _strategyFactory;

  const CreateAssetUsecase(
    this._repository,
    this._strategyFactory,
  );

  /// Ejecuta la creación de un asset.
  /// 
  /// 1. Crea el asset con validaciones básicas (Factory Method)
  /// 2. Valida el asset con la estrategia seleccionada (Strategy Pattern)
  /// 3. Aplica validaciones adicionales según la estrategia
  /// 4. Guarda el asset en el repositorio
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

    // Paso 2: Validar con la estrategia seleccionada
    final ValidationStrategy validationStrategy =
        _strategyFactory.selectStrategy(asset.value);
    
    // Paso 3: Aplicar estrategia de validación (validaciones adicionales)
    validationStrategy.validate(asset);
    
    // Paso 4: Guardar si todas las validaciones pasaron
    await _repository.save(asset);
  }
}