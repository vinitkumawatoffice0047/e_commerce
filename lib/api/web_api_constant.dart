
class WebApiConstant{
  static const String BASE_URL                                 =  "https://groticshop.com/api/v1/"; //Live

  static const String API_URL_LOGIN                            = BASE_URL + "user/login";                    //Done
  static const String API_URL_SIGNUP                           = BASE_URL + "user/register";                 //Done
  static const String API_URL_HOME_DETAIL                      = BASE_URL + "user/home";                     //Done
  static const String API_URL_HOME_PRODUCT_DETAILS             = BASE_URL + "user/get-product-detail";       //Pending1
  static const String API_URL_ADD_TO_CART                      = BASE_URL + "user/add-to-cart";              //Pending2
  static const String API_URL_DELETE_TO_CART                   = BASE_URL + "user/delete-to-cart";           //Pending3
  static const String API_URL_CART_LIST                        = BASE_URL + "user/cart";                     //Pending4
  static const String API_URL_CATEGORY_TO_PRODUCT              = BASE_URL + "cate-to-product";               //Pending5
  static const String API_URL_PROFILE                          = BASE_URL + "user/profile";                  //Pending6
  static const String API_URL_UPDATE_PASSWORD                  = BASE_URL +"user/change-password";           //Pending7
  // static const String API_URL_ADD_ADDRESS                      = BASE_URL +"user/change-address";            //Pending(Not Used)
  static const String API_URL_GET_ADDRESS                      = BASE_URL +"user/address";                   //Pending8
  static const String API_URL_CHANGE_ADDRESS                   = BASE_URL +"user/change-address";            //Pending9
  static const String API_URL_BUY_NOW                          = BASE_URL +"user/buy-now";                   //Pending10
  static const String API_URL_MY_ORDER                         = BASE_URL +"user/my-order";                  //Pending11
  static const String API_URL_DELETE_ORDER                     = BASE_URL +"user/order-delete";              //Pending12
  static const String API_URL_SEARCH_PRODUCT                   = BASE_URL +"search-product";                 //Pending13
  static const String API_URL_CATEGORY                         = BASE_URL +"user/category";                  //Pending14
  static const String API_URL_RAZORPAY_DEPOSIT                 = BASE_URL +"user/razorpay-deposit";          //Pending15
  static const String API_URL_OREDER_DETAILS_LIST              = BASE_URL +"user/order-detail";              //Pending16
  static const String API_URL_NOTIFICATION                     = BASE_URL + "user/notification";             //Pending17


  // Error Msg
  static const String ApiError                                 = "Something went wrong, Please try again later";
  static const String user_id_NoError                          = "Enter valid MobileNo or Email";
  static const String Bank_Name_NoError                        = "Enter valid Bank Name";
  static const String Amount_NoError                           = "Enter Valid Amount";
  static const String TPinError                                = "Enter Valid T-Pin";
  static const String Mobile_NoError                           = "Enter Valid Mobile Number";
  static const String account_No_NoError                       = "Enter valid Account Number";
  static const String Ifsc_No_NoError                          = "Enter valid IFSC Number";
  static const String password_NoError                         = "Enter valid password";
  static const String NameError                                = "Enter valid name";
  static const String EmailError                               = "Enter valid email";
  static const String PasswordError                            = "Enter minimum 8 character password";
  static const String TermsConditionError                      = "Please agree with our terms & conditions";
  static const String OtpError                                 = "Enter 4 digits Otp";
  static const String StateError                               = "Enter valid state";
  static const String CityError                                = "Enter valid city";
  static const String AddressError                             = "Enter valid address";
  static const String PinCodeError                             = "Enter valid pin code";
}