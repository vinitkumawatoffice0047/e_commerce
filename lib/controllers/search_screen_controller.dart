import 'dart:async';
import 'package:e_commerce_app/api/web_api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_provider.dart';
import '../models/ProductApiResponseModel.dart';
import '../models/ProductDetailsApiResponseModel.dart';
import '../models/product_model.dart';
import '../utils/ConsoleLog.dart';
import '../utils/app_shared_preferences.dart';

class SearchScreenController extends GetxController {
  // Text Controller
  // Rx<TextEditingController> searchTxtController = TextEditingController().obs;
  final TextEditingController searchTxtController = TextEditingController();

  // Search Results
  final RxList<ProductItem> searchResults = <ProductItem>[].obs;
  final RxList<ProductItem> allSearchResults = <ProductItem>[].obs;

  // Loading & Error States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final int itemsPerPage = 20; // Show only 20 items at a time
  final RxBool hasMoreItems = true.obs;

  // Debouncing
  Timer? _debounceTimer;
  final int debounceDuration = 800; // 800ms delay

  String? userAccessToken;
  String lastSearchQuery = '';

  //   Future<void> getToken(BuildContext context,) async {
  //   await AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
  //     userAccessToken = value;
  //   });
  // }

  @override
  void onClose() {
    searchTxtController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // ✅ Debounced Search - Use this for onChanged
  void onSearchChanged(BuildContext context, String searchText) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    searchText = searchText.trim();

    if (searchText.isEmpty) {
      clearSearch();
      return;
    }

    // Start new timer
    _debounceTimer = Timer(Duration(milliseconds: debounceDuration), () {
      searchProductApi(context, searchText);
    });
  }

  // ✅ Instant Search - Use this for onSubmitted
  void onSearchSubmitted(BuildContext context, String searchText) {
    _debounceTimer?.cancel(); // Cancel any pending debounce
    searchText = searchText.trim();

    if (searchText.isEmpty) {
      clearSearch();
      return;
    }

    searchProductApi(context, searchText);
  }


  // Search Product API Call
  Future<void> searchProductApi(BuildContext context, String searchText) async {
    // Prevent duplicate searches
    if (lastSearchQuery == searchText && allSearchResults.isNotEmpty) {
      return;
    }

    lastSearchQuery = searchText;
    isLoading.value = true;
    errorMessage.value = '';
    currentPage.value = 1;
    hasMoreItems.value = true;


    // if (searchText.trim().isEmpty) {
    //   searchResults.clear();
    //   return;
    // }
    Map<String, dynamic> dict = {
      "title":searchText,
    };

    try {

      ConsoleLog.printColor("Searching for: $searchText");

      if (userAccessToken == null || userAccessToken!.isEmpty) {
      await AppSharedPreferences().getString(AppSharedPreferences.token).then((value){
        userAccessToken = value;
      });}

      // Example API call structure:
      var response = await ApiProvider().searchProductApi(context, WebApiConstant.API_URL_SEARCH_PRODUCT, dict, userAccessToken ?? "");
      if (response != null) {
      if (response.error != true && response.errorCode == 0){
        // // Convert API response to ProductItem list
        // searchResults.value = response.data
        //     ?.map((item) => ProductItem(
        //           productId: item.productId.toString(),
        //           title: item.title ?? '',
        //           discription: item.description ?? '',
        //           image: item.image ?? '',
        //           images: [],
        //           price: item.price ?? 0,
        //           sellPrice: item.discPrice ?? 0,
        //           qty: 1,
        //         ))
        //     .toList() ?? [];

        // Convert all items
        allSearchResults.value = response.data
            ?.map((item) {
          try {
            return ProductItem(
              productId: item.productId?.toString() ?? '',
              title: item.title ?? '',
              discription: item.description?.toString() ?? '',
              // image: item.image ?? '',
              images: item.image != null ? [item.image!] : [],
              price: item.price ?? 0,
              image: item.image ?? '',
              qty: 1,
              sellPrice: item.discPrice
              // discPrice: item.discPrice ?? 0,
              // slug: item.slug ?? '',
              // qty: 1,
            );
          } catch (e) {
            ConsoleLog.printError("Error converting item: $e");
            return null;
          }
        })
            .where((item) => item != null)
            .cast<ProductItem>()
            .toList() ?? [];

        // Load first page
        loadPage(1);

        ConsoleLog.printSuccess(
            "✅ Total results: ${allSearchResults.length}, Showing: ${searchResults.length}"
        );
      } else {
        errorMessage.value = response?.message ?? 'Search failed';
        searchResults.clear();
        allSearchResults.clear();
        ConsoleLog.printError("❌ Search failed: ${response?.message}");
      }
      }else {
        // errorMessage.value = 'Item Not Found!';
        searchResults.clear();
        allSearchResults.clear();
        ConsoleLog.printError("❌ No response from server");
      }
      ConsoleLog.printColor("Search results: ${searchResults.length} items found");

    } catch (e) {
      ConsoleLog.printError("❌ Search error: $e");
      errorMessage.value = 'An error occurred while searching';
      searchResults.clear();
      allSearchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Load specific page
  void loadPage(int page) {
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= allSearchResults.length) {
      hasMoreItems.value = false;
      return;
    }

    final pageItems = allSearchResults.sublist(
        startIndex,
        endIndex > allSearchResults.length ? allSearchResults.length : endIndex
    );

    if (page == 1) {
      searchResults.value = pageItems;
    } else {
      searchResults.addAll(pageItems);
    }

    hasMoreItems.value = endIndex < allSearchResults.length;
  }

  // ✅ Load More Items (for infinite scroll)
  void loadMoreItems() {
    if (isLoadingMore.value || !hasMoreItems.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    // Simulate slight delay for smooth UX
    Future.delayed(Duration(milliseconds: 300), () {
      loadPage(currentPage.value);
      isLoadingMore.value = false;
    });
  }

  // ✅ Clear Search
  void clearSearch() {
    searchTxtController.clear();
    searchResults.clear();
    allSearchResults.clear();
    errorMessage.value = '';
    lastSearchQuery = '';
    currentPage.value = 1;
    hasMoreItems.value = true;
    _debounceTimer?.cancel();
  }

  // ✅ Refresh Search
  Future<void> refreshSearch(BuildContext context) async {
    if (lastSearchQuery.isNotEmpty) {
      await searchProductApi(context, lastSearchQuery);
    }
  }

  // Clear search results
  // void clearSearch() {
  //   searchTxtController.value.clear();
  //   searchResults.clear();
  //   errorMessage.value = '';
  // }
}

// =====================================================
// ACTUAL API INTEGRATION EXAMPLE
// =====================================================
/*
// Step 1: Create SearchResponseApi model (if not exists)
class SearchResponseApi {
  final bool? error;
  final String? message;
  final List<SearchProductData>? data;

  SearchResponseApi({
    this.error,
    this.message,
    this.data,
  });

  factory SearchResponseApi.fromJson(Map<String, dynamic> json) {
    return SearchResponseApi(
      error: json['error'],
      message: json['message'],
      data: json['data'] != null
          ? List<SearchProductData>.from(
              json['data'].map((x) => SearchProductData.fromJson(x)))
          : null,
    );
  }
}

class SearchProductData {
  final int? product_id;
  final String? title;
  final String? description;
  final String? image;
  final List<String>? images;
  final dynamic price;
  final dynamic discPrice;
  final int? stock;

  SearchProductData({
    this.product_id,
    this.title,
    this.description,
    this.image,
    this.images,
    this.price,
    this.discPrice,
    this.stock,
  });

  factory SearchProductData.fromJson(Map<String, dynamic> json) {
    return SearchProductData(
      product_id: json['product_id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      price: json['price'],
      discPrice: json['disc_price'],
      stock: json['stock'],
    );
  }
}

// Step 2: Add API method in ApiProvider
Future<SearchResponseApi?> searchProduct(
  BuildContext context,
  String searchText,
) async {
  try {
    final response = await dio.post(
      'YOUR_API_ENDPOINT/search',
      data: {
        'title': searchText,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return SearchResponseApi.fromJson(response.data);
    }
  } catch (e) {
    print('API Error: $e');
  }
  return null;
}

// Step 3: Use in Controller
Future<void> searchProductApi(BuildContext context, String searchText) async {
  try {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await ApiProvider().searchProduct(context, searchText);

    if (response != null && response.error == false) {
      searchResults.value = response.data
          ?.map((item) => ProductItem(
                productId: item.product_id.toString(),
                title: item.title ?? '',
                discription: item.description ?? '',
                image: item.image ?? '',
                images: item.images ?? [],
                price: item.price ?? 0,
                sellPrice: item.discPrice ?? 0,
                qty: 1,
              ))
          .toList() ?? [];
    } else {
      errorMessage.value = response?.message ?? 'Search failed';
      searchResults.clear();
    }
  } catch (e) {
    errorMessage.value = 'An error occurred';
    searchResults.clear();
  } finally {
    isLoading.value = false;
  }
}
*/