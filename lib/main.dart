import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_leaf/firebase_options.dart';
import 'package:green_leaf/splash_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(
    "pk.eyJ1Ijoic2hvYWlia2hhamEiLCJhIjoiY21nZzl5MmJxMGc5NzJ3cjB2cHN1MW1tOCJ9.r7JBap3LIceAMTirrSsiKw",
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
