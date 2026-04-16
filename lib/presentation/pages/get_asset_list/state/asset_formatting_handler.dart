import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

abstract class AssetFormattingHandler {
  final AssetFormattingHandler? nextHandler;

  const AssetFormattingHandler({this.nextHandler});

  TextStyle apply(Asset asset, TextStyle baseStyle) {
    if (canHandle(asset)) {
      return handle(asset, baseStyle);
    }
    return nextHandler?.apply(asset, baseStyle) ?? baseStyle;
  }

  bool canHandle(Asset asset);
  TextStyle handle(Asset asset, TextStyle baseStyle);

  String maskValue(Asset asset) {
    if (asset.type == 'password') return '••••••••';
    return asset.value.toString();
  }

  IconData handleIcon(String type) {
    IconData iconData;
    switch (type) {
      case 'note':
        iconData = Icons.note;
        break;
      case 'password':
        iconData = Icons.lock;
        break;
      default:
        iconData = Icons.currency_bitcoin;
        break;
    }
    return iconData;
  }
}