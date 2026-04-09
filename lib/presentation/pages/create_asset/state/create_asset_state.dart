sealed class CreateAssetState {
  const CreateAssetState();
}

class InitialState extends CreateAssetState {
  const InitialState();
}

class LoadingState extends CreateAssetState {
  const LoadingState();
}

class SuccessState extends CreateAssetState {
  final String? message;

  const SuccessState({this.message});
}

class ErrorState extends CreateAssetState {
  final String message;
  final Exception? exception;

  const ErrorState({required this.message, this.exception});

  bool get isValidationError =>
      exception?.runtimeType.toString().contains('InvalidAsset') ?? false;
}