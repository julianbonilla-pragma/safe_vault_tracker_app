import '../repositories/asset_repository.dart';

class DeleteAssetUsecase {
  final AssetRepository _repository;

  const DeleteAssetUsecase(this._repository);

  Future<void> execute(String id) async {
    await _repository.delete(id);
  }
}