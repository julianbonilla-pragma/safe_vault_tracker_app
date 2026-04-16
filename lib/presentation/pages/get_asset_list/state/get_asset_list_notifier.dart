import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class GetAssetListNotifier extends ChangeNotifier {
  final GetAssetsUsecase _getAssetListUsecase;
  final DeleteAssetUsecase _deleteAssetUsecase;

  GetAssetListState _state = const GetLoadingState();
  GetAssetListState get state => _state;

  GetAssetListNotifier(this._getAssetListUsecase, this._deleteAssetUsecase);
  
  Future<void> getAssetList() async {
    try {
      final List<Asset> assets = await _getAssetListUsecase.execute();
      _updateState(GetSuccessState(assets: assets));
    } catch (e) {
      final bool isException = e is Exception;
      _updateState(GetErrorState(
        message: 'Error loading asset list',
        exception: isException ? e : Exception('Unknown error'),
      ));
    }
  }

  Future<void> deleteAsset(String id) async {
    _updateState(const GetLoadingState());
    try {
      await _deleteAssetUsecase.execute(id);
      await getAssetList();
    } catch (e) {
      final bool isException = e is Exception;
      _updateState(GetErrorState(
        message: 'Error deleting asset',
        exception: isException ? e : Exception('Unknown error'),
      ));
    }
  }

  void _updateState(GetAssetListState state) {
    _state = state;
    notifyListeners();
  }
}