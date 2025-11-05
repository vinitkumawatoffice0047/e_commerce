import 'package:e_commerce_app/utils/ConsoleLog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../api/api_provider.dart';
import '../api/web_api_constant.dart';
import '../models/ProductApiResponseModel.dart';
// import '../models/ProductResponseApi.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/comming_soon_dialog.dart';

// import '../../../DataProvider/api_provider.dart';
// import '../../../DataProvider/app_shared_preferences.dart';
// import '../../../DataProvider/web_api_constant.dart';
// import '../../../Util/CustomDialog/comming_soon_dialog.dart';
// import '../../../Util/Print/print_log.dart';
// import '../../Model/ProductModel/ProductResponseApi.dart';

class ProductScreenController extends GetxController{

  var pageIndex = 0.obs;

  String? userAccessToken;
  // RxString walletAmount = "0.00".obs;
  // RxString pointAmount = "0.00".obs;
  // RxString incomeWallet = "0.00".obs;
  // RxString todayIncome = "0.00".obs;
  // RxDouble total_balance = 0.0.obs;

  // RxBool kycStatus = true.obs;
  RxString userName = "".obs;
  // RxInt cartIteam = 0.obs;
  RxList<Product> product = <Product>[].obs;
  RxBool isloading = true.obs;


  Future<void> productApi(BuildContext context,int cat_id) async {
    Map<String, dynamic> dict = {
      "cat_id":cat_id,
    };
    try {
      ConsoleLog.printColor("UserToken...$userAccessToken...", color: "yellow");
      var response = await ApiProvider().categoryToProductApi(
          context,dict,userAccessToken!);
      ConsoleLog.printColor("Response.....$response", color: "green");
      if (response != null) {
        if (response.error != true && response.errorCode == 0) {
          if (response.data != null) {
            product.value = response.data ?? [];
            if(product.value!.isEmpty){
              isloading.value=false;
            }
            // cartIteam.value = response.cart_item!;
           }else{
            isloading.value=false;
          }
          // if (response.data?.category != null) {
          //   category.value=response.data?.category ??[];
          // }
          // if (response.data?.topSelling != null) {
          //   topSellProduct.value=response.data?.topSelling ??[];
          // }
          // if (response.data?.maleWellness != null) {
          //   maleWellnessProduct.value=response.data?.maleWellness ??[];
          // }
          // if (response.data?.femaleWellness != null) {
          //   femaleWellness.value=response.data?.femaleWellness ??[];
          // }
        } else {
          Fluttertoast.showToast(msg: response.message ?? "");
        }
      }
    } catch (_) {
      ConsoleLog.printError("Exception...$_...");
      Fluttertoast.showToast(msg: WebApiConstant.ApiError);
    }
  }

  Future<void> getToken(BuildContext context, int cat_id) async {
    // await AppSharedPreferences().getUserDetails1().then((value){
    //   PrintLog.printLog("asdfsf:- $value");
    //   // userName.value = value.name ??"";
    // });
    await AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
      userAccessToken = value;
      productApi(context, cat_id);
    });
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
}
