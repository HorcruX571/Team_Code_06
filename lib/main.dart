import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/booking_page.dart';
import 'screens/select_seat_page.dart';
import 'auth/login_page.dart';
import 'screens/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Supabase.initialize(
    url: 'https://hvcirrkmcmasszqciood.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2Y2lycmttY21hc3N6cWNpb29kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzODIyOTksImV4cCI6MjA0MDk1ODI5OX0.r8sTxJY940mzdZQFAUGK1eVi0qZnPNEs0JZZJa6BKEs',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Scheduling App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      initialRoute: '/', // Set the initial route
      routes: {
        '/user': (context) => const UserPage(),
        '/booking': (context) =>
            BookingPage(busId: '0'), // Provide a default or dynamic busId
        '/select-seat': (context) => SelectSeatPage(
              busId: '', // Provide a default or dynamic busId
              passengerName: '',
              passengerAge: 0,
              source: '',
              destination: '',
              date: '',
            ),
      },
    );
  }
}
