// ignore_for_file: file_names

const String favourites = 'favourites';

class FavouritesFields {
  static final List<String> values = [
    /// Add all fields
    fav_name,
    fav_image,
    fav_withdrawal,
    fav_product_id
  ];

  static const String fav_name = "item_name";
  static const String fav_image = "item_image";
  static const String fav_withdrawal = "item_withdrawal";
  static const String fav_product_id = "product_id";
}

class Favourites {
  final String? fav_name;
  final String fav_image;
  final String fav_withdrawal;
  final int fav_product_id;

  const Favourites({
    required this.fav_name,
    required this.fav_image,
    required this.fav_withdrawal,
    required this.fav_product_id,
  });

  Favourites copy({
    String? fav_name,
    String? fav_image,
    String? fav_withdrawal,
    int? fav_product_id,
  }) =>
      Favourites(
        fav_name: fav_name ?? this.fav_name,
        fav_image: fav_image ?? this.fav_image,
        fav_withdrawal: fav_withdrawal ?? this.fav_withdrawal,
        fav_product_id: fav_product_id ?? this.fav_product_id,
      );

  static Favourites fromJson(Map<String, Object?> json) => Favourites(
        fav_name: json[FavouritesFields.fav_name] as String?,
        fav_image: json[FavouritesFields.fav_image] as String,
        fav_withdrawal: json[FavouritesFields.fav_withdrawal] as String,
        fav_product_id: json[FavouritesFields.fav_product_id] as int,
      );

  Map<String, Object?> toJson() => {
        FavouritesFields.fav_name: fav_name,
        FavouritesFields.fav_image: fav_image,
        FavouritesFields.fav_withdrawal: fav_withdrawal,
        FavouritesFields.fav_product_id: fav_product_id,
      };
}
