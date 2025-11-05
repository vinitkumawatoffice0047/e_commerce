import 'package:e_commerce_app/utils/global_utils.dart';
import 'package:e_commerce_app/view/login_screen.dart';
import 'package:e_commerce_app/view/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GlobalUtils with the current context
    GlobalUtils.init(context);

    return GetMaterialApp(
      title: 'E-commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xff80a8ff),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff80a8ff),
        scaffoldBackgroundColor: Color(0xff1a1a1a),
      ),
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}