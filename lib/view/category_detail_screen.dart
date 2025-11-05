import 'package:e_commerce_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/product_screen_controller.dart';
import '../controllers/theme_controller.dart';
import '../utils/global_utils.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String? categoryName;
  final String? categoryImage;
  final String? categoryId;

  const CategoryDetailScreen({super.key, required this.categoryName, required this.categoryImage, required this.categoryId});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final CartController cartController = Get.put(CartController());
  final ThemeController themeController = Get.put(ThemeController());
  final ProductScreenController productController = Get.put(ProductScreenController());
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  void initState() {
    super.initState();
    productController.getToken(context ,int.parse(widget.categoryId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final categoryData = themeController.categoryThemes[productController.product[index].];
    final categoryData = themeController.getCategoryTheme(
      widget.categoryName ?? 'Default',
      widget.categoryImage ?? '',
      index: int.tryParse(widget.categoryId ?? '0'),
    );
    return Scaffold(
      backgroundColor: isDark ? Color(0xff1a1a1a) : Colors.white,
      body: SafeArea(
          minimum: EdgeInsets.only(top: 0),
          child: /*productController.product.value.isNotEmpty ? */Obx(()=> CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: /*Color(0xff80a8ff)*/isDark ? Colors.grey.shade900 : Colors.white,
                title: Text(widget.categoryName.toString(), style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: categoryData['colors'] as List<Color>,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top:60, bottom: 0),
                      child: Image.network(categoryData['image'].toString()),
                    ),
                  ),
                ),
              ),
              productController.product.value.isNotEmpty ?
              SliverPadding(
                padding: EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      // var product = products[index];
                      return IntrinsicHeight(
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
                              SizedBox(
                                height: 125,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Center(
                                    // child: Icon(product['image'] as IconData, size: 50, color: Colors.grey)
                                      child: productController.product[index].images!.isNotEmpty ? Image.network(productController.product[index].images!.first.toString(), fit: BoxFit.contain) : Image.asset("assets/images/noImageIcon.png"),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productController.product[index].title.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        productController.product[index].slug.toString(),
                                        maxLines: 3,
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                      // SizedBox(height: 8),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("₹${productController.product[index].discPrice.toString()}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xff80a8ff),
                                            ),
                                          ),
                                          GlobalUtils.CustomButton(
                                            onPressed: () => cartController.addToCart(productController.product[index] as Map<String, dynamic>),
                                            icon: Icon(Icons.add),
                                            iconColor: Colors.white,
                                            backgroundColor: Color(0xff80a8ff),
                                            borderRadius: 8,
                                            padding: EdgeInsets.all(6),
                                            showBorder: false,
                                            animation: ButtonAnimation.scale,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            )

                        ),
                      );
                    },
                    childCount: productController.product.length,
                  ),
                ),
              ): SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No Items Available!",
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),)
              // : Center(child: Text("No Items Available!"),),
      ),
    );
  }
}