import 'package:e_commerce_app/models/ProductDetailsApiResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/HomeDetailsApiResponseModel.dart';
import '../models/product_model.dart';
import '../utils/global_utils.dart';
import '../view/product_detail_screen.dart';

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
  final dynamic product;
  final bool isDark;

  const ProductCard({
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
          Get.to(() => ProductDetailScreen(slug: product.slug ?? ""));
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

                      // Price and Cart Controls
                      buildPriceAndCartSection(product, cartController, isDark),
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

  Widget buildPriceAndCartSection(/*dynamic product,*/ProductDetailsResponseData product, CartController cartController, bool isDark) {
    return Column(
      children: [
        // Prices
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

        // Add to Cart / Quantity Controls
        Obx(() {
          final _ = cartController.cartItems.length;
          final productId = getProductId(product);
          final quantity = cartController.getProductQuantity(productId);
          final isInCart = quantity > 0;
          final stock = product.stock ?? 0;

          return isInCart
              ? buildQuantityControls(productId, quantity, cartController, isDark)
              : stock > 0 ? buildAddButton(product, cartController) : buildOutOfStockButtonButton(product, cartController);
        }),
      ],
    );
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
            onPressed: () {
              cartController.updateQuantity(productId, quantity - 1);
            },
            icon: Icon(Icons.remove, size: 25),
            iconColor: Color(0xff80a8ff),
            backgroundColor: Colors.transparent,
            showBorder: false,
            showShadow: false,
            animation: ButtonAnimation.scale,
            padding: EdgeInsets.all(4),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          GlobalUtils.CustomButton(
            onPressed: () {
              cartController.updateQuantity(productId, quantity + 1);
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
    );
  }

  Widget buildAddButton(/*dynamic product,*/ProductDetailsResponseData product, CartController cartController) {
    return GlobalUtils.CustomButton(
      height: 40,
      onPressed: () {
        final cartItem = createCartItem(product);
        cartController.addToCart(cartItem);
      },
      icon: Icon(Icons.add, size: 25),
      iconColor: Colors.white,
      backgroundColor: Color(0xff80a8ff),
      borderRadius: 8,
      padding: EdgeInsets.all(6),
      showBorder: false,
      animation: ButtonAnimation.scale,
    );
  }

  Widget buildOutOfStockButtonButton(/*dynamic product,*/ProductDetailsResponseData product, CartController cartController) {
    return GlobalUtils.CustomButton(
      height: 40,
      onPressed: null,
      child: const Text("Out of Stock", style: TextStyle(color: Colors.white),),
      iconColor: Colors.white,
      backgroundColor: Colors.grey,
      borderRadius: 8,
      padding: const EdgeInsets.all(6),
      showBorder: false,
      animation: ButtonAnimation.scale,
    );
  }
}

// =====================================================
// PRODUCT LIST ITEM (For Search Screen)
// =====================================================
class ProductListItem extends StatelessWidget {
  // final dynamic product;
  final ProductDetailsResponseData product;
  final bool isDark;

  const ProductListItem({
    super.key,
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
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

          // Add/Quantity Controls
          Obx(() {
            final _ = cartController.cartItems.length;
            final productId = getProductId(product);
            final quantity = cartController.getProductQuantity(productId);
            final isInCart = quantity > 0;

            return isInCart
                ? Container(
                    decoration: BoxDecoration(
                      color: Color(0xff80a8ff).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GlobalUtils.CustomButton(
                          onPressed: () {
                            cartController.updateQuantity(productId, quantity - 1);
                          },
                          icon: Icon(Icons.remove, size: 20),
                          iconColor: Color(0xff80a8ff),
                          backgroundColor: Colors.transparent,
                          showBorder: false,
                          showShadow: false,
                          animation: ButtonAnimation.scale,
                          padding: EdgeInsets.all(4),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$quantity',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        GlobalUtils.CustomButton(
                          onPressed: () {
                            cartController.updateQuantity(productId, quantity + 1);
                          },
                          icon: Icon(Icons.add, size: 20),
                          iconColor: Color(0xff80a8ff),
                          backgroundColor: Colors.transparent,
                          showBorder: false,
                          showShadow: false,
                          animation: ButtonAnimation.scale,
                          padding: EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  )
                : GlobalUtils.CustomButton(
                    onPressed: () {
                      final cartItem = createCartItem(product);
                      cartController.addToCart(cartItem);
                    },
                    text: 'ADD',
                    textColor: Colors.white,
                    backgroundColor: Color(0xff80a8ff),
                    borderRadius: 10,
                    showBorder: false,
                    animation: ButtonAnimation.scale,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  );
          }),
        ],
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









// Widget getProductImage(dynamic product) {
Widget getProductImage(dynamic product) {
  // Handle TopSelling type (from HomeScreen)
  if (product is TopSelling) {
    return product.images != null && product.images!.isNotEmpty
        ? Image.network(product.images!.first, fit: BoxFit.contain)
        : Image.asset("assets/images/noImageIcon.png");
  }

  // Handle ProductDetailsResponseData type
  if (product is ProductDetailsResponseData) {
    final images = product.images;
    if (images != null && images.isNotEmpty) {
      return Image.network(images.first.toString(), fit: BoxFit.contain);
    }
    return Image.asset("assets/images/noImageIcon.png");
  }

  // Handle ProductItem type (for cart)
  if (product is ProductItem) {
    return product.image!.isNotEmpty
        ? Image.network(product.image ?? "", fit: BoxFit.contain)
        : Image.asset("assets/images/noImageIcon.png");
  }

  // Fallback
  return Image.asset("assets/images/noImageIcon.png");
}

// String getProductTitle(dynamic product) {
String getProductTitle(ProductDetailsResponseData product) {
  if (product is ProductItem) return product.title ?? '';
  return product.title?.toString() ?? '';
}

// String getProductDescription(dynamic product) {
String getProductDescription(dynamic  product) {
  if (product is TopSelling) return product.title ?? '';
  if (product is ProductDetailsResponseData) return product.title?.toString() ?? '';
  if (product is ProductItem) return product.title ?? '';
  return '';
}

// String getProductId(dynamic product) {
String getProductId(dynamic product) {
  if (product is TopSelling) return product.product_id?.toString() ?? '';
  if (product is ProductDetailsResponseData) return product.product_id?.toString() ?? '';
  if (product is ProductItem) return product.productId;
  return '';
}

// dynamic getDiscountPrice(dynamic product) {
dynamic getDiscountPrice(dynamic product) {
  if (product is TopSelling) return product.discPrice ?? product.price ?? 0;
  if (product is ProductDetailsResponseData) return product.discPrice ?? product.price ?? 0;
  if (product is ProductItem) return product.sellPrice ?? 0;
  return 0;
}

// dynamic getOriginalPrice(dynamic product) {
dynamic getOriginalPrice(dynamic product) {
  if (product is TopSelling) return product.price ?? 0;
  if (product is ProductDetailsResponseData) return product.price ?? 0;
  if (product is ProductItem) return product.price ?? 0;
  return 0;
}

int getProductStock(dynamic product) {
  if (product is TopSelling) return product.stock ?? 0;
  if (product is ProductDetailsResponseData) return product.stock ?? 0;
  if (product is ProductItem) return 99; // Cart items typically don't have stock
  return 0;
}

String getProductSlug(dynamic product) {
  if (product is TopSelling) return product.slug ?? "";
  if (product is ProductDetailsResponseData) return product.slug ?? "";
  if (product is ProductItem) return "";
  return "";
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

// // ProductItem createCartItem(dynamic product) {
// dynamic createCartItem(ProductDetailsResponseData product) {
//   if (product is ProductItem) return product;
//   return ProductItem(
//     productId: getProductId(product),
//     image: product.images != null && product.images!.isNotEmpty
//         ? product.images!.first
//         : '',
//     images: product.images,
//     title: getProductTitle(product),
//     discription: getProductDescription(product),
//     price: getOriginalPrice(product) ?? 0,
//     sellPrice: getDiscountPrice(product) ?? 0,
//     qty: 1,
//   );
// }