import 'package:baixa_tube/ui/views/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: Paths.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);

class Routes {
  static const home = Paths.home;
  static const library = Paths.library;
}

class Paths {
  static const home = '/';
  static const library = '/library';
}
