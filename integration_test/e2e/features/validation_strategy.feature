Feature: Asset validation with the Strategy pattern
  As the app developer
  I want to apply different validation strategies depending on the value of the asset
  To ensure that business rules are followed correctly

  Background:
    Given that the validation system is set up

  # HighValueStrategy Tests
  Scenario: High-value asset valid with crypto wallet
    Given that I have an asset with a value of 50,000
    And the asset's name is "Bitcoin Wallet 1"
    And the asset's type is "crypto"
    When I apply the HighValueStrategy
    Then the validation must pass successfully.

  Scenario: High-value asset with a very short name is bound to fail
    Given that I have an asset with value of 50000
    And the asset's name is "BTC"
    And the asset's type is "crypto"
    When I apply the HighValueStrategy
    Then validation should fail
    And the error should mention "descriptive name"

  Scenario: High-value crypto asset without a wallet in the name
    Given that I have an asset with value of 50000
    And the asset's name is "My Bitcoin Main"
    And the asset's type is "crypto"
    When I apply the HighValueStrategy
    Then validation should fail
    And the error should mention "wallet"

  Scenario: High-value asset with low value should fail
    Given that I have an asset with value of 5000
    And the asset's name is "Test Asset Name"
    And the asset's type is "crypto"
    When I apply the HighValueStrategy
    Then validation should fail
    And the error should mention "exceed 10000"

  # LowValueStrategy Tests
  Scenario: Low value asset valid
    Given that I have an asset with value of 5000
    And the asset's name is "PIN Code"
    And the asset's type is "note"
    When I apply the LowValueStrategy
    Then validation should pass successfully

  Scenario: Low-value asset with a very short name
    Given that I have an asset with value of 5000
    And the asset's name is "AB"
    And the asset's type is "note"
    When I apply the LowValueStrategy
    Then validation should fail
    And the error should mention "at least 3 characters"

  Scenario: Low-value asset with high value must fail
    Given that I have an asset with value of 15000
    And the asset's name is "Test"
    And the asset's type is "note"
    When I apply the LowValueStrategy
    Then validation should fail
    And the error should mention "10000 or less"