import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../api/api_provider.dart';
import '../api/web_api_constant.dart';
import '../models/ProductDetailsApiResponseModel.dart';
import '../utils/ConsoleLog.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/connection_validator.dart';

class ProductDetailController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // var productDetail = Rxn<ProductDetailsData>();
  var productDetail = Rxn<ProductDetailsResponseData>();
  String? userAccessToken;
  RxString? title = "".obs;
  RxInt? product_id = 0.obs;
  RxString? description = "".obs;
  RxString? price = "".obs;
  RxString? disc_price = "".obs;
  RxInt? stock = 0.obs;
  RxList<String> banner = <String>[].obs;
  RxList<String> images = <String>[].obs;


  void onInit() {
    super.onInit();
    AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
      userAccessToken = value;

    });
  }


  Future<void> getProductDetails(BuildContext context, String slug) async{
    Map<String, dynamic> dict = {
      "slug":slug,
    };
    try {
      ConsoleLog.printColor("UserToken...$userAccessToken...", color: "yellow");
      var response = await ApiProvider().productDetailsAPI(
          context, WebApiConstant.API_URL_HOME_PRODUCT_DETAILS, dict, "");

      ConsoleLog.printColor("Response.....$response", color: "green");
      if (response != null) {
        if (response.error != true && response.errorCode == 0) {
          if (response.data?.images != null) {
            banner.value = response.data?.images ?? [];
          }

        } else {
          Fluttertoast.showToast(msg: response.message ?? "");
        }
        productDetail.value = response.data;
        product_id!.value=response.data?.id! ??0 ;
        title!.value=response.data?.title! ??"" ;
        price!.value= response.data?.price!.toString() ??"" ;
        disc_price!.value=response.data?.discPrice!.toString() ?? "" ;
        description!.value=response.data?.discription! ?? "" ;
        stock!.value=response.data?.stock??0;
        images.value=response.data?.images??[];
      }
    } catch (e) {
      ConsoleLog.printError("Exception...$e...");
      Fluttertoast.showToast(msg: WebApiConstant.ApiError);
    }
  }

  // Future<void> getProductDetails(BuildContext context, String slug) async {
  //   Map<String, dynamic> dict = {
  //     "slug":slug,
  //   };
  //   try {
  //     ConsoleLog.printColor("UserToken...$userAccessToken...", color: "yellow");
  //     var response = await ApiProvider().prodectDetails(
  //         context, WebApiConstant.API_URL_HOME_PRODUCT_DETAILS, dict, ""!);
  //
  //     PrintLog.printLog("Response.....${response}");
  //     if (response != null) {
  //       if (response.error != true && response.errorCode == 0) {
  //         if (response.data?.images != null) {
  //           banner.value = response.data?.images ?? [];
  //         }
  //
  //       } else {
  //         Fluttertoast.showToast(msg: response.message ?? "");
  //       }
  //       product_id.value=response.data?.product_id! ??0 ;
  //       title.value=response.data?.title! ??"" ;
  //       price.value= response.data?.price!.toString() ??"" ;
  //       disc_price.value=response.data?.discPrice!.toString() ?? "" ;
  //       stock.value=response.data?.stock??0;
  //       description.value=response.data?.discription! ?? "" ;
  //     }
  //   } catch (_) {
  //     PrintLog.printLog("Exception...$_...");
  //     Fluttertoast.showToast(msg: WebApiConstant.ApiError);
  //   }
  //   // try {
  //   //   isLoading.value = true;
  //   //   errorMessage.value = '';
  //   //
  //   //   // Check internet connection
  //   //   if (!await ConnectionValidator.checkInternet()) {
  //   //     errorMessage.value = 'No internet connection';
  //   //     isLoading.value = false;
  //   //     return;
  //   //   }
  //   //
  //   //   // Get token from SharedPreferences
  //   //   String? token = await AppSharedPreferences().getString(AppSharedPreferences.token);
  //   //
  //   //   if (token == null || token.isEmpty) {
  //   //     errorMessage.value = 'Please login first';
  //   //     isLoading.value = false;
  //   //     return;
  //   //   }
  //   //
  //   //   ConsoleLog.printColor("Fetching product details for ID: $productId");
  //   //
  //   //   // API call
  //   //   var response = await ApiProvider().getData(
  //   //     WebApiConstant.productDetailApi + productId,
  //   //     token,
  //   //   );
  //   //
  //   //   ConsoleLog.printColor("Product Detail Response: $response");
  //   //
  //   //   if (response != null) {
  //   //     var apiResponse = ProductDetailsApiResponseModel.fromJson(response);
  //   //
  //   //     if (apiResponse.status == 200) {
  //   //       productDetail.value = apiResponse.data;
  //   //       ConsoleLog.printColor("Product details loaded successfully");
  //   //     } else {
  //   //       errorMessage.value = apiResponse.msg ?? 'Failed to load product details';
  //   //       ConsoleLog.printColor("API Error: ${apiResponse.msg}", ConsoleLog.red);
  //   //     }
  //   //   } else {
  //   //     errorMessage.value = 'Failed to load product details';
  //   //     ConsoleLog.printColor("Response is null", ConsoleLog.red);
  //   //   }
  //   // } catch (e) {
  //   //   errorMessage.value = 'Error: ${e.toString()}';
  //   //   ConsoleLog.printColor("Exception in getProductDetails: $e", ConsoleLog.red);
  //   // } finally {
  //   //   isLoading.value = false;
  //   // }
  // }

  @override
  void onClose() {
    // productDetail.value = null;
    super.onClose();
  }
}
