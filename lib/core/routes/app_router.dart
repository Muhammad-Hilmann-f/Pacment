import 'package:flutter/material.dart';
import '../../views/onboarding/onboarding_screen.dart';
// import '../../views/auth/login_screen.dart';
// import '../../views/dashboard/dashboard_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      // case AppRoutes.login:
      //   return MaterialPageRoute(builder: (_) => const LoginScreen());
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(builder: (_) => const DashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
