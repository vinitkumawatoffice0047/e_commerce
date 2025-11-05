import 'package:e_commerce_app/utils/ConsoleLog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final isDarkMode = false.obs;
  
  // get val => festivalThemes;
  //
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   ConsoleLog.printColor("===============${val["diwali"]["name"]}", color: "yellow");
  // }

  final festivalThemes = {
    'diwali': {
      'icon': '🪔',
      'name': 'Diwali Special',
      'colors': [Color(0xffff9933), Color(0xffffd700), Color(0xffff6b35)],
    },
    'holi': {
      'icon': '🎨',
      'name': 'Holi Dhamaka',
      'colors': [Color(0xffff006e), Color(0xff8338ec), Color(0xff3a86ff)],
    },
    'navratri': {
      'icon': '🕉️',
      'name': 'Navratri Celebration',
      'colors': [Color(0xffff006e), Color(0xfffffb00), Color(0xff06ffa5)],
    },
    'janmashtami': {
      'icon': '🦚',
      'name': 'Janmashtami Joy',
      'colors': [Color(0xff4361ee), Color(0xff7209b7), Color(0xfff72585)],
    },
    'rakhi': {
      'icon': '🧵',
      'name': 'Raksha Bandhan',
      'colors': [Color(0xffff6b6b), Color(0xfffeca57), Color(0xff48dbfb)],
    },
    'ganesh': {
      'icon': '🐘',
      'name': 'Ganesh Chaturthi',
      'colors': [Color(0xfffe9920), Color(0xfffeca57), Color(0xffee5a6f)],
    },
  };

  // final categoryThemes = {
  //   'Grocery': {
  //     'colors': [Color(0xff06ffa5), Color(0xff00d9ff)],
  //     'icon': Icons.shopping_basket,
  //   },
  //   'Electronics': {
  //     'colors': [Color(0xff80a8ff), Color(0xff5e60ce)],
  //     'icon': Icons.phone_android,
  //   },
  //   'Fashion': {
  //     'colors': [Color(0xffff006e), Color(0xffffbe0b)],
  //     'icon': Icons.checkroom,
  //   },
  //   'Home & Kitchen': {
  //     'colors': [Color(0xffffabab), Color(0xffff6b6b)],
  //     'icon': Icons.home,
  //   },
  //   'Beauty': {
  //     'colors': [Color(0xffff99c8), Color(0xfffcf6bd)],
  //     'icon': Icons.spa,
  //   },
  //   'Sports': {
  //     'colors': [Color(0xff4895ef), Color(0xff4cc9f0)],
  //     'icon': Icons.sports_basketball,
  //   },
  //   'Books': {
  //     'colors': [Color(0xff9d4edd), Color(0xffc77dff)],
  //     'icon': Icons.menu_book,
  //   },
  //   'Toys': {
  //     'colors': [Color(0xffff6b9d), Color(0xffffc6ff)],
  //     'icon': Icons.toys,
  //   },
  // };

  // // Predefined themes jo pehle se bani hui hain
  // final Map<String, Map<String, dynamic>> _predefinedCategoryThemes = {
  //   'Grocery': {
  //     'colors': [Color(0xff06ffa5), Color(0xff00d9ff)],
  //     'icon': Icons.shopping_basket,
  //   },
  //   'Electronics': {
  //     'colors': [Color(0xff80a8ff), Color(0xff5e60ce)],
  //     'icon': Icons.phone_android,
  //   },
  //   'Fashion': {
  //     'colors': [Color(0xffff006e), Color(0xffffbe0b)],
  //     'icon': Icons.checkroom,
  //   },
  //   'Home & Kitchen': {
  //     'colors': [Color(0xffffabab), Color(0xffff6b6b)],
  //     'icon': Icons.home,
  //   },
  //   'Beauty': {
  //     'colors': [Color(0xffff99c8), Color(0xfffcf6bd)],
  //     'icon': Icons.spa,
  //   },
  //   'Sports': {
  //     'colors': [Color(0xff4895ef), Color(0xff4cc9f0)],
  //     'icon': Icons.sports_basketball,
  //   },
  //   'Books': {
  //     'colors': [Color(0xff9d4edd), Color(0xffc77dff)],
  //     'icon': Icons.menu_book,
  //   },
  //   'Toys': {
  //     'colors': [Color(0xffff6b9d), Color(0xffffc6ff)],
  //     'icon': Icons.toys,
  //   },
  // };

  // Ye color palettes automatically categories ko assign honge
  final List<List<Color>> _colorPalettes = [
    [Color(0xff06ffa5), Color(0xff00d9ff)], // Green-Cyan
    [Color(0xff80a8ff), Color(0xff5e60ce)], // Blue-Purple
    [Color(0xffff006e), Color(0xffffbe0b)], // Pink-Yellow
    [Color(0xffffabab), Color(0xffff6b6b)], // Light Red-Red
    [Color(0xffff99c8), Color(0xfffcf6bd)], // Pink-Cream
    [Color(0xff4895ef), Color(0xff4cc9f0)], // Blue-Cyan
    [Color(0xff9d4edd), Color(0xffc77dff)], // Purple-Light Purple
    [Color(0xffff6b9d), Color(0xffffc6ff)], // Pink-Light Pink
    [Color(0xfffe9920), Color(0xfffeca57)], // Orange-Yellow
    [Color(0xff4361ee), Color(0xff7209b7)], // Blue-Purple
    [Color(0xffff006e), Color(0xff8338ec)], // Pink-Purple
    [Color(0xff06ffa5), Color(0xfffffb00)], // Green-Yellow
    [Color(0xffff6b35), Color(0xffffd700)], // Orange-Gold
    [Color(0xff48dbfb), Color(0xffff6b6b)], // Cyan-Red
    [Color(0xffee5a6f), Color(0xfffeca57)], // Red-Yellow
  ];

  // Ye icons automatically categories ko assign honge
  final List<IconData> _iconsList = [
    Icons.shopping_basket,
    Icons.phone_android,
    Icons.checkroom,
    Icons.home,
    Icons.spa,
    Icons.sports_basketball,
    Icons.menu_book,
    Icons.toys,
    Icons.watch,
    Icons.kitchen,
    Icons.pets,
    Icons.directions_car,
    Icons.fitness_center,
    Icons.music_note,
    Icons.camera_alt,
    Icons.restaurant,
    Icons.laptop,
    Icons.bed,
    Icons.child_care,
    Icons.local_pharmacy,
  ];

  // Category theme ko get karne ka main function
  Map<String, dynamic> getCategoryTheme(String categoryName, String categoryImage, {int? index}) {
    // // Pehle check karo ki predefined theme hai ya nahi
    // if (_predefinedCategoryThemes.containsKey(categoryName)) {
    //   return _predefinedCategoryThemes[categoryName]!;
    // }

    // Agar nahi hai to dynamic generate karo
    return _generateThemeForCategory(categoryName, categoryImage, index);
  }

  // Dynamic theme generate karne ka function
  Map<String, dynamic> _generateThemeForCategory(String categoryName, String categoryImage, int? index) {
    // Category name se consistent hash generate karo
    int hash = _generateHash(categoryName);

    // Agar index available hai to use bhi consider karo
    if (index != null) {
      hash = (hash + index) % 1000000;
    }

    // Hash se color palette aur icon select karo
    int colorIndex = hash % _colorPalettes.length;
    // int iconIndex = hash % _iconsList.length;

    return {
      'colors': _colorPalettes[colorIndex],
      'image': categoryImage,
      // 'icon': _iconsList[iconIndex],
    };
  }

  // String se consistent hash generate karne ka function
  int _generateHash(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = ((hash << 5) - hash) + text.codeUnitAt(i);
      hash = hash & hash; // Convert to 32bit integer
    }
    return hash.abs();
  }



  String getCurrentFestival() {
    final month = DateTime.now().month;
    final day = DateTime.now().day;

    if ((month == 10 && day >= 20) || (month == 11 && day <= 15)) return 'diwali';
    if (month == 3 && day >= 15 && day <= 25) return 'holi';
    if ((month == 9 && day >= 15) || (month == 10 && day <= 10)) return 'navratri';
    if (month == 8 && day >= 20 && day <= 30) return 'janmashtami';
    if (month == 8 && day >= 1 && day <= 15) return 'rakhi';
    if (month == 9 && day >= 1 && day <= 15) return 'ganesh';

    return 'default';
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
