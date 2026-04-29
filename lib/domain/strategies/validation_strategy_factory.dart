import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class ValidationStrategyFactory {
  final List<ValidationStrategy> _strategies;

  const ValidationStrategyFactory(this._strategies);

  ValidationStrategy selectStrategy(double value) {
    return _strategies.firstWhere(
      (strategy) => strategy.appliesTo(value),
      orElse: () => throw InvalidAssetException('No validation strategy found for value: $value'),
    );
  }
}