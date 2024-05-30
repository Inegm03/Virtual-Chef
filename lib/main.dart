import 'package:finallllmobileeeee/firebase_options.dart';
import 'package:finallllmobileeeee/login.dart';
import 'package:finallllmobileeeee/submit.dart';
import 'package:finallllmobileeeee/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:finallllmobileeeee/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'favorites_page.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => welcome(),
            "/home": (context) => HomePage(),
            "/fav": (context) => FavoritesPage(),
            "/signup": (context) => signup(),
            "/login": (context) => login(),
            "/RecipePage": (context) => RecipePage(),
          },
        );
      },
    );
  }
}
