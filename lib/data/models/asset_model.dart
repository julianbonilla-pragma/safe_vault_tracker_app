import '../../domain/entities/asset.dart';

class AssetModel {
  final String id;
  final String name;
  final double value;
  final String type;
  final bool isEncrypted;

  const AssetModel({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
    required this.isEncrypted,
  });

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'] as String,
      name: map['name'] as String,
      value: (map['value'] as num).toDouble(),
      type: map['type'] as String,
      isEncrypted: map['isEncrypted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'type': type,
      'isEncrypted': isEncrypted,
    };
  }

  factory AssetModel.fromEntity(Asset asset) {
    return AssetModel(
      id: asset.id,
      name: asset.name,
      value: asset.value,
      type: asset.type,
      isEncrypted: asset.isEncrypted,
    );
  }

  Asset toEntity() {
    return Asset.fromTrustedSource(
      id: id,
      name: name,
      value: value,
      type: type,
      isEncrypted: isEncrypted
    );
  }
}