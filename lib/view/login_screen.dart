import 'package:e_commerce_app/controllers/login_controller.dart';
import 'package:e_commerce_app/utils/global_utils.dart';
import 'package:e_commerce_app/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/text_validation.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(()=> Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: GlobalUtils.getScreenHeight(),
              width: GlobalUtils.getScreenWidth(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: GlobalUtils.getBackgroundColor()
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: GlobalUtils.screenHeight * 0.1,),

                  GlobalUtils.CustomGradientText(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    "Login",
                    style: GoogleFonts.sail(
                      fontSize: GlobalUtils.screenWidth * 0.15,
                      color: GlobalUtils.titleColor,
                    ),
                  ),

                  SizedBox(height: GlobalUtils.screenHeight * 0.1,),

                  GlobalUtils.CustomTextField(
                    label: "Email",
                    showLabel: false,
                    controller: loginController.emailController.value.obs(),
                    prefixIcon: Icon(Icons.email),
                    isEmail: true,
                    placeholder: "Please enter your email.",
                    placeholderColor: Colors.white,
                    height: GlobalUtils.screenHeight * 0.06,
                    width: GlobalUtils.screenWidth*0.9,
                    autoValidate: false,
                    backgroundGradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.purple.shade300],
                    ),
                    errorColor:  Colors.red,
                    errorFontSize: 12
                  ),

                  SizedBox(height: 20,),

                  GlobalUtils.CustomTextField(
                      label: "Password",
                      showLabel: false,
                      controller: loginController.passwordController.value.obs(),
                      prefixIcon: Icon(Icons.password),
                      isPassword: true,
                      placeholder: "Please enter your password.",
                      placeholderColor: Colors.white,
                      height: GlobalUtils.screenHeight * 0.06,
                      width: GlobalUtils.screenWidth * 0.9,
                      autoValidate: false,
                      backgroundGradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.purple.shade300],
                      ),
                      errorColor:  Colors.red,
                      errorFontSize: 12,
                  ),

                  SizedBox(
                    height: GlobalUtils.screenWidth * 0.2,
                  ),

                  GlobalUtils.CustomButton(
                    text: "Login",
                    onPressed: (){
                      // loginController.isValidUserID.value = TxtValidation.normalTextField(loginController.emailController.value);
                      // loginController.isValidPassword.value = TxtValidation.normalTextField(loginController.passwordController.value);
                      if(loginController.isValidUserID.value && loginController.isValidPassword.value){
                        loginController.loginApi(context);
                      }
                      // Get.offAll(MainScreen());//
                    },
                    width: GlobalUtils.screenWidth * 0.9,
                    backgroundGradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    textColor: Colors.white,
                    animation: ButtonAnimation.fade,
                    animationDuration: const Duration(milliseconds: 150),
                    buttonType: ButtonType.elevated,
                  ),

                  SizedBox(
                    height: GlobalUtils.screenWidth * 0.05,
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: TextStyle(color: Colors.black)),
                      GlobalUtils.CustomButton(onPressed: (){Get.offAll(SignupScreen());}, buttonType: ButtonType.text, text: "Signup", padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), textGradient: LinearGradient(colors: [Colors.purple, Colors.pink, Colors.orange],))
                    ],
                  )
                ],
              ),
            )
          ],
        ),),
      ),
    );
  }
}
