import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

// Import Pages
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/checkout_page.dart';
import 'pages/home/news_page.dart'; 
import 'pages/ticket/my_tickets_page.dart';
import 'pages/home/success_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const EvoraApp());
}

class EvoraApp extends StatelessWidget {
  const EvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EVORA',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        primaryColor: const Color(0xFFE53170),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE53170),
          // PERBAIKAN: Gunakan .withValues untuk menghindari warning di Web
          secondary: const Color(0xFFE53170).withValues(alpha: 0.8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0E17),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // PERBAIKAN: Penanganan navigasi dinamis untuk Checkout dan Success
        if (settings.name == '/checkout') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CheckoutPage(data: args),
          );
        }
        
        // REVISI: Tambahkan route Success di sini agar bisa menerima data (Argumen)
        if (settings.name == '/success') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => SuccessPage(data: args),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(), 
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/news': (context) => const NewsPage(), 
        '/my-tickets': (context) => const MyTicketsPage(),
        // HAPUS '/success' dari sini karena sudah dipindah ke onGenerateRoute
      },
    );
  }
}