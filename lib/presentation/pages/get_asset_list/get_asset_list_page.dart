import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class GetAssetListPage extends StatefulWidget {
  const GetAssetListPage({super.key});

  @override
  State<GetAssetListPage> createState() => _GetAssetListPageState();
}

class _GetAssetListPageState extends State<GetAssetListPage> {
  late final AssetFormattingHandler _formattingHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset List')),
      body: SafeArea(
        child: Consumer<GetAssetListNotifier>(
          builder: (_, notifier, __) {
            return _buildBody(notifier);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await context.push<bool>('/create');
          if (created == true && mounted) {
            await Provider.of<GetAssetListNotifier>(
              context,
              listen: false,
            ).getAssetList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(GetAssetListNotifier notifier) {
    final state = notifier.state;

    switch (state) {
      case GetLoadingState():
        return const Center(child: CircularProgressIndicator());
      case GetSuccessState(:final assets):
        if (assets.isEmpty) {
          return const Center(child: Text('No assets found. Add some!'));
        }

        return ListView.builder(
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final Asset asset = assets[index];
            final baseStyle = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
            final textStyle = _formattingHandler.apply(asset, baseStyle);
            final iconData = _formattingHandler.handleIcon(asset.type);

            return ListTile(
              leading: Icon(iconData),
              title: Text(asset.name, style: textStyle),
              subtitle: Text('Value: \$${asset.value}', style: textStyle),
              trailing: IconButton(
                onPressed: () => showDeleteModal(asset, notifier),
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
        );
      case GetErrorState(:final message):
        return Center(child: Text(message));
    }
  }

  void showDeleteModal(Asset asset, GetAssetListNotifier notifier) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('¿Desea eliminar el activo ${asset.name}?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await notifier.deleteAsset(asset.id);
              },
              child: const Text('SÍ'),
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

  @override
  void initState() {
    _formattingHandler = HighValueFormattingHandler(
      nextHandler: LowValueFormattingHandler(),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetAssetListNotifier>(
        context,
        listen: false,
      ).getAssetList();
    });
    super.didChangeDependencies();
  }
}