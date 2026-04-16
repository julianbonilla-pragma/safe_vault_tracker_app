import 'package:flutter/cupertino.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class CreateAssetNotifier extends ChangeNotifier {
  final CreateAssetUsecase _createAssetUsecase;

  CreateAssetState _state = const InitialState();
  CreateAssetState get state => _state;

  String _name = '';
  String _value = '';
  String? _type;
  bool _isFormValid = false;

  bool get isFormValid => _isFormValid;
  String? get selectedType => _type;

  CreateAssetNotifier(this._createAssetUsecase);

  void onNameChanged(String value) {
    _name = value;
    _validateForm();
  }

  void onValueChanged(String value) {
    _value = value;
    _validateForm();
  }

  void onTypeChanged(String value) {
    _type = value;
    _validateForm();
  }

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
        message: 'Validation error: ${e.message}',
        exception: e,
      ));
    } catch (e) {
      final bool isException = e is Exception;
      _updateState(ErrorState(
        message: 'Error creating asset',
        exception: isException ? e : Exception('Unknown error'),
      ));
    }
  }

  void _updateState(CreateAssetState state) {
    _state = state;
    notifyListeners();
  }

  void _validateForm() {
    final bool newValue =
      _name.trim().isNotEmpty &&
      _value.trim().isNotEmpty &&
      _type != null &&
      _type!.trim().isNotEmpty;

    if (newValue == _isFormValid) return;

    _isFormValid = newValue;
    notifyListeners();
  }

  void resetState({bool notify = true}) {
    _state = const InitialState();
    if (notify) {
      notifyListeners();
    }
  }

  void resetForm({bool notify = true}) {
    final bool changed =
        _name.isNotEmpty || _value.isNotEmpty || _type != null || _isFormValid;

    _name = '';
    _value = '';
    _type = null;
    _isFormValid = false;

    if (notify && changed) {
      notifyListeners();
    }
  }
}