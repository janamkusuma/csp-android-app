import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/track_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/awareness_feed_screen.dart';
import 'screens/bag_swap_screen.dart';
import 'screens/events_screen.dart';
import 'screens/nearby_stores_screen.dart';
import 'screens/proof_gallery_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PlasticAwarenessApp());
}

class PlasticAwarenessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plastic Awareness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF9FF5C6),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/home': (_) => HomeScreen(),
        '/track': (_) => TrackScreen(),
        '/profile': (_) => ProfileScreen(),
        '/awareness': (_) => AwarenessFeedScreen(),
        '/bag swap': (_) => BagSwapScreen(),
        '/events': (_) => EventsScreen(),
        '/stores': (_) => NearbyStoresScreen(),
        '/proofs': (_) => const ProofGalleryScreen(),
      },
    );
  }
}