import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class LowValueFormattingHandler extends AssetFormattingHandler {
  const LowValueFormattingHandler({super.nextHandler});

  @override
  bool canHandle(Asset asset) => asset.value <= 10000;

  @override
  TextStyle handle(Asset asset, TextStyle baseStyle) {
    return baseStyle.copyWith(color: const Color.fromARGB(255, 8, 157, 13));
  }
}