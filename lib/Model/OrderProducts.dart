// ignore_for_file: constant_identifier_names, file_names

const String order_products = 'order_products';

class OrderProductFields {
  static final List<String> values = [
    /// Add all fields
    order_cart_id,
    order_product_id,
    order_id,
    order_product_name,
    order_product_amount,
    order_product_image
  ];

  static const String order_cart_id = "cart_id";
  static const String order_product_id = "product_id";
  static const String order_id = "order_id";
  static const String order_product_name = "product_name";
  static const String order_product_amount = "amount";
  static const String order_product_image = "image_name";
}

class OrderProduct {
  final int? order_cart_id;
  final String order_product_id;
  final String order_id;
  final String order_product_name;
  final String order_product_amount;
  final String order_product_image;

  const OrderProduct({
    required this.order_cart_id,
    required this.order_product_id,
    required this.order_id,
    required this.order_product_name,
    required this.order_product_amount,
    required this.order_product_image,
  });

  OrderProduct copy(
          {int? order_cart_id,
          String? order_product_id,
          String? order_id,
          String? order_product_name,
          String? order_product_amount,
          String? order_product_image}) =>
      OrderProduct(
        order_cart_id: order_cart_id ?? this.order_cart_id,
        order_product_id: order_product_id ?? this.order_product_id,
        order_id: order_id ?? this.order_id,
        order_product_name: order_product_name ?? this.order_product_name,
        order_product_amount: order_product_amount ?? this.order_product_amount,
        order_product_image: order_product_image ?? this.order_product_image,
      );

  static OrderProduct fromJson(Map<String, Object?> json) => OrderProduct(
        order_cart_id: json[OrderProductFields.order_cart_id] as int?,
        order_product_id: json[OrderProductFields.order_product_id] as String,
        order_id: json[OrderProductFields.order_id] as String,
        order_product_name:
            json[OrderProductFields.order_product_name] as String,
        order_product_amount:
            json[OrderProductFields.order_product_amount] as String,
        order_product_image:
            json[OrderProductFields.order_product_image] as String,
      );

  Map<String, Object?> toJson() => {
        OrderProductFields.order_cart_id: order_cart_id,
        OrderProductFields.order_product_id: order_product_id,
        OrderProductFields.order_id: order_id,
        OrderProductFields.order_product_name: order_product_name,
        OrderProductFields.order_product_amount: order_product_amount,
        OrderProductFields.order_product_image: order_product_image,
      };
}
