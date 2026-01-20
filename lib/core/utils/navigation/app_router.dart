import 'package:flutter/material.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import 'package:propertybooking/features/auth/presentation/views/login_view.dart';
import 'package:propertybooking/features/shared/splash/views/splash_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as dynamic;
    switch (settings.name) {
      case RouterPath.splashView:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashView();
          },
        );
      case RouterPath.loginView:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginView();
          },
        );
    }
    return null;
  }

  Route _bottomToTopTransition(Widget page, {required String routeName}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
