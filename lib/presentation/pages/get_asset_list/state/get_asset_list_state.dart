import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

sealed class GetAssetListState {
  const GetAssetListState();
}

class GetLoadingState extends GetAssetListState {
  const GetLoadingState();
}

class GetSuccessState extends GetAssetListState {
  final List<Asset> assets;

  const GetSuccessState({required this.assets});
}

class GetErrorState extends GetAssetListState {
  final String message;
  final Exception exception;

  const GetErrorState({
    required this.message,
    required this.exception,
  });
}