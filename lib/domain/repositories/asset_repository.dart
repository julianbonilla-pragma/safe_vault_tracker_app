import '../entities/asset.dart';

abstract interface class AssetRepository {
  Future<void> save(Asset asset);
  Future<List<Asset>> getAll();
  Future<void> delete(String id);
  Future<Asset> getById(String id);
}