import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Ensure this is in pubspec.yaml
import 'screens/schemes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file in root
  await dotenv.load(fileName: ".env");

  // Initialize Supabase using class reference, not a local variable
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '', 
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00E676),
        scaffoldBackgroundColor: const Color(0xFF121417),
      ),
      home: const SchemesScreen(),
    );
  }
}