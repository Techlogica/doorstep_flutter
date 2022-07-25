// ignore_for_file: file_names

const String address = 'address';

class AddressFields {
  static final List<String> values = [
    /// Add all fields
    address_id,
    full_address,
    flat,
    landmark,
    save_as,
    latitude,
    longitude,
    default_flag
  ];

  static const String address_id = "address_id";
  static const String full_address = "address";
  static const String flat = "flat";
  static const String landmark = "landmark";
  static const String save_as = "save_as";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String default_flag = "default_flag";
}

class Address {
  final int? address_id;
  final String full_address;
  final String flat;
  final String landmark;
  final String save_as;
  final String latitude;
  final String longitude;
  final String default_flag;

  const Address({
    required this.address_id,
    required this.full_address,
    required this.flat,
    required this.landmark,
    required this.save_as,
    required this.latitude,
    required this.longitude,
    required this.default_flag,
  });

  Address copy({
    int? address_id,
    String? full_address,
    String? flat,
    String? landmark,
    String? save_as,
    String? latitude,
    String? longitude,
    String? default_flag,
  }) =>
      Address(
        address_id: address_id ?? this.address_id,
        full_address: full_address ?? this.full_address,
        flat: flat ?? this.flat,
        landmark: landmark ?? this.landmark,
        save_as: save_as ?? this.save_as,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        default_flag: default_flag ?? this.default_flag,
      );

  static Address fromJson(Map<String, Object?> json) => Address(
        address_id: json[AddressFields.address_id] as int?,
        full_address: json[AddressFields.full_address] as String,
        flat: json[AddressFields.flat] as String,
        landmark: json[AddressFields.landmark] as String,
        save_as: json[AddressFields.save_as] as String,
        latitude: json[AddressFields.latitude] as String,
        longitude: json[AddressFields.longitude] as String,
        default_flag: json[AddressFields.default_flag] as String,
      );

  Map<String, Object?> toJson() => {
        AddressFields.address_id: address_id,
        AddressFields.full_address: full_address,
        AddressFields.flat: flat,
        AddressFields.landmark: landmark,
        AddressFields.save_as: save_as,
        AddressFields.latitude: latitude,
        AddressFields.longitude: longitude,
        AddressFields.default_flag: default_flag,
      };
}
