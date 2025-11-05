import 'package:e_commerce_app/utils/ConsoleLog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../api/api_provider.dart';
import '../api/web_api_constant.dart';
import '../utils/app_shared_preferences.dart';

 class AccountScreenController{
   String? userAccessToken;
   RxMap<String, dynamic> profile_List = RxMap<String, dynamic>({});

   Future<void> getProfile(BuildContext context,) async{
     try {
       ConsoleLog.printColor("UserToken...$userAccessToken...", color: "yellow");
       var response = await ApiProvider().getProfile(
           context,userAccessToken!);

       ConsoleLog.printColor("Response.....${response}", color: "green");
       if (response != null) {
         if (response['error'] != true && response['errorCode'] == 0) {
           if (response['data']!= null) {
             var profileData = response['data'];
             profile_List['id'] = profileData['id'];
             profile_List['user_name'] = profileData['user_name'];
             profile_List['phone'] = profileData['phone'];
             profile_List['email'] = profileData['email'];
           }

         } else {
           Fluttertoast.showToast(msg: response['message'] ?? "");
         }
         // product_id.value=response.data?.id! ??0 ;
         // title.value=response.data?.title! ??"" ;
         // price.value= response.data?.price!.toString() ??"" ;
         // disc_price.value=response.data?.discPrice!.toString() ?? "" ;
         // description.value=response.data?.discription! ?? "" ;
       }
     } catch (_) {
       ConsoleLog.printError("Exception...$_...");
       Fluttertoast.showToast(msg: WebApiConstant.ApiError);
     }
   }

   Future<void> getToken(BuildContext context,) async {
     // await AppSharedPreferences().getUserDetails1().then((value){
     //   PrintLog.printLog("asdfsf:- $value");
     //   // userName.value = value.name ??"";
     // });
     await AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
       userAccessToken = value;
       getProfile(context);
     });
   }
 }