import 'package:flutter/cupertino.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class CreateAssetNotifier extends ChangeNotifier {
  final CreateAssetUsecase _createAssetUsecase;

  CreateAssetState _state = const InitialState();
  CreateAssetState get state => _state;

  CreateAssetNotifier(this._createAssetUsecase);

  Future<void> createAsset({
    required String name,
    required double value,
    required String type,
  }) async {
    _updateState(const LoadingState());

    try {
      await _createAssetUsecase.execute(
        name: name,
        value: value,
        type: type,
      );
      _updateState(const SuccessState());
    } on InvalidAssetException catch (e) {
      _updateState(ErrorState(
        message: 'Error de validación: ${e.message}',
        exception: e,
      ));
    } catch (e) {
      final bool isException = e is Exception;
      _updateState(ErrorState(
        message: 'Error al crear el activo',
        exception: isException ? e : Exception('Error desconocido'),
      ));
    }
  }

  void _updateState(CreateAssetState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    _updateState(const InitialState());
  }
}