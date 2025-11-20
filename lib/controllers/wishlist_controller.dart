import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/ConsoleLog.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/custom_loading.dart';
import '../utils/reusable_product_grid.dart';
import 'cart_controller.dart';

class WishlistController extends GetxController {
  // Observable list of wishlist product IDs
  var wishlistItems = <dynamic>[].obs;
  var isLoading = false.obs;
  final CartController cartController = Get.put(CartController());

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  // Load wishlist from SharedPreferences
  Future<void> loadWishlist() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? wishlistJson = prefs.getString('wishlist');

      if (wishlistJson != null && wishlistJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(wishlistJson);
        wishlistItems.value = decoded.cast<String>();
        isLoading.value = false;
      }
    } catch (e) {
      print('Error loading wishlist: $e');
      isLoading.value = false;
    }
  }

  // Save wishlist to SharedPreferences
  Future<void> saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String wishlistJson = json.encode(wishlistItems);
      await prefs.setString('wishlist', wishlistJson);
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }

  // Add product to wishlist
  Future<void> addToWishlist(String productId) async {
    if (!wishlistItems.contains(productId)) {
      wishlistItems.add(productId);
      await saveWishlist();
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    wishlistItems.remove(productId);
    await saveWishlist();
  }

  // Toggle wishlist status
  Future<void> toggleWishlist(String productId) async {
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.contains(productId);
  }

  // Move product to cart (using reusable cart functionality)
  Future<void> moveToCart(String productId) async {
    try {
      final cartItem = createCartItem(wishlistItems.contains(productId));
      cartController.addToCart(cartItem);
      // Use CartController's addToCart method (reusable from product grid)
      // await cartController.addToCart(cartItem
      //   /*
      //   productId: productId,
      //   quantity: 1,*/
      // );

      // Remove from wishlist after successfully adding to cart
      await removeFromWishlist(productId);

      Get.snackbar(
        'Success',
        'Moved to cart successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      ConsoleLog.printError('Error moving to cart: $e');
      Get.snackbar('Error', 'Failed to move to cart',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Clear entire wishlist
  Future<void> clearWishlist() async {
    wishlistItems.clear();
    await saveWishlist();
  }

  // Get wishlist count
  int get wishlistCount => wishlistItems.length;
}
