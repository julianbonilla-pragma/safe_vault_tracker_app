import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class CreateAssetDropdown extends StatelessWidget {
  const CreateAssetDropdown({
    super.key,
    required this.maxWidth,
    required this.notifier,
  });

  final double maxWidth;
  final CreateAssetNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: maxWidth,
      menuHeight: 240,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.light,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide:
              BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      label: const Text('Type'),
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 'crypto', label: 'Crypto'),
        DropdownMenuEntry(value: 'note', label: 'Note'),
        DropdownMenuEntry(value: 'password', label: 'Password'),
      ],
      onSelected: (value) {
        if (value == null) return;
        notifier.onTypeChanged(value);
      },
    );
  }
}