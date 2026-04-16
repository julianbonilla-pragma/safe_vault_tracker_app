import 'package:gherkin/gherkin.dart';

import 'steps/create_asset_usecase_steps.dart';
import 'steps/validation_steps.dart';
import 'worlds/custom_world.dart';

TestConfiguration get gherkinTestConfiguration {
  return TestConfiguration()
    ..stepDefinitions = [
      // Validation Strategy steps
      GivenValidationSystemIsSetup(),
      GivenAssetWithValue(),
      GivenAssetName(),
      GivenAssetType(),
      WhenApplyHighValueStrategy(),
      WhenApplyLowValueStrategy(),
      ThenValidationShouldPass(),
      ThenValidationShouldFail(),
      ThenErrorShouldMentionText(),

      // CreateAssetUsecase steps
      GivenCreateAssetSystemIsConfigured(),
      GivenCreateAssetValue(),
      GivenCreateAssetName(),
      GivenCreateAssetType(),
      GivenHighStrategyWillReject(),
      WhenExecuteCreateAssetUsecase(),
      ThenHighStrategyMustBeUsed(),
      ThenLowStrategyMustNotBeUsed(),
      ThenAssetMustBeSaved(),
      ThenAssetMustNotBeSaved(),
      ThenAnErrorMustBeExposed(),
    ]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      StdoutReporter(MessageLevel.error),
    ]
    ..createWorld = (config) async => CustomWorld();
}
