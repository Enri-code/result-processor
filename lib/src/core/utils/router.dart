import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:unn_grading/src/features/edit_result/presentation/pages/pluto_grid_grading_page.dart';

class RoutePath {
  final String path;
  final String? name;

  const RoutePath(this.path, {this.name});
}


class _MyRouter extends GoRouter {
  _MyRouter._({
    required List<RouteBase> routes,
    super.initialLocation,
  }) : super.routingConfig(
          routingConfig: ValueNotifier(RoutingConfig(routes: routes)),
        );

  RoutePath? routeOf(Type type) => _routeOf[type];
  String? pathOf(Type type) => routeOf(type)?.path;
}

const _routeOf = {
  PlutoGridGradingPage: RoutePath('/grading', name: 'Grading'),
};

final appRouter = _MyRouter._(
  initialLocation: _routeOf[PlutoGridGradingPage]!.path,
  routes: [
    GoRoute(
      path: _routeOf[PlutoGridGradingPage]!.path,
      name: _routeOf[PlutoGridGradingPage]!.name,
      builder: (context, state) => const PlutoGridGradingPage(),
    ),
  ],
);
