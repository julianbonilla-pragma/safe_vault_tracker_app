import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class AssetDisplayHelper {
  static const Map<AssetType, IconData> _typeLabels = {
    AssetType.note: Icons.note,
    AssetType.password: Icons.lock,
    AssetType.crypto: Icons.currency_bitcoin,
  };

  static String maskValue(Asset asset) {
    if (asset.type == AssetType.password) return '••••••••';
    return asset.value.toString();
  }

  static IconData handleIcon(AssetType type) =>
      _typeLabels[type] ?? Icons.help_outline;
}