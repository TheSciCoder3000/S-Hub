import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/routes/constants.dart';
import 'package:s_hub/routes/router_notifier.dart';
import 'package:s_hub/screens/auth/register.dart';
import 'package:s_hub/screens/auth/signin.dart';
import 'package:s_hub/screens/splash.dart';
import 'package:s_hub/screens/wrapper.dart';

class MyAppRouter {
  MyAppRouter(this.routerNotifier);
  RouterNotifier routerNotifier;

  late GoRouter router = GoRouter(
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    initialLocation: RoutePath.splash.path,
    routes: [
      GoRoute(
        name: RoutePath.dashboard.name,
        path: RoutePath.dashboard.path,
        builder: (context, state) {
          return const MainWrapper();
        }
      ),
      GoRoute(
        name: RoutePath.register.name,
        path: RoutePath.register.path,
        builder: (context, state) {
          return const RegisterPage();
        }
      ),
      GoRoute(
        name: RoutePath.signin.name,
        path: RoutePath.signin.path,
        builder: (context, state) {
          return const AuthPage();
        }
      ),
      GoRoute(
        name: RoutePath.splash.name,
        path: RoutePath.splash.path,
        builder: (context, state) {
          SUser user = context.watch<SUser>();

          return Splash(uid: user.uid);
        }
      ),
    ],
  );
}

