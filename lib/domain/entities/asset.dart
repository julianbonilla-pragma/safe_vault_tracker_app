import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/invalid_asset_exception.dart';

class Asset extends Equatable{
  final String id;
  final String name;
  final double value;
  final String type;
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

    const validTypes = ['crypto', 'note', 'password'];
    if (!validTypes.contains(type)) {
      throw InvalidAssetException('Asset type must be one of the following: ${validTypes.join(', ')}');
    }

    return Asset._(
      id: id ?? Uuid().v4(),
      name: name,
      value: value,
      type: type,
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
      type: type,
      isEncrypted: isEncrypted,
    );
  }
  
  @override
  List<Object?> get props => [id, name, value, type, isEncrypted];
}