import 'package:e_commerce_app/utils/global_utils.dart';
import 'package:e_commerce_app/view/login_screen.dart';
import 'package:e_commerce_app/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_shared_preferences.dart';
import '../utils/comming_soon_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool isLogin = false;
  bool isSecurityEnabled = false;
  bool isIntro = false;
  String userType = "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    init();
    // getToken(context);
    Future.delayed(Duration(seconds: 3), () {
      if(isLogin) {
        Get.offAll(() => MainScreen(selectedIndex: 0), transition: Transition.fadeIn);
      } else {
        Get.offAll(LoginScreen(), transition: Transition.fadeIn);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await SharedPreferences.getInstance().then((value) {
      isLogin = value.getBool(AppSharedPreferences.isLogin) ?? false;
      isIntro = value.getBool(AppSharedPreferences.isIntro) ?? false;
      userType = value.getString(AppSharedPreferences.usertype) ?? "";
      print(".............isLogin: ${isLogin}");
      print(".............isIntro: ${isIntro}");
      print(".............userType: ${userType}");
    });
  }

  Future<void> getToken(BuildContext context) async {
    try {
      // getAPI();
    }catch(Ex){
      print(Ex);
    }
  }
  void showPopUp(context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: uploadBox(context),
          ),
        );
      },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GlobalUtils.getBackgroundColor(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          size: 80,
                          color: Color(0xff80a8ff),
                        ),
                      ),
                      SizedBox(height: 30),
                      GlobalUtils.CustomGradientText(
                        'QuickMart',
                        gradient: LinearGradient(
                          colors: [Color(0xff80a8ff), Color(0xffffabab)],
                        ),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Delivered in 10 minutes',
                        style: TextStyle(
                          color: GlobalUtils.titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}