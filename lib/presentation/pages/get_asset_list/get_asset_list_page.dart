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
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Consumer<GetAssetListNotifier>(
          builder: (_, notifier, __) {
            return GetAssetListBody(
              notifier: notifier,
              formattingHandler: _formattingHandler,
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () async {
        final created = await context.push<bool>('/create');
        if (created == true && mounted) {
          await Provider.of<GetAssetListNotifier>(
            context,
            listen: false,
          ).getAssetList();
        }
      },
      child: const Icon(
        Icons.add,
        color: AppColors.light,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Asset List',
        style: AppTypography.appBarTitle.copyWith(
          color: AppColors.light,
        ),
      ),
      backgroundColor: AppColors.primary,
    );
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