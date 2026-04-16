import 'dart:io';

import 'package:gherkin/gherkin.dart';

import 'configuration.dart';

Future<void> main() {
  final projectRoot = Directory.current.path;
  
  final config = gherkinTestConfiguration
    ..features = [
      '$projectRoot/integration_test/e2e/features/validation_strategy.feature',
      '$projectRoot/integration_test/e2e/features/create_asset_usecase.feature',
    ];

  return GherkinRunner().execute(config);
}
