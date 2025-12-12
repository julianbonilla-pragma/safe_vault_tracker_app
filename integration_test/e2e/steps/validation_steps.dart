import 'package:safe_vault_tracker_app/domain/entities/asset.dart';
import 'package:safe_vault_tracker_app/domain/strategies/high_value_strategy.dart';
import 'package:safe_vault_tracker_app/domain/strategies/low_value_strategy.dart';
import 'package:safe_vault_tracker_app/domain/strategies/validation_strategy.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/custom_world.dart';

/// BACKGROUND STEP
StepDefinitionGeneric GivenValidationSystemIsSetup() {
  return given1<String, CustomWorld>(
    r'that the validation system is set up',
    (parameter, context) async {
      context.world.dispose();
    },
  );
}

// GIVEN: Asset with specific value
StepDefinitionGeneric GivenAssetWithValue() {
  return given1<num, CustomWorld>(
    r'that I have an asset with (?:a )?value (?:of )?{num}',
    (parameter, context) async {
      context.world.assetValue = parameter.toDouble();
    },
  );
}

// GIVEN: Asset's name
StepDefinitionGeneric GivenAssetName() {
  return given1<String, CustomWorld>(
    r"the asset's name is {string}",
    (name, context) async {
      context.world.assetName = name;
    },
  );
}

// GIVEN: Asset's type
StepDefinitionGeneric GivenAssetType() {
  return given1<String, CustomWorld>(
    r"the asset's type is {string}",
    (type, context) async {
      context.world.assetType = type;
    },
  );
}

// WHEN: Apply HighValueStrategy
StepDefinitionGeneric WhenApplyHighValueStrategy() {
  return when<CustomWorld>(
    r'I apply the HighValueStrategy',
    (context) async {
      try {
        context.world.currentAsset = Asset.create(
          name: context.world.assetName!,
          value: context.world.assetValue!,
          type: context.world.assetType!,
        );

        final ValidationStrategy strategy = HighValueStrategy();
        context.world.strategy = strategy;
        context.world.strategyType = 'HighValue';

        strategy.validate(context.world.currentAsset!);

        context.world.validationPassed = true;
        context.world.error = null;
        context.world.errorMessage = null;
      } catch (e) {
        context.world.validationPassed = false;
        context.world.error = e as Exception;
        context.world.errorMessage = e.toString();
      }
    },
  );
}

// WHEN: Apply LowValueStrategy
StepDefinitionGeneric WhenApplyLowValueStrategy() {
  return when<CustomWorld>(
    r'I apply the LowValueStrategy',
    (context) async {
      try {
        context.world.currentAsset = Asset.create(
          name: context.world.assetName!,
          value: context.world.assetValue!,
          type: context.world.assetType!,
        );

        final ValidationStrategy strategy = LowValueStrategy();
        context.world.strategy = strategy;
        context.world.strategyType = 'LowValue';

        strategy.validate(context.world.currentAsset!);

        context.world.validationPassed = true;
        context.world.error = null;
        context.world.errorMessage = null;
      } catch (e) {
        context.world.validationPassed = false;
        context.world.error = e as Exception;
        context.world.errorMessage = e.toString();
      }
    },
  );
}

// THEN: Validation should pass
StepDefinitionGeneric ThenValidationShouldPass() {
  return then<CustomWorld>(
    r'(?:the )?validation (?:must|should) pass successfully',
    (context) async {
      if (context.world.validationPassed != true) {
        throw Exception(
          'Expected validation to pass, but it failed with error: ${context.world.errorMessage}',
        );
      }
    },
  );
}

// THEN: Validation should fail
StepDefinitionGeneric ThenValidationShouldFail() {
  return then<CustomWorld>(
    r'(?:the )?validation (?:must|should) fail',
    (context) async {
      if (context.world.validationPassed != false) {
        throw Exception('Expected validation to fail, but it passed successfully.');
      }

      if (context.world.error == null) {
        throw Exception('Expected an error to be thrown, but none was found.');
      }
    },
  );
}

// THEN: Error should mention specific text
StepDefinitionGeneric ThenErrorShouldMentionText() {
  return then1<String, CustomWorld>(
    r'(?:the )?error (?:must|should) mention {string}',
    (expectedText, context) async {
      if (context.world.errorMessage == null) {
        throw Exception(
          'Expected error message but none was found.',
        );
      }

      final errorMessage = context.world.errorMessage!.toLowerCase();
      final searchText = expectedText.toLowerCase();

      if (!errorMessage.contains(searchText)) {
        throw Exception(
          'Expected error message to mention "$expectedText", '
          'but got: "${context.world.errorMessage}"',
        );
      }
    },
  );
}