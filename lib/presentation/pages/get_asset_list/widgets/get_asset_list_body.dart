import 'package:flutter/material.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class GetAssetListBody extends StatelessWidget {
  const GetAssetListBody({
    super.key,
    required this.notifier,
    required this.formattingHandler,
  });

  final GetAssetListNotifier notifier;
  final AssetFormattingHandler formattingHandler;

  @override
  Widget build(BuildContext context) {
    final state = notifier.state;

    switch (state) {
      case GetLoadingState():
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        );
      case GetSuccessState(:final assets):
        if (assets.isEmpty) {
          return const Center(child: Text('No assets found. Add some!'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final Asset asset = assets[index];
            final textStyle = formattingHandler.apply(
              asset,
              AppTypography.label,
            );
            final icon = AssetDisplayHelper.handleIcon(asset.type);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(129, 36, 34, 34),
                    blurRadius: 12,
                    offset: Offset(0, 0.5),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(icon),
                ),
                title: Text(asset.name, style: textStyle),
                subtitle: Text('Value: ${AssetDisplayHelper.maskValue(asset)}', style: textStyle),
                trailing: IconButton(
                  onPressed: () => showDeleteModal(
                    context: context,
                    asset: asset,
                    notifier: notifier,
                  ),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            );
          },
        );
      case GetErrorState(:final message):
        return Center(child: Text(message));
    }
  }

  void showDeleteModal({
    required BuildContext context,
    required Asset asset,
    required GetAssetListNotifier notifier,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Do you want to delete ${asset.name}?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await notifier.deleteAsset(asset.id);
              },
              child: const Text('YES'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('NO'),
            ),
          ],
        ),
      );
    });
  }
}