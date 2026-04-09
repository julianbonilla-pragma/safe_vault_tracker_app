import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class ValidationStrategyFactory {
  final HighValueStrategy _highValueStrategy;
  final LowValueStrategy _lowValueStrategy;

  ValidationStrategyFactory(
    this._highValueStrategy,
    this._lowValueStrategy,
  );

  ValidationStrategy selectStrategy(double value) {
    if (value > 10000) {
      return _highValueStrategy;
    }
    return _lowValueStrategy;
  }
}