import 'package:e_commerce_app/models/ProductDetailsApiResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/search_screen_controller.dart';
import '../models/HomeDetailsApiResponseModel.dart';
import '../models/product_model.dart';
import '../utils/global_utils.dart';
import '../view/product_detail_screen.dart';
import 'package:e_commerce_app/models/SearchProductApiResponseModel.dart' as SearchModel;

// =====================================================
// REUSABLE PRODUCT GRID WIDGET
// =====================================================
class ReusableProductGrid extends StatelessWidget {
  final List<dynamic> products; // ProductItem ya koi bhi product list
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const ReusableProductGrid({
    super.key,
    required this.products,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.53,
    this.crossAxisSpacing = 15,
    this.mainAxisSpacing = 15,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product, isDark: isDark);
      },
    );
  }
}

// =====================================================
// REUSABLE PRODUCT LIST WIDGET (For Search Screen)
// =====================================================
class ReusableProductList extends StatelessWidget {
  final List<dynamic> products;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const ReusableProductList({
    super.key,
    required this.products,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(product: product, isDark: isDark);
      },
    );
  }
}

// =====================================================
// PRODUCT CARD (Grid Item)
// =====================================================
class ProductCard extends StatelessWidget {
  // final dynamic product;
  dynamic product;
  final bool isDark;

  ProductCard({
    super.key,
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return IntrinsicHeight(
      child: InkWell(
        onTap: () {
          // String slug = getProductSlug(product);
          // if (slug.isNotEmpty) {
          //   Get.to(() => ProductDetailScreen(slug: slug));
          // }
          Get.to(() => ProductDetailScreen(slug: getProductSlug(product)));
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xff2a2a2a) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Color(0xff3a3a3a) : Color(0xfff0f0f0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image
              Container(
                height: 125,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Center(
                  child: getProductImage(product),
                ),
              ),

              // Product Details
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Title
                      Text(
                        getProductTitle(product),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),

                      // Product Description
                      Text(
                        getProductDescription(product),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Spacer(),
                      // SizedBox(height: 8),

                      // buildPriceAndCartSection(product, cartController, isDark),
                      Column(
                        children: [
                          // Column(
                            //     children: [
                            //       // Prices
                                  Row(
                                    children: [
                                      Text(
                                        '₹${getDiscountPrice(product)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color(0xff80a8ff),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '₹${getOriginalPrice(product)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xff80a8ff),
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.red,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                            //
                            //       // SizedBox(height: 8),
                          _buildSmartButton(cartController),
                        ],
                      ),
                      // Price and Cart Controls
                      // buildPriceAndCartSection(product, cartController, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 FIXED: Main button logic with proper priority
  Widget _buildSmartButton(CartController cartController) {
    // Check if it's a ProductItem (search results)
    if (product is ProductItem) {
      return _buildSearchResultButton(cartController);
    }

    // For other product types (Home screen, etc.)
    return _buildNormalButton(cartController);
  }

  // 🎯 Search Result Button - STOCK CHECK FIRST
  Widget _buildSearchResultButton(CartController cartController) {
    final searchController = Get.isRegistered<SearchScreenController>()
        ? Get.find<SearchScreenController>()
        : null;

    // If no search controller, fallback to normal
    if (searchController == null) {
      return _buildNormalButton(cartController);
    }

    final productItem = product as ProductItem;
    final productId = productItem.productId;
    final slug = productItem.slug ?? "";

    return Obx(() {
      // Force rebuild when cart changes
      final _ = cartController.cartItems.length;

      final quantity = cartController.getProductQuantity(productId);
      final isInCart = quantity > 0;

      // 🚨 PRIORITY 1: If in cart, show quantity controls (no stock check)
      if (isInCart) {
        return buildQuantityControls(productId, quantity, cartController, isDark);
      }

      // 🚨 PRIORITY 2: Check stock status
      final isFetching = searchController.isFetchingStock(slug);
      final isStockFetched = searchController.isStockFetched(slug);
      final stock = searchController.getStock(slug);

      // STATE 1: Stock not fetched yet - SHOW LOADING
      if (!isStockFetched) {
        return _buildLoadingButton();
      }

      // STATE 2: Stock fetched - check availability
      if (stock != null && stock <= 0) {
        return _buildOutOfStockButton();
      }

      // STATE 3: Stock available - show add button
      if (stock != null && stock > 0) {
        return buildAddButtonWithStock(cartController, stock);
      }

      // Fallback: Show loading if stock is null but fetched
      return _buildLoadingButton();
    });
  }

  // 🎯 Normal Button (for Home screen items)
  Widget _buildNormalButton(CartController cartController) {
    return Obx(() {
      final _ = cartController.cartItems.length;
      final productId = getProductId(product);
      final quantity = cartController.getProductQuantity(productId);
      final isInCart = quantity > 0;

      if (isInCart) {
        return buildQuantityControls(productId, quantity, cartController, isDark);
      }

      // For home screen, show add button directly (they have stock in data)
      if (product is TopSelling) {
        final stock = (product as TopSelling).stock ?? 0;
        if (stock <= 0) {
          return _buildOutOfStockButton();
        }
      }

      return _buildAddButton(cartController, (product as TopSelling).stock ?? 0);
    });
  }

  // Widget buildPriceAndCartSection(/*dynamic product,*/dynamic product, CartController cartController, bool isDark) {
  //   return Column(
  //     children: [
  //       // Prices
  //       Row(
  //         children: [
  //           Text(
  //             '₹${getDiscountPrice(product)}',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 20,
  //               color: Color(0xff80a8ff),
  //             ),
  //           ),
  //           SizedBox(width: 5),
  //           Text(
  //             '₹${getOriginalPrice(product)}',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 16,
  //               color: Color(0xff80a8ff),
  //               decoration: TextDecoration.lineThrough,
  //               decorationColor: Colors.red,
  //               decorationThickness: 2,
  //             ),
  //           ),
  //         ],
  //       ),
  //
  //       // SizedBox(height: 8),
  //
  //       // 🎯 NEW: Add to Cart / Quantity Controls with Stock Check
  //       buildStockAwareButton(product, cartController, isDark),
  //       // // Add to Cart / Quantity Controls
  //       // Obx(() {
  //       //   final _ = cartController.cartItems.length;
  //       //   final productId = getProductId(product);
  //       //   final quantity = cartController.getProductQuantity(productId);
  //       //   final isInCart = quantity > 0;
  //       //   // final stock = getProductStock(product);
  //       //   final stock = getProductStock(product);
  //       //
  //       //   return isInCart
  //       //       ? buildQuantityControls(productId, quantity, cartController, isDark)
  //       //       : stock > 0
  //       //       ? buildAddButton(product, cartController)
  //       //       : buildOutOfStockButton();
  //       // }),
  //     ],
  //   );
  // }
  //
  // // 🎯 NEW METHOD: Stock-aware button builder
  // Widget buildStockAwareButton(dynamic product, CartController cartController, bool isDark) {
  //   // Agar ProductItem hai (search results), to stock check karo
  //   if (product is ProductItem) {
  //     return _buildSearchProductButton(product, cartController, isDark);
  //   }
  //
  //   final searchController = Get.isRegistered<SearchScreenController>()
  //       ? Get.find<SearchScreenController>()
  //       : null;
  //
  //   if (searchController == null) {
  //     return _buildSimpleAddButton(cartController, isDark);
  //   }
  //
  //   // Other product types ke liye existing logic
  //   return Obx(() {
  //     final _ = cartController.cartItems.length;
  //     final productId = getProductId(product);
  //     final slug = getProductSlug(product);
  //     final quantity = cartController.getProductQuantity(productId);
  //     final isInCart = quantity > 0;
  //
  //     // If already in cart, show quantity controls (no stock check needed)
  //     if (isInCart) {
  //       return buildQuantityControls(productId, quantity, cartController, isDark);
  //     }
  //
  //     // Check stock status
  //     final isFetching = searchController.isFetchingStock(slug);
  //     final isStockFetched = searchController.isStockFetched(slug);
  //     final stock = searchController.getStock(slug);
  //
  //     // 🚨 STATE 1: Loading Stock (MANDATORY WAIT)
  //     // Show loading until stock is fetched
  //     if (!isStockFetched || (isFetching && stock == null)) {
  //       return _buildLoadingButton();
  //     }
  //
  //     // 🚨 STATE 2: Stock Fetched - Check availability
  //     if (isStockFetched && stock != null) {
  //       if (stock <= 0) {
  //         // Out of Stock
  //         return _buildOutOfStockButton();
  //       } else {
  //         // Stock Available
  //         return _buildAddButton(cartController, stock);
  //       }
  //     }
  //
  //     // Fallback: Show loading
  //     return _buildLoadingButton();
  //   });
  //
  //   //   // TopSelling ya ProductDetailsResponseData ke case mein
  //   //   if (product is ProductDetailsResponseData) {
  //   //     final stock = product.stock ?? 0;
  //   //     return isInCart
  //   //         ? buildQuantityControls(productId, quantity, cartController, isDark)
  //   //         : stock > 0
  //   //         ? buildAddButton(product, cartController)
  //   //         : buildOutOfStockButton();
  //   //   }
  //   //
  //   //   // Default case
  //   //   return isInCart
  //   //       ? buildQuantityControls(productId, quantity, cartController, isDark)
  //   //       : buildAddButton(product, cartController);
  //   // });
  // }

  // 🔄 Enhanced Loading Button with Animation
  Widget _buildLoadingButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff80a8ff).withOpacity(0.1),
            Color(0xff80a8ff).withOpacity(0.2),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xff80a8ff).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff80a8ff)),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Checking Stock...',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xff80a8ff),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  // ❌ Out of Stock Button
  Widget _buildOutOfStockButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red[300]!, width: 1.5),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_shopping_cart_outlined,
              size: 18,
              color: Colors.red[700],
            ),
            SizedBox(width: 6),
            Text(
              'Out of Stock',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Add Button with Stock Badge
  Widget buildAddButtonWithStock(CartController cartController, int stock) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stock Badge
        if (stock <= 10)
          Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: stock <= 5 ? Colors.orange[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              stock <= 5 ? 'Only $stock left!' : '$stock in stock',
              style: TextStyle(
                fontSize: 9,
                color: stock <= 5 ? Colors.orange[900] : Colors.green[900],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Add Button
        GlobalUtils.CustomButton(
          height: 40,
          onPressed: () {
            final cartItem = createCartItem(product);
            cartController.addToCart(cartItem);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_shopping_cart, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xff80a8ff),
          borderRadius: 10,
          padding: EdgeInsets.symmetric(horizontal: 8),
          showBorder: false,
          animation: ButtonAnimation.scale,
        ),
      ],
    );
  }

  // ✅ Simple Add Button (for home screen)
  // Widget buildAddButtonSimple(CartController cartController) {
  //   return GlobalUtils.CustomButton(
  //     height: 40,
  //     onPressed: () {
  //       final cartItem = createCartItem(product);
  //       cartController.addToCart(cartItem);
  //     },
  //     icon: Icon(Icons.add, size: 20),
  //     iconColor: Colors.white,
  //     backgroundColor: Color(0xff80a8ff),
  //     borderRadius: 8,
  //     padding: EdgeInsets.all(6),
  //     showBorder: false,
  //     animation: ButtonAnimation.scale,
  //   );
  // }
  // // ✅ Add to Cart Button (with stock badge)
  Widget _buildAddButton(CartController cartController, int stock) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stock Badge (optional but helpful)
        if (stock <= 10)
          Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: stock <= 5 ? Colors.orange[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              stock <= 5 ? 'Only $stock left!' : '$stock in stock',
              style: TextStyle(
                fontSize: 9,
                color: stock <= 5 ? Colors.orange[900] : Colors.green[900],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Add Button
        GlobalUtils.CustomButton(
          height: 40,
          onPressed: () {
            final cartItem = createCartItem(product);
            if (cartItem != null) {
              cartController.addToCart(cartItem);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xff80a8ff),
          borderRadius: 10,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          showBorder: false,
          animation: ButtonAnimation.scale,
        ),
      ],
    );
  }
  //
  // // Simple Add Button (fallback for non-search screens)
  // Widget _buildSimpleAddButton(CartController cartController, bool isDark) {
  //   return Obx(() {
  //     final _ = cartController.cartItems.length;
  //     final productId = getProductId(product);
  //     final quantity = cartController.getProductQuantity(productId);
  //     final isInCart = quantity > 0;
  //
  //     if (isInCart) {
  //       return buildQuantityControls(productId, quantity, cartController, isDark);
  //     }
  //
  //     return GlobalUtils.CustomButton(
  //       height: 40,
  //       onPressed: () {
  //         final cartItem = createCartItem(product);
  //         if (cartItem != null) {
  //           cartController.addToCart(cartItem);
  //         }
  //       },
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
  //           SizedBox(width: 4),
  //           Text(
  //             'Add',
  //             style: TextStyle(
  //               fontSize: 12,
  //               color: Colors.white,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       backgroundColor: Color(0xff80a8ff),
  //       borderRadius: 8,
  //       padding: EdgeInsets.all(6),
  //       showBorder: false,
  //       animation: ButtonAnimation.scale,
  //     );
  //   });
  // }

  // 🎯 NEW: Search product button with stock management
  Widget _buildSearchProductButton(ProductItem product, CartController cartController, bool isDark) {
    // Try to get SearchScreenController
    final searchController = Get.isRegistered<SearchScreenController>()
        ? Get.find<SearchScreenController>()
        : null;

    if (searchController == null) {
      // Fallback: Normal button without stock check
      return Obx(() {
        final _ = cartController.cartItems.length;
        final productId = product.productId;
        final quantity = cartController.getProductQuantity(productId);
        final isInCart = quantity > 0;

        return isInCart
            ? buildQuantityControls(productId, quantity, cartController, isDark)
            : /*buildAddButton(product, cartController)*/_buildAddButton(cartController, (product as TopSelling).stock ?? 0);
      });
    }

    // With stock check
    return Obx(() {
      final _ = cartController.cartItems.length;
      final productId = product.productId;
      final slug = product.slug ?? "";
      final quantity = cartController.getProductQuantity(productId);
      final isInCart = quantity > 0;

      // Check stock status
      final isFetching = searchController.isFetchingStock(slug);
      final isStockFetched = searchController.isStockFetched(slug);
      final stock = searchController.getStock(slug);

      // Show loading while fetching
      if (isFetching && !isStockFetched) {
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xff80a8ff).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff80a8ff)),
              ),
            ),
          ),
        );
      }

      // Show Out of Stock if stock is 0
      if (isStockFetched && stock != null && stock <= 0) {
        return _buildOutOfStockButton();
      }

      // Show cart controls or add button
      return isInCart
          ? buildQuantityControls(productId, quantity, cartController, isDark)
          : /*buildAddButton(product, cartController)*/_buildAddButton(cartController, stock!);
    });
  }



  Widget buildQuantityControls(String productId, int quantity, CartController cartController, bool isDark) {
    return Container(
      width: GlobalUtils.screenWidth,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xff80a8ff).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlobalUtils.CustomButton(
            onPressed: () => cartController.updateQuantity(productId, quantity - 1),
            icon: Icon(Icons.remove, size: 25),
            iconColor: Color(0xff80a8ff),
            backgroundColor: Colors.transparent,
            showBorder: false,
            showShadow: false,
            animation: ButtonAnimation.scale,
            padding: EdgeInsets.all(4),
          ),
          Text(
            '$quantity',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          GlobalUtils.CustomButton(
            onPressed: () => cartController.updateQuantity(productId, quantity + 1),
            icon: Icon(Icons.add, size: 25),
            iconColor: Color(0xff80a8ff),
            backgroundColor: Colors.transparent,
            showBorder: false,
            showShadow: false,
            animation: ButtonAnimation.scale,
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  // Widget buildAddButton(/*dynamic product,*/dynamic product, CartController cartController) {
  //   return GlobalUtils.CustomButton(
  //     height: 40,
  //     onPressed: () {
  //       final cartItem = createCartItem(product);
  //       cartController.addToCart(cartItem);
  //     },
  //     icon: Icon(Icons.add, size: 25),
  //     iconColor: Colors.white,
  //     backgroundColor: Color(0xff80a8ff),
  //     borderRadius: 8,
  //     padding: EdgeInsets.all(6),
  //     showBorder: false,
  //     animation: ButtonAnimation.scale,
  //   );
  // }

  // // 🎯 NEW: Out of Stock button
  // Widget buildOutOfStockButton() {
  //   return Container(
  //     height: 40,
  //     decoration: BoxDecoration(
  //       color: Colors.red[50],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.red[200]!),
  //     ),
  //     child: Center(
  //       child: Text(
  //         "Out of Stock",
  //         style: TextStyle(
  //           color: Colors.red[700],
  //           fontSize: 12,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget buildOutOfStockButton() {
  //   return GlobalUtils.CustomButton(
  //     height: 40,
  //     onPressed: null,
  //     child: const Text("Out of Stock", style: TextStyle(color: Colors.white),),
  //     iconColor: Colors.white,
  //     backgroundColor: Colors.grey,
  //     borderRadius: 8,
  //     padding: const EdgeInsets.all(6),
  //     showBorder: false,
  //     animation: ButtonAnimation.scale,
  //   );
  // }
}

// =====================================================
// PRODUCT LIST ITEM (For Search Screen)
// =====================================================
class ProductListItem extends StatelessWidget {
  final dynamic product;
  // final ProductDetailsResponseData product;
  final bool isDark;

  const ProductListItem({
    super.key,
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return InkWell(
      onTap: () {
        String slug = getProductSlug(product);
        if (slug.isNotEmpty) {
          Get.to(() => ProductDetailScreen(slug: slug));
        } else{
          GlobalUtils.showSnackbar(
            title: 'Error',
            message: 'Product information not available',
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Color(0xff2a2a2a) : Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: getProductImage(product),
              ),
            ),
            SizedBox(width: 15),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getProductTitle(product),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    getProductDescription(product),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '₹${getDiscountPrice(product)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff80a8ff),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '₹${getOriginalPrice(product)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //12.11.2025//Temperory comment
            // Fixed: Add/Quantity Controls with proper sizing
            // SizedBox(
            //   width: 100,
            //   child: Obx(() {
            //     final _ = cartController.cartItems.length;
            //     final productId = getProductId(product);
            //     final quantity = cartController.getProductQuantity(productId);
            //     final isInCart = quantity > 0;
            //     final stock = getProductStock(product);
            //
            //     return isInCart
            //         ? Container(
            //       height: 40,
            //       decoration: BoxDecoration(
            //         color: Color(0xff80a8ff).withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           IconButton(
            //             onPressed: () => cartController.updateQuantity(productId, quantity - 1),
            //             icon: Icon(Icons.remove, size: 18),
            //             color: Color(0xff80a8ff),
            //             padding: EdgeInsets.zero,
            //             constraints: BoxConstraints(),
            //           ),
            //           Text(
            //             '$quantity',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 14,
            //               color: isDark ? Colors.white : Colors.black87,
            //             ),
            //           ),
            //           IconButton(
            //             onPressed: () => cartController.updateQuantity(productId, quantity + 1),
            //             icon: Icon(Icons.add, size: 18),
            //             color: Color(0xff80a8ff),
            //             padding: EdgeInsets.zero,
            //             constraints: BoxConstraints(),
            //           ),
            //         ],
            //       ),
            //     )
            //         : stock > 0
            //         ? GlobalUtils.CustomButton(
            //       height: 40,
            //       onPressed: () {
            //         final cartItem = createCartItem(product);
            //         cartController.addToCart(cartItem);
            //       },
            //       text: 'ADD',
            //       textColor: Colors.white,
            //       backgroundColor: Color(0xff80a8ff),
            //       borderRadius: 10,
            //       showBorder: false,
            //       animation: ButtonAnimation.scale,
            //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     )
            //         : Container(
            //       height: 40,
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         color: Colors.grey,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Text(
            //         'Out of Stock',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 10,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// HELPER FUNCTIONS
// =====================================================







// =====================================================
// REUSABLE CART LIST WIDGET
// =====================================================
class ReusableCartList extends StatelessWidget {
  final List<ProductItem> cartItems;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const ReusableCartList({
    super.key,
    required this.cartItems,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? EdgeInsets.all(20),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return CartItemCard(
          item: item,
          isDark: isDark,
        );
      },
    );
  }
}

// =====================================================
// CART ITEM CARD
// =====================================================
class CartItemCard extends StatelessWidget {
  final ProductItem item;
  final bool isDark;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isDark,
    this.margin,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff2a2a2a) : Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          _buildProductImage(),
          SizedBox(width: 15),

          // Product Details
          Expanded(
            child: _buildProductDetails(),
          ),

          SizedBox(width: 10),

          // Quantity Controls
          _buildQuantityControls(cartController),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          item.image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image, size: 35, color: Colors.grey);
          },
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5),
        Text(
          item.discription,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              '₹${item.sellPrice}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xff80a8ff),
              ),
            ),
            SizedBox(width: 8),
            if (item.price != item.sellPrice)
              Text(
                '₹${item.price}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(CartController cartController) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff80a8ff).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          GlobalUtils.CustomButton(
            onPressed: () {
              cartController.updateQuantity(
                item.productId,
                item.qty + 1,
              );
            },
            icon: Icon(Icons.add, size: 20),
            iconColor: Color(0xff80a8ff),
            backgroundColor: Colors.transparent,
            showBorder: false,
            showShadow: false,
            animation: ButtonAnimation.scale,
            padding: EdgeInsets.all(8),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${item.qty}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          GlobalUtils.CustomButton(
            onPressed: () {
              cartController.updateQuantity(
                item.productId,
                item.qty - 1,
              );
            },
            icon: Icon(Icons.remove, size: 20),
            iconColor: Color(0xff80a8ff),
            backgroundColor: Colors.transparent,
            showBorder: false,
            showShadow: false,
            animation: ButtonAnimation.scale,
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ALTERNATIVE: HORIZONTAL QUANTITY CONTROLS (Optional)
// =====================================================
class CartItemCardHorizontal extends StatelessWidget {
  final ProductItem item;
  final bool isDark;
  final EdgeInsetsGeometry? margin;

  const CartItemCardHorizontal({
    super.key,
    required this.item,
    required this.isDark,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff2a2a2a) : Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image, size: 35, color: Colors.grey);
                    },
                  ),
                ),
              ),
              SizedBox(width: 15),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      item.discription,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '₹${item.sellPrice}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff80a8ff),
                          ),
                        ),
                        SizedBox(width: 8),
                        if (item.price != item.sellPrice)
                          Text(
                            '₹${item.price}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Horizontal Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: Color(0xff80a8ff).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlobalUtils.CustomButton(
                  onPressed: () {
                    cartController.updateQuantity(
                      item.productId,
                      item.qty - 1,
                    );
                  },
                  icon: Icon(Icons.remove, size: 25),
                  iconColor: Color(0xff80a8ff),
                  backgroundColor: Colors.transparent,
                  showBorder: false,
                  showShadow: false,
                  animation: ButtonAnimation.scale,
                  padding: EdgeInsets.all(8),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${item.qty}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                GlobalUtils.CustomButton(
                  onPressed: () {
                    cartController.updateQuantity(
                      item.productId,
                      item.qty + 1,
                    );
                  },
                  icon: Icon(Icons.add, size: 25),
                  iconColor: Color(0xff80a8ff),
                  backgroundColor: Colors.transparent,
                  showBorder: false,
                  showShadow: false,
                  animation: ButtonAnimation.scale,
                  padding: EdgeInsets.all(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// CART SUMMARY WIDGET (Bottom Section)
// =====================================================
class CartSummary extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final VoidCallback onCheckout;
  final bool isDark;

  const CartSummary({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.onCheckout,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff2a2a2a) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total Items Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              Text(
                '$totalItems',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Total Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              GlobalUtils.CustomGradientText(
                '₹${totalPrice.toStringAsFixed(2)}',
                gradient: LinearGradient(
                  colors: [Color(0xff80a8ff), Color(0xff5e60ce)],
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Checkout Button
          GlobalUtils.CustomButton(
            onPressed: onCheckout,
            text: 'Proceed to Checkout',
            textColor: Colors.white,
            backgroundGradient: LinearGradient(
              colors: [Color(0xff80a8ff), Color(0xff5e60ce)],
            ),
            borderRadius: 15,
            animation: ButtonAnimation.scale,
            height: 55,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// EMPTY CART WIDGET
// =====================================================
class EmptyCartWidget extends StatelessWidget {
  final VoidCallback onStartShopping;
  final bool isDark;

  const EmptyCartWidget({
    super.key,
    required this.onStartShopping,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: GlobalUtils.screenHeight * 0.25),
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Your cart is empty!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add items to get started',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: GlobalUtils.screenHeight * 0.2),
          GlobalUtils.CustomButton(
            width: GlobalUtils.screenWidth * 0.9,
            onPressed: onStartShopping,
            text: 'Start Shopping',
            textColor: Colors.white,
            backgroundColor: Color(0xff80a8ff),
            borderRadius: 15,
            animation: ButtonAnimation.scale,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
        ],
      ),
    );
  }
}









// Helper functions (keep existing ones and add slug getter)
String getProductSlug(dynamic product) {
  if (product is TopSelling) return product.slug ?? "";
  if (product is ProductDetailsResponseData) return product.slug ?? "";
  if (product is ProductItem) return product.slug ?? "";
  return "";
}

// Keep all other existing helper functions from reusable_product_grid.dart
Widget getProductImage(dynamic product) {
  if (product is TopSelling) {
    return product.images != null && product.images!.isNotEmpty
        ? Image.network(product.images!.first, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/images/noImageIcon.png",
        fit: BoxFit.contain,
      );
    }) : Image.asset("assets/images/noImageIcon.png");
  }
  if (product is ProductDetailsResponseData) {
    final images = product.images;
    if (images != null && images.isNotEmpty) {
      return Image.network(images.first.toString(), fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "assets/images/noImageIcon.png",
          fit: BoxFit.contain,
        );
      });
    }else{return Image.asset("assets/images/noImageIcon.png");}
    return Image.asset("assets/images/noImageIcon.png");
  }
  if (product is ProductItem) {
    return product.image!.isNotEmpty
        ? Image.network(product.image ?? "", fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/images/noImageIcon.png",
        fit: BoxFit.contain,
      );
    }) : Image.asset("assets/images/noImageIcon.png");
  }
  return Image.asset("assets/images/noImageIcon.png");
}

String getProductTitle(dynamic product) {
  if (product is ProductItem) return product.title ?? '';
  if (product is TopSelling) return product.title ?? '';
  if (product is ProductDetailsResponseData) return product.title?.toString() ?? '';
  return '';
}

String getProductDescription(dynamic product) {
  if (product is TopSelling) return product.title ?? '';
  if (product is ProductDetailsResponseData) return product.title?.toString() ?? '';
  if (product is ProductItem) return product.discription ?? '';
  return '';
}

String getProductId(dynamic product) {
  if (product is TopSelling) return product.product_id?.toString() ?? '';
  if (product is ProductDetailsResponseData) return product.product_id?.toString() ?? '';
  if (product is ProductItem) return product.productId;
  return '';
}

dynamic getDiscountPrice(dynamic product) {
  if (product is TopSelling) return product.discPrice ?? product.price ?? 0;
  if (product is ProductDetailsResponseData) return product.discPrice ?? product.price ?? 0;
  if (product is ProductItem) return product.sellPrice ?? 0;
  return 0;
}

dynamic getOriginalPrice(dynamic product) {
  if (product is TopSelling) return product.price ?? 0;
  if (product is ProductDetailsResponseData) return product.price ?? 0;
  if (product is ProductItem) return product.price ?? 0;
  return 0;
}

ProductItem createCartItem(dynamic product) {
  if (product is ProductItem) return product;

  return ProductItem(
    productId: getProductId(product),
    image: getProductImageUrl(product),
    images: getProductImages(product),
    title: getProductTitle(product),
    discription: getProductDescription(product),
    price: getOriginalPrice(product) ?? 0,
    sellPrice: getDiscountPrice(product) ?? 0,
    qty: 1,
    slug: getProductSlug(product),
  );
}

String getProductImageUrl(dynamic product) {
  if (product is TopSelling) {
    return product.images != null && product.images!.isNotEmpty ? product.images!.first : '';
  }
  if (product is ProductDetailsResponseData) {
    return product.images != null && product.images!.isNotEmpty ? product.images!.first : '';
  }
  if (product is ProductItem) {
    return product.image ?? '';
  }
  return '';
}

List<String>? getProductImages(dynamic product) {
  if (product is TopSelling) return product.images;
  if (product is ProductDetailsResponseData) return product.images;
  if (product is ProductItem) return product.images;
  return null;
}
// Widget getProductImage(dynamic product) {
//   // Search Result (Data from SearchProductApiResponseModel)
//   if (product is SearchModel.Data) {
//     return product.image != null && product.image!.isNotEmpty
//         ? Image.network(product.image!, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Image.asset("assets/images/noImageIcon.png"))
//         : Image.asset("assets/images/noImageIcon.png");
//   }
//   if (product is TopSelling) {
//     return product.images != null && product.images!.isNotEmpty
//         ? Image.network(product.images!.first, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Image.asset("assets/images/noImageIcon.png"))
//         : Image.asset("assets/images/noImageIcon.png");
//   }
//   if (product is ProductDetailsResponseData) {
//     return product.images != null && product.images!.isNotEmpty
//         ? Image.network(product.images!.first, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Image.asset("assets/images/noImageIcon.png"))
//         : Image.asset("assets/images/noImageIcon.png");
//   }
//   if (product is ProductItem) {
//     return product.image != null && product.image!.isNotEmpty
//         ? Image.network(product.image!, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Image.asset("assets/images/noImageIcon.png"))
//         : Image.asset("assets/images/noImageIcon.png");
//   }
//   return Image.asset("assets/images/noImageIcon.png");
// }
//
// String getProductTitle(dynamic product) {
//   if (product is SearchModel.Data) return product.title ?? '';
//   if (product is TopSelling) return product.title ?? '';
//   if (product is ProductDetailsResponseData) return product.title?.toString() ?? '';
//   if (product is ProductItem) return product.title ?? '';
//   return '';
// }
//
// String getProductDescription(dynamic product) {
//   if (product is SearchModel.Data) return product.shortDescription?.toString() ?? product.description?.toString() ?? product.title ?? '';
//   if (product is TopSelling) return product.shortDiscription ?? product.title ?? '';
//   if (product is ProductDetailsResponseData) return product.shortDiscription?.toString() ?? product.title?.toString() ?? '';
//   if (product is ProductItem) return product.discription ?? '';
//   return '';
// }
//
// String getProductId(dynamic product) {
//   if (product is SearchModel.Data) return product.productId?.toString() ?? product.id?.toString() ?? '';
//   if (product is TopSelling) return product.product_id?.toString() ?? '';
//   if (product is ProductDetailsResponseData) return product.product_id?.toString() ?? '';
//   if (product is ProductItem) return product.productId;
//   return '';
// }
//
// dynamic getDiscountPrice(dynamic product) {
//   if (product is SearchModel.Data) return product.discPrice ?? product.price ?? 0;
//   if (product is TopSelling) return product.discPrice ?? product.price ?? 0;
//   if (product is ProductDetailsResponseData) return product.discPrice ?? product.price ?? 0;
//   if (product is ProductItem) return product.sellPrice ?? 0;
//   return 0;
// }
//
// dynamic getOriginalPrice(dynamic product) {
//   if (product is SearchModel.Data) return product.price ?? 0;
//   if (product is TopSelling) return product.price ?? 0;
//   if (product is ProductDetailsResponseData) return product.price ?? 0;
//   if (product is ProductItem) return product.price ?? 0;
//   return 0;
// }
//
// int getProductStock(dynamic product) {
//   if (product is SearchModel.Data) return 999; // Search results don't have stock, assume available
//   if (product is TopSelling) return product.stock ?? 0;
//   if (product is ProductDetailsResponseData) return product.stock ?? 0;
//   if (product is ProductItem) return 999; // Default high stock for cart items
//   return 0;
// }
//
// String getProductSlug(dynamic product) {
//   print('=== SLUG DEBUG ===');
//   print('Product Type: ${product.runtimeType}');
//
//   if (product is ProductItem) {
//     print('ProductItem slug: ${product.slug}');
//     print('ProductItem ID: ${product.productId}');
//
//     // Agar slug empty hai toh productId use karein
//     if (product.slug.isNotEmpty) {
//       return product.slug;
//     } else {
//       return product.productId; // Fallback to productId
//     }
//   }
//   if (product is SearchModel.Data) return product.slug ?? "";  // ✅ NEW
//   if (product is TopSelling) return product.slug ?? "";
//   if (product is ProductDetailsResponseData) return product.slug ?? "";
//   return "";
// }
//
// String getProductImageUrl(dynamic product) {
//   if (product is SearchModel.Data) return product.image ?? '';
//   if (product is TopSelling) return product.images != null && product.images!.isNotEmpty ? product.images!.first : '';
//   if (product is ProductDetailsResponseData) return product.images != null && product.images!.isNotEmpty ? product.images!.first : '';
//   if (product is ProductItem) return product.image ?? '';
//   return '';
// }
//
// List<String>? getProductImages(dynamic product) {
//   if (product is SearchModel.Data) {
//     // Search results have single image, convert to list
//     return product.image != null ? [product.image!] : null;
//   }
//   if (product is TopSelling) return product.images;
//   if (product is ProductDetailsResponseData) return product.images;
//   if (product is ProductItem) return product.images;
//   return null;
// }
//
// // FIXED: Proper type conversion
// ProductItem createCartItem(dynamic product) {
//   if (product is ProductItem) return product;
//
//   return ProductItem(
//     productId: getProductId(product),
//     image: getProductImageUrl(product),
//     images: getProductImages(product),
//     title: getProductTitle(product),
//     discription: getProductDescription(product),
//     price: _parseToDouble(getOriginalPrice(product)),
//     sellPrice: _parseToDouble(getDiscountPrice(product)),
//     qty: 1,
//     slug: getProductSlug(product),
//     // stock: getProductStock(product)
//   );
// }
//
// // Helper function for safe type conversion
// double _parseToDouble(dynamic value) {
//   if (value == null) return 0.0;
//   if (value is double) return value;
//   if (value is int) return value.toDouble();
//   if (value is String) return double.tryParse(value) ?? 0.0;
//   return 0.0;
// }