import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class CreateAssetField extends StatelessWidget {
  const CreateAssetField({
    super.key,
    required this.controller,
    required this.label,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: _roundedInputDecoration(label: label),
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
  }

  InputDecoration _roundedInputDecoration({required String label}) {
    const borderRadius = BorderRadius.all(Radius.circular(14));

    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.light,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: const OutlineInputBorder(
        borderRadius: borderRadius,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Color(0xFFD0D5DD)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}