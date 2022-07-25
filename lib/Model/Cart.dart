// ignore_for_file: file_names

const String cart = 'cart';

class CartFields {
  static final List<String> values = [
    /// Add all fields
    // cart_id,
    item_name,
    product_id,
    image,
    amount
  ];

  // static const String cart_id = 'cart_id';
  static const String item_name = 'item_name';
  static const String product_id = 'product_id';
  static const String image = 'image';
  static const String amount = 'amount';
}

class Cart {
  final String item_name;
  final int product_id;
  final String image;
  final String amount;

  const Cart({
    required this.item_name,
    required this.product_id,
    required this.image,
    required this.amount,
  });

  Cart copy(
          {String? item_name,
          int? product_id,
          String? image,
          String? amount}) =>
      Cart(
        item_name: item_name ?? this.item_name,
        product_id: product_id ?? this.product_id,
        image: image ?? this.image,
        amount: amount ?? this.amount,
      );

  static Cart fromJson(Map<String, Object?> json) => Cart(
        item_name: json[CartFields.item_name] as String,
        product_id: json[CartFields.product_id] as int,
        image: json[CartFields.image] as String,
        amount: json[CartFields.amount] as String,
      );

  Map<String, Object?> toJson() => {
        CartFields.item_name: item_name,
        CartFields.product_id: product_id,
        CartFields.image: image,
        CartFields.amount: amount,
      };
}
