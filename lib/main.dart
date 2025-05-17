import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/auth/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style for status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A1929),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  runApp(const PacmentApp());
}

class PacmentApp extends StatelessWidget {
  const PacmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pacment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1947E6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      // home: const RegisterPage(),
    );
  }
}