Feature: CreateAssetUsecase orchestration with Strategy
  As the app developer
  I want the CreateAssetUsecase to use the correct ValidationStrategy
  So that high and low value assets are validated and saved correctly

  Background:
    Given the create asset system is configured with mocked dependencies

  Scenario: High-value asset uses HighValueStrategy and is saved
    Given I want to create an asset with value 50000
    And the asset creation name is "High Value Asset"
    And the asset creation type is "crypto"
    When I execute the CreateAssetUsecase
    Then the HighValueStrategy must be used for validation
    And the LowValueStrategy must not be used
    And the asset must be saved in the repository

  Scenario: Validation fails so the asset is not saved
    Given I want to create an asset with value 50000
    And the asset creation name is "Invalid Asset"
    And the asset creation type is "crypto"
    And the HighValueStrategy will reject the asset
    When I execute the CreateAssetUsecase
    Then the HighValueStrategy must be used for validation
    And the asset must not be saved in the repository
    And an error must be exposed to the world