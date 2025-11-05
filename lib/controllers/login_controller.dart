import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_provider.dart';
import '../api/web_api_constant.dart';
import '../utils/app_shared_preferences.dart';
import '../view/main_screen.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController(text: "").obs;
  Rx<TextEditingController> passwordController = TextEditingController(text: "").obs;
  RxBool isValidUserID = true.obs;
  RxBool isValidPassword = true.obs;

  void init() async{
    await SharedPreferences.getInstance().then((value) {
      value.setBool(AppSharedPreferences.isIntro, true);
    });
  }

  Future<void> loginApi(BuildContext context) async{
    try {
      Map<String, dynamic> dict = {
        "login": emailController.value.text.toString().trim(),
        "password": passwordController.value.text.toString().trim(),
      };

      var response = await ApiProvider().loginApi(
          context, WebApiConstant.API_URL_LOGIN, dict, "");

      if (response != null) {
        if (!response['error'] && response['errorCode'] == 0) {
          await SharedPreferences.getInstance().then((value) {
            value.setBool(AppSharedPreferences.isLogin, true);
            value.setString(AppSharedPreferences.token, response['data']['token']);
            value.setString(AppSharedPreferences.userID, response['data']['user_id']);
            value.setString(AppSharedPreferences.mobileNo, response['data']['phone'].toString());
            value.setString(AppSharedPreferences.userName, response['data']['name'].toString());
          });
          Fluttertoast.showToast(msg: response["message"] ?? "");
          Get.offAll(MainScreen());
        } else{
          Fluttertoast.showToast(msg: response["message"] ?? "");
        }
      }
    }catch(_){
      print("Exception...");
      Fluttertoast.showToast(msg: WebApiConstant.ApiError);
    }
  }
}
