
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const isLogin = "isLogin";
  static const isIntro = "isIntro";
  static const usertype = "usertype";
  static const token = "token";
  static const userID = "userID";
  static const mobileNo = "mobileNo";
  static const userName = "userName";
  static const otpToken = "otpToken";
  static const userData = "userData";
  static const userProfile = "userProfile";
  static const kycStatus = "kycStatus";
  static const walletBalance = "walletBalance";
  static String lastAddress = "";
  static String lastPincode = "";

  // Data? data;
  // User? user;
  //
  // Future<bool> setUserDetails(Data dictData) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString(userData, json.encode(dictData));
  //   PrintLog.printLog(json.encode(dictData));
  //   return true;
  // }
  // Future<Data> getUserDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   data = Data.fromJson(json.decode(prefs.getString(userData) ?? ""));
  //   PrintLog.printLog(json.encode(data));
  //   return data!;
  // }
  Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }
  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
  Future<bool> setUserDetails1(Map<String, dynamic> dictData) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userProfile, json.encode(dictData));
    print(json.encode(dictData));
    return true;
  }

  Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return true;
  }
  // Future<User> getUserDetails1() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   user = User.fromJson(json.decode(prefs.getString(userProfile) ?? ""));
  //   PrintLog.printLog(json.encode(data));
  //   return user!;
  // }
}