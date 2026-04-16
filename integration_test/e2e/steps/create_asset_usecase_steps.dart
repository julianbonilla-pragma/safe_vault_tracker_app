import 'package:gherkin/gherkin.dart' as gherkin;
import 'package:mocktail/mocktail.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

import '../worlds/custom_world.dart';

class MockAssetRepository extends Mock implements AssetRepository {}
class MockValidationStrategyFactory extends Mock implements ValidationStrategyFactory {}
class MockValidationStrategy extends Mock implements ValidationStrategy {}
class FakeAsset extends Fake implements Asset {}

void registerMocktailFallbacks() {
  registerFallbackValue(FakeAsset());
  registerFallbackValue(0.0);
}

/// BACKGROUND: sistema configurado con dependencias mockeadas
gherkin.StepDefinitionGeneric GivenCreateAssetSystemIsConfigured() {
  return gherkin.given<CustomWorld>(
    r'the create asset system is configured with mocked dependencies',
    (context) async {
      registerMocktailFallbacks();

      final repo = MockAssetRepository();
      final high = MockValidationStrategy();
      final low = MockValidationStrategy();
      final factory = MockValidationStrategyFactory();

      when(() =>factory.selectStrategy(any<double>())).thenAnswer((invocation) {
        final value = invocation.positionalArguments.first as double;
        return value >= 10000 ? high : low;
      });

      context.world
        ..mockRepository = repo
        ..mockHighStrategy = high
        ..mockLowStrategy = low
        ..mockStrategyFactory = factory
        ..createAssetUsecase = CreateAssetUsecase(repo, factory)
        ..createException = null
        ..createName = null
        ..createValue = null
        ..createType = null;
    },
  );
}

/// GIVEN: valor del asset a crear
gherkin.StepDefinitionGeneric GivenCreateAssetValue() {
  return gherkin.given1<num, CustomWorld>(
    r'I want to create an asset with value {num}',
    (value, context) async {
      context.world.createValue = value.toDouble();
    },
  );
}

/// GIVEN: nombre del asset a crear
gherkin.StepDefinitionGeneric GivenCreateAssetName() {
  return gherkin.given1<String, CustomWorld>(
    r'the asset creation name is {string}',
    (name, context) async {
      context.world.createName = name;
    },
  );
}

/// GIVEN: tipo del asset a crear
gherkin.StepDefinitionGeneric GivenCreateAssetType() {
  return gherkin.given1<String, CustomWorld>(
    r'the asset creation type is {string}',
    (type, context) async {
      context.world.createType = type;
    },
  );
}

/// GIVEN: la HighValueStrategy va a rechazar el asset
gherkin.StepDefinitionGeneric GivenHighStrategyWillReject() {
  return gherkin.given<CustomWorld>(
    r'the HighValueStrategy will reject tha asset',
    (context) async {
      when(() => context.world.mockHighStrategy!.validate(any()))
          .thenThrow(InvalidAssetException('Simulated rejection'));
    },
  );
}

/// WHEN: ejecuto el caso de uso
gherkin.StepDefinitionGeneric WhenExecuteCreateAssetUsecase() {
  return gherkin.when<CustomWorld>(
    r'I execute the CreateAssetUsecase',
    (context) async {
      final world = context.world;
      try {
        await world.createAssetUsecase!.execute(
          name: world.createName!,
          value: world.createValue!,
          type: world.createType!,
        );
        world.createException = null;
      } catch (e) {
        world.createException = e as Exception;
      }
    },
  );
}

/// THEN: se debe usar HighValueStrategy
gherkin.StepDefinitionGeneric ThenHighStrategyMustBeUsed() {
  return gherkin.then<CustomWorld>(
    r'the HighValueStrategy must be used for validation',
    (context) async {
      verify(() => context.world.mockHighStrategy!.validate(any()))
          .called(1);
    },
  );
}

/// THEN: no se debe usar LowValueStrategy
gherkin.StepDefinitionGeneric ThenLowStrategyMustNotBeUsed() {
  return gherkin.then<CustomWorld>(
    r'the LowValueStrategy must not be used',
    (context) async {
      verifyNever(() => context.world.mockLowStrategy!.validate(any()));
    },
  );
}

/// THEN: el asset debe guardarse en el repositorio
gherkin.StepDefinitionGeneric ThenAssetMustBeSaved() {
  return gherkin.then<CustomWorld>(
    r'the asset must be saved in the repository',
    (context) async {
      verify(() => context.world.mockRepository!.save(any())).called(1);
    },
  );
}

/// THEN: el asset no debe guardarse en el repositorio
gherkin.StepDefinitionGeneric ThenAssetMustNotBeSaved() {
  return gherkin.then<CustomWorld>(
    r'the asset must not be saved in the repository',
    (context) async {
      verifyNever(() => context.world.mockRepository!.save(any()));
    },
  );
}

/// THEN: debe exponerse un error al mundo
gherkin.StepDefinitionGeneric ThenAnErrorMustBeExposed() {
  return gherkin.then<CustomWorld>(
    r'an error must be exposed to the world',
    (context) async {
      if (context.world.createException == null) {
        throw Exception('Expected an error, but none was found.');
      }
    },
  );
}