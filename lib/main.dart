import 'package:filmpal/firebase_options.dart';
import 'package:filmpal/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'controllers/dependency_injection.dart';
import 'pages/splash_page.dart';

// Main function to start the Flutter application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the SplashPage widget to initialize the app
  runApp(
    SplashPage(
      key: UniqueKey(),
      // Callback function to run the main app after initialization
      onInitializationComplete: () => runApp(
        ProviderScope(
          child: MyApp(),
        ),
      ),
    ),
  );
  // Initialize dependency injection
  DependencyInjection.init();
}

// MyApp class, the main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FilmPal',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext _context) =>
            AuthPage(), // AuthPage as the home page
      },
      // Define the app theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
