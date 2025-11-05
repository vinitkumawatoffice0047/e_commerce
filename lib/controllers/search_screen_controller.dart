import 'package:e_commerce_app/utils/ConsoleLog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../api/api_provider.dart';
import '../api/web_api_constant.dart';
import '../models/SearchProductApiResponseModel.dart';
import '../utils/app_shared_preferences.dart';

class SearchScreenController extends GetxController{
  Rx<TextEditingController> titleCtrl =TextEditingController().obs;

  String? userAccessToken;

  RxList<SearchData> searchList = <SearchData>[].obs; // RxList to store a list of Data objects

  Future<void> getToken(BuildContext context,) async {
    await AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
      userAccessToken = value;
    });
  }


  Future<void> searchProductApi(BuildContext context, String title) async{
    await AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
      userAccessToken = value;
    });

    Map<String, dynamic> dict = {
      "title":title,
    };
    try {
      ConsoleLog.printColor("UserToken...$userAccessToken...", color: "yellow");
      var response = await ApiProvider().searchProductApi(
          context, WebApiConstant.API_URL_SEARCH_PRODUCT, dict, ""!);

      ConsoleLog.printColor("Response.....${response}", color: "green");
      if (response != null) {
        if (response.error != true && response.errorCode == 0)
        {
          searchList.value = response.data != null ? [response.data!] : []; // Store as List
          Fluttertoast.showToast(msg: response.message ?? "");
          // Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: response.message ?? "");
        }

      }
    } catch (_) {
      ConsoleLog.printError("Exception...$_...");
      Fluttertoast.showToast(msg: WebApiConstant.ApiError);
    }
  }

}