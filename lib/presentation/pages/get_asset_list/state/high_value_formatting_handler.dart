import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class HighValueFormattingHandler extends AssetFormattingHandler {
  const HighValueFormattingHandler({super.nextHandler});

  @override
  bool canHandle(Asset asset) => asset.value > 10000;

  @override
  TextStyle handle(Asset asset, TextStyle baseStyle) {
    return baseStyle.copyWith(
      color: AppColors.error,
      fontWeight: FontWeight.bold,
    );
  }
}