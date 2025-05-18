
import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pacment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Apply Poppins font to the entire app
        fontFamily: 'Poppins',
        // You can also customize the color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Change to your brand color
        ),
      ),
      initialRoute: AppRoutes.onboarding,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}