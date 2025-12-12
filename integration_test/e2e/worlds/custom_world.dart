import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:safe_vault_tracker_app/domain/entities/asset.dart';
import 'package:safe_vault_tracker_app/domain/strategies/validation_strategy.dart';

class CustomWorld extends FlutterWorld {
  Asset? currentAsset;

  String? assetName;
  double? assetValue;
  String? assetType;

  ValidationStrategy? strategy;
  String? strategyType;

  bool? validationPassed;
  Exception? error;
  String? errorMessage;

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
    super.dispose();
  }
}