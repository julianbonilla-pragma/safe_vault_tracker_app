import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class CreateAssetBottom extends StatelessWidget {
  const CreateAssetBottom({
    super.key,
    required this.notifier,
    required this.handleAsset,
  });

  final CreateAssetNotifier notifier;
  final VoidCallback handleAsset;

  @override
  Widget build(BuildContext context) {
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
          ? handleAsset
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
}