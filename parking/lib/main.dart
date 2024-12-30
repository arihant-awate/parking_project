import 'package:flutter/material.dart';
import 'package:parking/onboarding.dart';
import 'supabase_client.dart'; // Import the Supabase client initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseClientInstance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        // Primary color of the app
        primaryColor: Color(0xFF2ED0C2),

        // Color scheme with the same color for various UI components
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2ED0C2)),
        useMaterial3: true,

        // Focus color for text fields and other focusable elements
        focusColor: Color(0xFF2ED0C2),

        // Text field focus color
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Color when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Default border color
          ),
        ),
      ),
      home: OnboardingScreen(),
    );
  }
}
