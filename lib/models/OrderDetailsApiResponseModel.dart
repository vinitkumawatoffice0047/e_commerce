class OrderDetailsResponse {
  bool? error;
  String? message;
  int? errorCode;
  String? state;
  OrderData? orderData;
  List<OrderItem>? orderItem;

  OrderDetailsResponse(
      {this.error,
        this.message,
        this.errorCode,
        this.state,
        this.orderData,
        this.orderItem});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    errorCode = json['errorCode'];
    state = json['state'];
    orderData = json['orderData'] != null
        ? new OrderData.fromJson(json['orderData'])
        : null;
    if (json['orderItem'] != null) {
      orderItem = <OrderItem>[];
      json['orderItem'].forEach((v) {
        orderItem!.add(new OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    data['state'] = this.state;
    if (this.orderData != null) {
      data['orderData'] = this.orderData!.toJson();
    }
    if (this.orderItem != null) {
      data['orderItem'] = this.orderItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderData {
  int? id;
  String? userId;
  String? orderId;
  int? payMode;
  dynamic? productId;
  String? userName;
  String? phoneNo;
  int? pinCode;
  String? address;
  dynamic? totalAmount;
  int? isDeliverd;
  int? orderQty;
  int? orderStatus;
  int? deliverType;
  int? paymentStatus;
  dynamic? products;
  String? createdAt;
  String? updatedAt;

  OrderData(
      {this.id,
        this.userId,
        this.orderId,
        this.payMode,
        this.productId,
        this.userName,
        this.phoneNo,
        this.pinCode,
        this.address,
        this.totalAmount,
        this.isDeliverd,
        this.orderQty,
        this.orderStatus,
        this.deliverType,
        this.paymentStatus,
        this.products,
        this.createdAt,
        this.updatedAt});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    payMode = json['pay_mode'];
    productId = json['product_id'];
    userName = json['user_name'];
    phoneNo = json['phone_no'];
    pinCode = json['pin_code'];
    address = json['address'];
    totalAmount = json['total_amount'];
    isDeliverd = json['is_deliverd'];
    orderQty = json['order_qty'];
    orderStatus = json['order_status'];
    deliverType = json['deliver_type'];
    paymentStatus = json['payment_status'];
    products = json['products'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['pay_mode'] = this.payMode;
    data['product_id'] = this.productId;
    data['user_name'] = this.userName;
    data['phone_no'] = this.phoneNo;
    data['pin_code'] = this.pinCode;
    data['address'] = this.address;
    data['total_amount'] = this.totalAmount;
    data['is_deliverd'] = this.isDeliverd;
    data['order_qty'] = this.orderQty;
    data['order_status'] = this.orderStatus;
    data['deliver_type'] = this.deliverType;
    data['payment_status'] = this.paymentStatus;
    data['products'] = this.products;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderItem {
  int? id;
  String? orderId;
  String? productTitle;
  String? productId;
  dynamic? price;
  int? orderQty;
  int? commissionAmt;
  int? affiliateCommission;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  OrderItem(
      {this.id,
        this.orderId,
        this.productTitle,
        this.productId,
        this.price,
        this.orderQty,
        this.commissionAmt,
        this.affiliateCommission,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productTitle = json['product_title'];
    productId = json['product_id'];
    price = json['price'];
    orderQty = json['order_qty'];
    commissionAmt = json['commission_amt'];
    affiliateCommission = json['affiliate_commission'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_title'] = this.productTitle;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['order_qty'] = this.orderQty;
    data['commission_amt'] = this.commissionAmt;
    data['affiliate_commission'] = this.affiliateCommission;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
