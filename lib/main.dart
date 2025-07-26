import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/names_screen.dart';
import 'pages/expenses_screen.dart';
import 'pages/summary_screen.dart';

void main() {
  runApp(const BillSplitterApp());
}

class BillSplitterApp extends StatelessWidget {
  const BillSplitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.teal,
        secondary: Colors.blueAccent,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal.shade700,
        elevation: 1,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.teal.shade700,
        ),
        iconTheme: IconThemeData(color: Colors.teal.shade700),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(fontSize: 15),
      ),
    );

    return MaterialApp(
      title: 'Bill Splitter',
      theme: baseTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/names',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/names':
            return MaterialPageRoute(builder: (_) => const NamesScreen());
          case '/expenses':
            final names = settings.arguments as List<String>;
            return MaterialPageRoute(
              builder: (_) => ExpensesScreen(names: names),
            );
          case '/summary':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => SummaryScreen(
                names: args['names'],
                expenses: args['expenses'],
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
