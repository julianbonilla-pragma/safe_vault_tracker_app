import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';
import 'package:provider/provider.dart';

class CreateAssetPage extends StatefulWidget {
  const CreateAssetPage({super.key});

  @override
  State<CreateAssetPage> createState() => _CreateAssetPageState();
}

class _CreateAssetPageState extends State<CreateAssetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  late final CreateAssetNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = context.read<CreateAssetNotifier>();
    _notifier.resetForm(notify: false);
    _notifier.resetState(notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Asset',
          style: AppTypography.appBarTitle.copyWith(
            color: AppColors.light,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: _roundedInputDecoration(label: 'Name'),
                onChanged: context.read<CreateAssetNotifier>().onNameChanged,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _valueController,
                decoration: _roundedInputDecoration(label: 'Value'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: context.read<CreateAssetNotifier>().onValueChanged,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final notifier = context.read<CreateAssetNotifier>();

                  return DropdownMenu<String>(
                    width: constraints.maxWidth,
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
                },
              ),
              const SizedBox(height: 20),
              Consumer<CreateAssetNotifier>(
                builder: (context, notifier, _) {
                  return _buildWidget(notifier);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidget(CreateAssetNotifier notifier) {
    switch (notifier.state) {
      case LoadingState():
        return _buildButton(notifier: notifier, isLoading: true);
      case SuccessState():
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asset created successfully')),
          );
          Future.delayed(const Duration(milliseconds: 500));
          notifier.resetForm();
          context.pop(true);
          notifier.resetState();
        });
        return _buildButton(notifier: notifier);
      case ErrorState(:final String message):
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          notifier.resetState();
        });
        return _buildButton(notifier: notifier);
      default:
        return _buildButton(notifier: notifier);
    }
  }

  Widget _buildButton({
    required CreateAssetNotifier notifier,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: (!isLoading && notifier.isFormValid)
          ? () => _handleAsset(context, notifier)
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.light,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: isLoading 
          ? const Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Text('Encrypting...'),
            ],
          )
          : const Text('Create Asset'),
    );
  }

  void _handleAsset(BuildContext context, CreateAssetNotifier notifier) {
    final selectedType = notifier.selectedType;
    if (selectedType == null) return;

    final String name = _nameController.text;
    final double value = double.tryParse(_valueController.text) ?? 0;

    notifier.createAsset(
      name: name,
      value: value,
      type: selectedType,
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

  @override
  void dispose() {
    _notifier.resetForm(notify: false);
    _notifier.resetState(notify: false);
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}