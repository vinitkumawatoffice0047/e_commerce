class ProductDetailsResponseModel {
  bool? error;
  String? message;
  int? errorCode;
  String? state;
  Data? data;

  ProductDetailsResponseModel(
      {this.error, this.message, this.errorCode, this.state, this.data});

  ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    errorCode = json['errorCode'];
    state = json['state'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    data['state'] = this.state;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  int? categoryId;
  String? discription;
  dynamic? price;
  dynamic? discPrice;
  String? slug;
  String? shortDiscription;
  String? image;
  List<String>? images;

  Data(
      {this.id,
        this.title,
        this.categoryId,
        this.discription,
        this.price,
        this.discPrice,
        this.slug,
        this.shortDiscription,
        this.image,
        this.images});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categoryId = json['category_id'];
    discription = json['discription'];
    price = json['price'];
    discPrice = json['disc_price'];
    slug = json['slug'];
    shortDiscription = json['short_discription'];
    image = json['image'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['discription'] = this.discription;
    data['price'] = this.price;
    data['disc_price'] = this.discPrice;
    data['slug'] = this.slug;
    data['short_discription'] = this.shortDiscription;
    data['image'] = this.image;
    data['images'] = this.images;
    return data;
  }
}
