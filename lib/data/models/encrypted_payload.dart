class EncryptedPayload {
  final String cipherText;
  final String iv;

  const EncryptedPayload({
    required this.cipherText,
    required this.iv,
  });

  factory EncryptedPayload.fromJson(Map<String, dynamic> json) {
    return EncryptedPayload(
      cipherText: json['cipherText'] as String,
      iv: json['iv'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cipherText': cipherText,
      'iv': iv,
    };
  }
}