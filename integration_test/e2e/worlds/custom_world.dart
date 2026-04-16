import 'package:gherkin/gherkin.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class CustomWorld extends World {
  Asset? currentAsset;

  String? assetName;
  double? assetValue;
  String? assetType;

  ValidationStrategy? strategy;
  String? strategyType;

  bool? validationPassed;
  Exception? error;
  String? errorMessage;

  // Inputs for CreateAssetUsecase
  String? createName;
  double? createValue;
  String? createType;

  // Mocks and use case
  AssetRepository? mockRepository;
  ValidationStrategyFactory? mockStrategyFactory;
  ValidationStrategy? mockHighStrategy;
  ValidationStrategy? mockLowStrategy;

  CreateAssetUsecase? createAssetUsecase;
  Exception? createException;

  @override
  void dispose() {
    currentAsset = null;
    assetName = null;
    assetValue = null;
    assetType = null;
    strategy = null;
    strategyType = null;
    validationPassed = null;
    error = null;
    errorMessage = null;
    createName = null;
    createValue = null;
    createType = null;
    mockRepository = null;
    mockStrategyFactory = null;
    mockHighStrategy = null;
    mockLowStrategy = null;
    createAssetUsecase = null;
    createException = null;
    super.dispose();
  }
}