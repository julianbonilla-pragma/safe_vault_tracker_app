import 'package:flutter/material.dart';
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

  String _selectedType = 'crypto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Asset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedType,
              items: ['crypto', 'note', 'password']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
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
    );
  }

  Widget _buildWidget(CreateAssetNotifier notifier) {
    switch (notifier.state) {
      case LoadingState():
        return _buildButton(notifier: notifier, isLoading: true);
      case SuccessState(:final String? message):
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message ?? 'Asset creado exitosamente')),
          );
          Future.delayed(const Duration(milliseconds: 500));
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
      onPressed: isLoading ? null : () => _handleAsset(context, notifier),
      child: isLoading 
          ? const Row(
            mainAxisSize: MainAxisSize.min,
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
              Text('Cifrando...'),
            ],
          )
          : const Text('Crear Asset'),
    );
  }

  void _handleAsset(BuildContext context, CreateAssetNotifier notifier) {
    final String name = _nameController.text;
    final double value = double.tryParse(_valueController.text) ?? 0;

    notifier.createAsset(
      name: name,
      value: value,
      type: _selectedType,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}