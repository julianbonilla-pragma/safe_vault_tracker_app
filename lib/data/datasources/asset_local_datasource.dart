import 'dart:convert';

import 'package:safe_vault_tracker_app/core/errors/invalid_asset_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/asset.dart';
import '../../domain/services/encryption_service.dart';
import '../models/asset_model.dart';

class AssetLocalDatasource {
  final EncryptionService _encryptionService;
  final SharedPreferences _prefs;

  static const String _assetsKey = 'encrypted_assets';

  const AssetLocalDatasource(
    this._encryptionService,
    this._prefs,
  );

  Future<void> save(Asset asset) async {
    final List<Asset> assets = await getAll();

    final foundIndex =
        assets.indexWhere((element) => element.id == asset.id);
    if (foundIndex != -1) {
      assets[foundIndex] = asset;
    } else {
      assets.add(asset);
    }

    await _saveAllAssets(assets);
  }

  Future<List<Asset>> getAll() async {
    final String? encryptedData = _prefs.getString(_assetsKey);

    if (encryptedData == null || encryptedData.isEmpty) {
      return [];
    }

    // Descifrar en Isolate (no bloquea la UI)
    final decryptedJson = await _encryptionService.decrypt(encryptedData);
    final List<dynamic> jsonList = jsonDecode(decryptedJson);
    final List<Asset> data = jsonList
        .map((jsonItem) => AssetModel.fromMap(jsonItem as Map<String, dynamic>).toEntity())
        .toList();
    
    return data;
  }

  Future<void> delete(String id) async {
    final assets = await getAll();
    assets.removeWhere((asset) => asset.id == id);
    await _saveAllAssets(assets);
  }

  Future<Asset> getById(String id) async {
    final assets = await getAll();
    try {
      final asset = assets.firstWhere((asset) => asset.id == id);
      return asset;
    } catch (e) {
      throw InvalidAssetException('Asset with id $id not found.');
    }
  }

  Future<void> _saveAllAssets(List<Asset> assets) async {
    // Convert assets to model
    final assetModels = assets.map((asset) => AssetModel.fromEntity(asset)).toList();

    // Convert models to JSON string
    final jsonList = assetModels.map((model) => model.toMap()).toList();
    final jsonString = jsonEncode(jsonList);

    // Cifrar en Isolate (no bloquea la UI)
    final encryptedData = await _encryptionService.encrypt(jsonString);

    await _prefs.setString(_assetsKey, encryptedData);
  }
}