import 'package:equatable/equatable.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';
import 'package:uuid/uuid.dart';

class Asset extends Equatable {
  final String id;
  final String name;
  final double value;
  final AssetType type;
  final bool isEncrypted;

  const Asset._({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
    this.isEncrypted = false,
  });

  factory Asset.create({
    required String name,
    required double value,
    required String type,
    bool isEncrypted = false,
    String? id,
  }) {
    if (name.isEmpty || value <= 0) {
      throw InvalidAssetException('Asset name cannot be empty and value must be greater than zero');
    }

    if (!AssetType.isValid(type)) {
      throw InvalidAssetException('Asset type must be one of the following: ${AssetType.values.map((e) => e.name).join(', ')}');
    }

    return Asset._(
      id: id ?? Uuid().v4(),
      name: name,
      value: value,
      type: AssetType.fromString(type),
      isEncrypted: isEncrypted,
    );
  }

  factory Asset.fromTrustedSource({
    required String id,
    required String name,
    required double value,
    required String type,
    required bool isEncrypted,
  }) {
    return Asset._(
      id: id,
      name: name,
      value: value,
      type: AssetType.fromString(type),
      isEncrypted: isEncrypted,
    );
  }
  
  @override
  List<Object?> get props => [id, name, value, type, isEncrypted];
}