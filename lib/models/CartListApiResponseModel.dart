class CartListScreenResponseModel {
  bool? error;
  String? message;
  int? errorCode;
  String? state;
  List<Data>? data;
  int? cart_item;
  double? total_amt;
  double? actual_amt;
  double? difference_amt;

  CartListScreenResponseModel({this.error, this.message, this.errorCode, this.state, this.data,this.cart_item,this.total_amt,this.actual_amt,this.difference_amt});

  CartListScreenResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    cart_item = json['cart_item'];
    // total_amt = json['total_amt'];
    // actual_amt = json['actual_amt'];
    // difference_amt = json['difference_amt'];
    total_amt = double.parse(json['total_amt'].toString() ?? "0.00");
    actual_amt = double.parse(json['actual_amt'].toString() ?? "0.00");
    difference_amt = double.parse(json['difference_amt'].toString() ?? "0.00");
    message = json['message'];
    errorCode = json['errorCode'];
    state = json['state'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['cart_item'] = this.cart_item;
    data['total_amt'] = this.total_amt;
    data['actual_amt'] = this.actual_amt;
    data['difference_amt'] = this.difference_amt;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    data['state'] = this.state;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  dynamic? affiliatePartner;
  String? cartId;
  String? title;
  String? categoryId;
  String? productId;
  String? shortDiscription;
  String? discription;
  String? slug;
  dynamic? price;
  String? discPrice;
  String? image;
  String? totalProduct;
  int? status;
  dynamic? amount;
  dynamic? coupenCode;
  int? coupenAmount;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;

  Data(
      {this.id,
        this.userId,
        this.affiliatePartner,
        this.cartId,
        this.title,
        this.categoryId,
        this.productId,
        this.shortDiscription,
        this.discription,
        this.slug,
        this.price,
        this.discPrice,
        this.image,
        this.totalProduct,
        this.status,
        this.amount,
        this.coupenCode,
        this.coupenAmount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    affiliatePartner = json['affiliate_partner'];
    cartId = json['cart_id'];
    title = json['title'];
    categoryId = json['category_id'];
    productId = json['product_id'];
    shortDiscription = json['short_discription'];
    discription = json['discription'];
    slug = json['slug'];
    price = json['price'];
    discPrice = json['disc_price'];
    image = json['image'];
    totalProduct = json['total_product'];
    status = json['status'];
    amount = json['amount'];
    coupenCode = json['coupen_code'];
    coupenAmount = json['coupen_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['affiliate_partner'] = this.affiliatePartner;
    data['cart_id'] = this.cartId;
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['product_id'] = this.productId;
    data['short_discription'] = this.shortDiscription;
    data['discription'] = this.discription;
    data['slug'] = this.slug;
    data['price'] = this.price;
    data['disc_price'] = this.discPrice;
    data['image'] = this.image;
    data['total_product'] = this.totalProduct;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['coupen_code'] = this.coupenCode;
    data['coupen_amount'] = this.coupenAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
