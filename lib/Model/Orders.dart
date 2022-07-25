// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_declarations, constant_identifier_names
const String orders = 'orders';

class OrdersFields {
  static final List<String> values = [
    /// Add all fields
    order_id,
    order_number,
    order_status,
    order_address_id,
    order_full_address,
    order_address_type,
    order_flat,
    order_landmark,
    order_latitude,
    order_longitude,
    order_otp,
    order_custom_note,
    order_delivery_charge,
    order_rating,
    order_review,
    order_date,
    order_total_pages
  ];

  static const String order_id = "order_id";
  static const String order_number = "order_number";
  static const String order_status = "order_status";
  static const String order_address_id = "address_id";
  static const String order_full_address = "full_address";
  static const String order_address_type = "address_type";
  static const String order_flat = "building_type";
  static const String order_landmark = "landmark";
  static const String order_latitude = "latitude";
  static const String order_longitude = "longitude";
  static const String order_otp = "otp";
  static const String order_custom_note = "custom_notes";
  static const String order_delivery_charge = "delivery_charge";
  static const String order_rating = "rating";
  static const String order_review = "review";
  static const String order_date = "order_date";
  static const String order_total_pages = "total_pages";
}

class Orders {
  final int? order_id;
  final String order_number;
  final String order_status;
  final String order_address_id;
  final String order_full_address;
  final String order_address_type;
  final String order_flat;
  final String order_landmark;
  final String order_latitude;
  final String order_longitude;
  final String order_otp;
  final String order_custom_note;
  final String order_delivery_charge;
  final String order_rating;
  final String order_review;
  final String order_date;
  final String order_total_pages;

  const Orders({
    required this.order_id,
    required this.order_number,
    required this.order_status,
    required this.order_address_id,
    required this.order_full_address,
    required this.order_address_type,
    required this.order_flat,
    required this.order_landmark,
    required this.order_latitude,
    required this.order_longitude,
    required this.order_otp,
    required this.order_custom_note,
    required this.order_delivery_charge,
    required this.order_rating,
    required this.order_review,
    required this.order_date,
    required this.order_total_pages,
  });

  Orders copy(
          {int? order_id,
          String? order_number,
          String? order_status,
          String? order_address_id,
          String? order_full_address,
          String? order_address_type,
          String? order_flat,
          String? order_landmark,
          String? order_latitude,
          String? order_longitude,
          String? order_otp,
          String? order_custom_note,
          String? order_delivery_charge,
          String? order_rating,
          String? order_review,
          String? order_date,
          String? order_total_pages}) =>
      Orders(
        order_id: order_id ?? this.order_id,
        order_number: order_number ?? this.order_number,
        order_status: order_status ?? this.order_status,
        order_address_id: order_address_id ?? this.order_address_id,
        order_full_address: order_full_address ?? this.order_full_address,
        order_address_type: order_address_type ?? this.order_address_type,
        order_flat: order_flat ?? this.order_flat,
        order_landmark: order_landmark ?? this.order_landmark,
        order_latitude: order_latitude ?? this.order_latitude,
        order_longitude: order_longitude ?? this.order_longitude,
        order_otp: order_otp ?? this.order_otp,
        order_custom_note: order_custom_note ?? this.order_custom_note,
        order_delivery_charge:
            order_delivery_charge ?? this.order_delivery_charge,
        order_rating: order_rating ?? this.order_rating,
        order_review: order_review ?? this.order_review,
        order_date: order_date ?? this.order_date,
        order_total_pages: order_total_pages ?? this.order_total_pages,
      );

  static Orders fromJson(Map<String, Object?> json) => Orders(
        order_id: json[OrdersFields.order_id] as int?,
        order_number: json[OrdersFields.order_number] as String,
        order_status: json[OrdersFields.order_status] as String,
        order_address_id: json[OrdersFields.order_address_id] as String,
        order_full_address: json[OrdersFields.order_full_address] as String,
        order_address_type: json[OrdersFields.order_address_type] as String,
        order_flat: json[OrdersFields.order_flat] as String,
        order_landmark: json[OrdersFields.order_landmark] as String,
        order_latitude: json[OrdersFields.order_latitude] as String,
        order_longitude: json[OrdersFields.order_longitude] as String,
        order_otp: json[OrdersFields.order_otp] as String,
        order_custom_note: json[OrdersFields.order_custom_note] as String,
        order_delivery_charge:
            json[OrdersFields.order_delivery_charge] as String,
        order_rating: json[OrdersFields.order_rating] as String,
        order_review: json[OrdersFields.order_review] as String,
        order_date: json[OrdersFields.order_date] as String,
        order_total_pages: json[OrdersFields.order_total_pages] as String,
      );

  Map<String, Object?> toJson() => {
        OrdersFields.order_id: order_id,
        OrdersFields.order_number: order_number,
        OrdersFields.order_status: order_status,
        OrdersFields.order_address_id: order_address_id,
        OrdersFields.order_full_address: order_full_address,
        OrdersFields.order_address_type: order_address_type,
        OrdersFields.order_flat: order_flat,
        OrdersFields.order_landmark: order_landmark,
        OrdersFields.order_latitude: order_latitude,
        OrdersFields.order_longitude: order_longitude,
        OrdersFields.order_otp: order_otp,
        OrdersFields.order_custom_note: order_custom_note,
        OrdersFields.order_delivery_charge: order_delivery_charge,
        OrdersFields.order_rating: order_rating,
        OrdersFields.order_review: order_review,
        OrdersFields.order_date: order_date,
        OrdersFields.order_total_pages: order_total_pages,
      };
}
