import 'package:safe_vault_tracker_app/core/errors/invalid_asset_exception.dart';

enum AssetType {
  crypto,
  note,
  password;

  static bool isValid(String value) =>
      AssetType.values.any((e) => e.name == value);
  
  static AssetType fromString(String value) {
    try {
      return AssetType.values.firstWhere(
        (e) => e.name == value,
      );
    } catch (e) {
      throw InvalidAssetException('Invalid AssetType: $value');
    }
  }
}