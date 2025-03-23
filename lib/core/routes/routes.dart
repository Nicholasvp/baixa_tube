import 'package:baixa_tube/ui/views/home/home_page.dart';
import 'package:baixa_tube/ui/views/library/library_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: Paths.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Paths.library,
      builder: (context, state) => const LibraryPage(),
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
