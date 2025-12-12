class InvalidAssetException implements Exception {
  final String message;

  InvalidAssetException([this.message = 'The provided asset is invalid.']);

  @override
  String toString() => 'InvalidAssetException: $message';
}