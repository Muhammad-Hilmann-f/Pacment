import 'package:flutter/material.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/auth/register_page.dart';
import '../../views/auth/login_page.dart';
import '../../views/dashboard/dashboard_screen.dart';
import '../../views/tracking/tracking_result_screen.dart';
import '../../views/analytics/analytics_screen.dart';
import '../../core/models/tracking_models.dart'; 
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case AppRoutes.trackingResult:
        // Pastikan arguments adalah TrackingInfo
        final trackingInfo = settings.arguments as TrackingModel?;
        if (trackingInfo == null) {
          return _errorRoute('Data tracking tidak valid');
        }
        return MaterialPageRoute(
          builder: (_) => TrackingResultScreen(trackingInfo: trackingInfo),
        );
      default:
        return _errorRoute('Route tidak ditemukan');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}