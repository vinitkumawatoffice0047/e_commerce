import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../utils/global_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final CartController cartController = Get.put(CartController());

  // GetX reactive list - yeh keyboard issue fix karega
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final List<String> recentSearches = ['Milk', 'Bread', 'Eggs', 'Rice'];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void performSearch(String value) {
    if (value.isNotEmpty) {
      searchResults.value = List.generate(
        5,
            (index) => {
          'id': 'search_$index',
          'name': 'Search Result ${index + 1}',
          'weight': '500g',
          'price': (index + 1) * 60.0,
          'image': Icons.image,
        },
      );
    } else {
      searchResults.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xff1a1a1a) : Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff80a8ff),
        elevation: 0,
        title: GlobalUtils.CustomTextField(
          label: '',
          showLabel: false,
          controller: searchController,
          placeholder: 'Search products...',
          placeholderColor: Colors.grey,
          inputTextColor: isDark ? Colors.white : Colors.black,
          prefixIcon: Icon(Icons.search, color: Color(0xff80a8ff)),
          backgroundColor: isDark ? Color(0xff2a2a2a) : Color(0xfff5f5f5),
          borderRadius: 12,
          height: 50,
          customValidator: (value) => null,
          onChanged: (value) {
            performSearch(value);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (searchResults.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: recentSearches.map((search) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GlobalUtils.CustomButton(
                            onPressed: () {
                              searchController.text = search;
                              performSearch(search);
                            },
                            text: search,
                            icon: Icon(Icons.history),
                            iconColor: Color(0xff80a8ff),
                            textColor: isDark ? Colors.white : Colors.black87,
                            backgroundColor: isDark ? Color(0xff2a2a2a) : Color(0xfff5f5f5),
                            borderRadius: 20,
                            showBorder: false,
                            animation: ButtonAnimation.scale,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Popular Searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ...['Fruits', 'Vegetables', 'Dairy', 'Snacks'].map((item) {
                      return ListTile(
                        leading: Icon(Icons.trending_up, color: Color(0xff80a8ff)),
                        title: Text(
                          item,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          searchController.text = item;
                          performSearch(item);
                        },
                      );
                    }).toList(),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Search Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final product = searchResults[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xff2a2a2a) : Color(0xfff5f5f5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(product['image'] as IconData, size: 30, color: Colors.grey),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      product['weight'] as String,
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '₹${product['price']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xff80a8ff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GlobalUtils.CustomButton(
                                onPressed: () => cartController.addToCart(product),
                                text: 'ADD',
                                textColor: Colors.white,
                                backgroundColor: Color(0xff80a8ff),
                                borderRadius: 10,
                                showBorder: false,
                                animation: ButtonAnimation.scale,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}