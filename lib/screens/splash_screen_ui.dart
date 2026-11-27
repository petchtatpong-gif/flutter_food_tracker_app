import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // ไปยังหน้า Home หลังจากรอ 3 วินาที
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD35400), // สีส้มเข้ม/น้ำตาลแดง
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 20),
            Text(
              'Food Tracker',
              style: GoogleFonts.kanit(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fastfood, color: Colors.white70),
                const SizedBox(width: 8),
                const Icon(Icons.icecream, color: Colors.white70),
                const SizedBox(width: 8),
                const Icon(Icons.local_dining, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Created by tatpong',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}