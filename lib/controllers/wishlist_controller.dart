import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WishlistController extends GetxController {
  // Observable list of wishlist product IDs
  var wishlistItems = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  // Load wishlist from SharedPreferences
  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? wishlistJson = prefs.getString('wishlist');
      
      if (wishlistJson != null && wishlistJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(wishlistJson);
        wishlistItems.value = decoded.cast<String>();
      }
    } catch (e) {
      print('Error loading wishlist: $e');
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

  // Clear entire wishlist
  Future<void> clearWishlist() async {
    wishlistItems.clear();
    await saveWishlist();
  }

  // Get wishlist count
  int get wishlistCount => wishlistItems.length;
}
