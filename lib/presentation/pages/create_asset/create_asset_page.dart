import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: _buildAppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CreateAssetField(
                controller: _nameController,
                label: 'Name',
                onChanged: context.read<CreateAssetNotifier>().onNameChanged,
              ),
              const SizedBox(height: 12),
              CreateAssetField(
                controller: _valueController,
                label: 'Value',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: context.read<CreateAssetNotifier>().onValueChanged,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final notifier = context.read<CreateAssetNotifier>();

                  return CreateAssetDropdown(
                    maxWidth: constraints.maxWidth,
                    notifier: notifier,
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer<CreateAssetNotifier>(
                builder: (context, notifier, _) {
                  return CreateAssetBottom(
                    notifier: notifier,
                    handleAsset: _handleAsset,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Create Asset',
        style: AppTypography.appBarTitle.copyWith(
          color: AppColors.light,
        ),
      ),
      backgroundColor: AppColors.primary,
    );
  }

  void _handleAsset() {
    final selectedType = _notifier.selectedType;
    if (selectedType == null) return;

    final String name = _nameController.text;
    final double value = double.tryParse(_valueController.text) ?? 0;

    _notifier.createAsset(
      name: name,
      value: value,
      type: selectedType,
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