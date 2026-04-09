import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

class Routes {
  static GoRouter get router => GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const GetAssetListPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'create',
            builder: (BuildContext context, GoRouterState state) {
              return const CreateAssetPage();
            },
          ),
        ],
      ),
    ],
  );
}