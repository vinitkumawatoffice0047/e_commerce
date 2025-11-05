import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_provider.dart';
import '../api/web_api_constant.dart';
import '../utils/app_shared_preferences.dart';
import '../view/login_screen.dart';

class SignupController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController(text: "").obs;
  Rx<TextEditingController> lnameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController(text: "").obs;
  Rx<TextEditingController> mobileController = TextEditingController(text: "").obs;
  Rx<TextEditingController> passwordController = TextEditingController(text: "").obs;
  Rx<TextEditingController> tPinCtrl = TextEditingController().obs;
  Rx<TextEditingController> referralCtrl = TextEditingController().obs;
  RxBool isChecked = true.obs;
  RxBool isValidName = true.obs;
  RxBool isValidEmail = true.obs;
  RxBool isMobileNo = true.obs;
  RxBool isPassword = true.obs;

  Future<void> registerUser(BuildContext context) async{
    try {
      Map<String, dynamic> dict = {
        "user_name": nameController.value.text.toString().trim(),
        "email": emailController.value.text.toString().trim(),
        "phone": mobileController.value.text.toString().trim(),
        "sponsor_id": referralCtrl.value.text.toString().trim(),
        "password": passwordController.value.text.toString().trim(),
      };
      print(dict);

      var response = await ApiProvider().signupApi(
          context, WebApiConstant.API_URL_SIGNUP, dict, "");
      print("${response}.......");
      if (response != null) {
        if (response['error'] != true) {
          Fluttertoast.showToast(msg: response["message"] ?? "");
          await SharedPreferences.getInstance().then((value) {
            value.setString(AppSharedPreferences.mobileNo, mobileController.value.text.toString().trim());
          });
          Get.offAll(LoginScreen());
        } else {
          Fluttertoast.showToast(msg: response["message"] ?? "");
        }
      }
    }catch(_){
      print("Exception...");
      Fluttertoast.showToast(msg: WebApiConstant.ApiError);
    }
  }
}
