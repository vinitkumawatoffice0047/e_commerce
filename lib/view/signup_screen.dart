import 'package:e_commerce_app/utils/global_utils.dart';
import 'package:e_commerce_app/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/web_api_constant.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupController signupController = Get.put(SignupController());

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
                    "Signup",
                    style: GoogleFonts.sail(
                      fontSize: GlobalUtils.screenWidth * 0.15,
                      color: GlobalUtils.titleColor,
                    ),
                  ),

                  SizedBox(height: GlobalUtils.screenHeight * 0.1,),

                  GlobalUtils.CustomTextField(
                      label: "Name",
                      showLabel: false,
                      controller: signupController.nameController.value.obs(),
                      prefixIcon: Icon(Icons.person),
                      isName: true,
                      placeholder: "Please enter your name.",
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
                      label: "Email",
                      showLabel: false,
                      controller: signupController.emailController.value.obs(),
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
                      label: "Mobile Number",
                      showLabel: false,
                      controller: signupController.mobileController.value.obs(),
                      prefixIcon: Icon(Icons.call),
                      isMobileNumber: true,
                      placeholder: "Please enter your mobile number.",
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
                    controller: signupController.passwordController.value.obs(),
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
                    text: "Register",
                    onPressed: (){
                      if(signupController.isValidName.value && signupController.isValidEmail.value && signupController.isMobileNo.value && signupController.isPassword.value){
                        if(signupController.isChecked.value) {
                          print("log12sdf");
                          signupController.registerUser(context);
                        }else{
                          Fluttertoast.showToast(msg: WebApiConstant.TermsConditionError);
                        }
                      }
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
                      Text("Already have an account?", style: TextStyle(color: Colors.black)),
                      GlobalUtils.CustomButton(onPressed: (){Get.offAll(LoginScreen());}, buttonType: ButtonType.text, text: "Signin", padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), textGradient: LinearGradient(colors: [Colors.purple, Colors.pink, Colors.orange],))
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
