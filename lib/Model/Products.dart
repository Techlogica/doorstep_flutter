// ignore_for_file: file_names

import 'package:doorstep_banking_flutter/utils/Category.dart';

final String products = 'products';

class ProductsFields {
  static final List<String> values = [
    /// Add all fields
    product_id,
    product_name_en,
    product_image_active,
    product_image_inactive,
    product_cart_flag,
    product_wishlist_flag,
    product_name_hi,
    product_name_ml,
    product_name_mr,
    product_name_ta
  ];

  static final String product_id = 'product_id';
  static final String product_name_en = 'product_name_en';
  static final String product_image_active = 'product_image_active';
  static final String product_image_inactive = 'product_image_inactive';
  static final String product_cart_flag = 'cart_flag';
  static final String product_wishlist_flag = 'wishlist_flag';
  static final String product_name_hi = 'product_name_hi';
  static final String product_name_ml = 'product_name_ml';
  static final String product_name_mr = 'product_name_mr';
  static final String product_name_ta = 'product_name_ta';
}

class Products {
  final int? product_id;
  final String product_name_en;
  final String product_image_active;
  final String product_image_inactive;
  final String product_cart_flag;
  final String product_wishlist_flag;
  final String product_name_hi;
  final String product_name_ml;
  final String product_name_mr;
  final String product_name_ta;

  const Products({
    required this.product_id,
    required this.product_name_en,
    required this.product_image_active,
    required this.product_image_inactive,
    required this.product_cart_flag,
    required this.product_wishlist_flag,
    required this.product_name_hi,
    required this.product_name_ml,
    required this.product_name_mr,
    required this.product_name_ta,
  });

  Products copy(
          {int? product_id,
          String? product_name_en,
          String? product_image_active,
          String? product_image_inactive,
          String? product_cart_flag,
          String? product_wishlist_flag,
          String? product_name_hi,
          String? product_name_ml,
          String? product_name_mr,
          String? product_name_ta}) =>
      Products(
        product_id: product_id ?? this.product_id,
        product_name_en: product_name_en ?? this.product_name_en,
        product_image_active: product_image_active ?? this.product_image_active,
        product_image_inactive:
            product_image_inactive ?? this.product_image_inactive,
        product_cart_flag: product_cart_flag ?? this.product_cart_flag,
        product_wishlist_flag:
            product_wishlist_flag ?? this.product_wishlist_flag,
        product_name_hi: product_name_hi ?? this.product_name_hi,
        product_name_ml: product_name_ml ?? this.product_name_ml,
        product_name_mr: product_name_mr ?? this.product_name_mr,
        product_name_ta: product_name_ta ?? this.product_name_ta,
      );

  static Products fromJson(Map<String, Object?> json) => Products(
        product_id: json[ProductsFields.product_id] as int?,
        product_name_en: json[ProductsFields.product_name_en] as String,
        product_image_active:
            json[ProductsFields.product_image_active] as String,
        product_image_inactive:
            json[ProductsFields.product_image_inactive] as String,
        product_cart_flag: json[ProductsFields.product_cart_flag] as String,
        product_wishlist_flag:
            json[ProductsFields.product_wishlist_flag] as String,
        product_name_hi: json[ProductsFields.product_name_hi] as String,
        product_name_ml: json[ProductsFields.product_name_ml] as String,
        product_name_mr: json[ProductsFields.product_name_mr] as String,
        product_name_ta: json[ProductsFields.product_name_ta] as String,
      );

  Map<String, Object?> toJson() => {
        ProductsFields.product_id: product_id,
        ProductsFields.product_name_en: product_name_en,
        ProductsFields.product_image_active: product_image_active,
        ProductsFields.product_image_inactive: product_image_inactive,
        ProductsFields.product_cart_flag: product_cart_flag,
        ProductsFields.product_wishlist_flag: product_wishlist_flag,
        ProductsFields.product_name_hi: product_name_hi,
        ProductsFields.product_name_ml: product_name_ml,
        ProductsFields.product_name_mr: product_name_mr,
        ProductsFields.product_name_ta: product_name_ta,
      };
}
