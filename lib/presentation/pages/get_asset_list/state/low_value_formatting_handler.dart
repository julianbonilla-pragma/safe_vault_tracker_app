import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class LowValueFormattingHandler extends AssetFormattingHandler {
  const LowValueFormattingHandler({super.nextHandler});

  @override
  bool canHandle(Asset asset) => asset.value <= AssetConstants.highValue;

  @override
  TextStyle handle(Asset asset, TextStyle baseStyle) {
    return baseStyle.copyWith(
      color: AppColors.success,
    );
  }
}