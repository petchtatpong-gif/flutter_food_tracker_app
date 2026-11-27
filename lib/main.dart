import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_food_tracker_app/core/supabase_config.dart';
import 'package:flutter_food_tracker_app/screens/splash_screen_ui.dart';
import 'package:flutter_food_tracker_app/screens/home_screen_ui.dart';
import 'package:flutter_food_tracker_app/screens/add_food_ui.dart';
import 'package:flutter_food_tracker_app/screens/food_detail_ui.dart';
import 'package:flutter_food_tracker_app/screens/edit_food_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B4513)),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomeScreenUi(),
      },
      home: const SplashScreenUi(),
    );
  }
}
