import 'package:go_router/go_router.dart';
import 'package:maida_test/entry_point.dart';
import 'package:maida_test/main.dart';


final GoRouter routerConfig = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),


  ],
);

