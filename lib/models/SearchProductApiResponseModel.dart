class SearchResponseApi {
  SearchResponseApi({
    required this.error,
    required this.message,
    required this.errorCode,
    required this.state,
    required this.data,
  });

  final bool? error;
  final String? message;
  final int? errorCode;
  final String? state;
  final SearchData? data;

  factory SearchResponseApi.fromJson(Map<String, dynamic> json){
    return SearchResponseApi(
      error: json["error"],
      message: json["message"],
      errorCode: json["errorCode"],
      state: json["state"],
      data: json["data"] == null ? null : SearchData.fromJson(json["data"]),
    );
  }

}

class SearchData {
  SearchData({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.discription,
    required this.price,
    required this.discPrice,
    required this.slug,
    required this.shortDiscription,
    required this.image,
  });

  final int? id;
  final String? title;
  final int? categoryId;
  final String? discription;
  final int? price;
  final double? discPrice;
  final String? slug;
  final String? shortDiscription;
  final String? image;

  factory SearchData.fromJson(Map<String, dynamic> json){
    return SearchData(
      id: json["id"],
      title: json["title"],
      categoryId: json["category_id"],
      discription: json["discription"],
      price: json["price"],
      discPrice: json["disc_price"],
      slug: json["slug"],
      shortDiscription: json["short_discription"],
      image: json["image"],
    );
  }

}
