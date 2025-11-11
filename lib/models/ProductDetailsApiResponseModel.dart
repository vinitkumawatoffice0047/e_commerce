class ProductDetailsResponseModel {
  bool? error;
  String? message;
  int? errorCode;
  String? state;
  ProductDetailsResponseData? data;

  ProductDetailsResponseModel(
      {this.error, this.message, this.errorCode, this.state, this.data});

  ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    errorCode = json['errorCode'];
    state = json['state'];
    data = json['data'] != null ? new ProductDetailsResponseData.fromJson(json['data']) : null;
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

class ProductDetailsResponseData {
  int? id;
  String? title;
  dynamic? categoryId;
  dynamic? product_id;
  String? discription;
  dynamic? price;
  dynamic? discPrice;
  String? slug;
  int? stock;
  String? shortDiscription;
  String? image;
  List<String>? images;

  ProductDetailsResponseData(
      {this.id,
        this.title,
        this.categoryId,
        this.discription,
        this.price,
        this.discPrice,
        this.product_id,
        this.slug,
        this.stock,
        this.shortDiscription,
        this.image,
        this.images});

  ProductDetailsResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'].toString();
    categoryId = json['category_id'].toString();
    product_id = json['product_id'].toString();
    discription = json['discription'].toString();
    price = json['price'].toString();
    discPrice = json['disc_price'].toString();
    slug = json['slug'].toString();
    stock = json['stock'];
    shortDiscription = json['short_discription'].toString();
    image = json['image'].toString();
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
    data['stock'] = this.stock;
    data['short_discription'] = this.shortDiscription;
    data['product_id'] = this.product_id;
    data['image'] = this.image;
    data['images'] = this.images;
    return data;
  }
}
