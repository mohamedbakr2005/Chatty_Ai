import 'package:chatty_ai/core/routes/unknown_page.dart';
import 'package:chatty_ai/views/Home/ui/Home_Screen.dart';
import 'package:flutter/cupertino.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;

    switch (route) {
      case AppRoutes.home:
        return CupertinoPageRoute(builder: (_) => const HomeScreen());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
