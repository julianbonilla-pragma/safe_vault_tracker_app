import 'package:safe_vault_tracker_app/data/datasources/asset_local_datasource.dart';
import 'package:safe_vault_tracker_app/domain/entities/asset.dart';

import '../../domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDatasource _datasource;
  const AssetRepositoryImpl(this._datasource);

  @override
  Future<void> save(Asset asset) async {
    await _datasource.save(asset);
  }

  @override
  Future<List<Asset>> getAll() async{
    return await _datasource.getAll();
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.delete(id);
  }

  @override
  Future<Asset> getById(String id) async {
    return await _datasource.getById(id);
  }
}