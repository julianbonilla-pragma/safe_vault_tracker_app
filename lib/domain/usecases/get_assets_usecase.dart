import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class GetAssetsUsecase {
  final AssetRepository _repository;

  const GetAssetsUsecase(this._repository);

  Future<List<Asset>> execute() async {
    return await _repository.getAll();
  }
}