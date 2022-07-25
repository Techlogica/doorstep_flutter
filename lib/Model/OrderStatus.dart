// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names

const String order_status = 'order_status';

class OrderStatusFields {
  static final List<String> values = [
    /// Add all fields
    order_status_id,
    order_status,
    order_status_date
  ];

  static const String order_status_id = "order_id";
  static const String order_status = "order_status";
  static const String order_status_date = "order_date";
}

class OrderStatus {
  final String? order_status_id;
  final String order_status;
  final String order_status_date;

  const OrderStatus({
    required this.order_status_id,
    required this.order_status,
    required this.order_status_date,
  });

  OrderStatus copy(
          {String? order_status_id,
          String? order_status,
          String? order_status_date}) =>
      OrderStatus(
        order_status_id: order_status_id ?? this.order_status_id,
        order_status: order_status ?? this.order_status,
        order_status_date: order_status_date ?? this.order_status_date,
      );

  static OrderStatus fromJson(Map<String, Object?> json) => OrderStatus(
        order_status_id: json[OrderStatusFields.order_status_id] as String?,
        order_status: json[OrderStatusFields.order_status] as String,
        order_status_date: json[OrderStatusFields.order_status_date] as String,
      );

  Map<String, Object?> toJson() => {
        OrderStatusFields.order_status_id: order_status_id,
        OrderStatusFields.order_status: order_status,
        OrderStatusFields.order_status_date: order_status_date,
      };
}
