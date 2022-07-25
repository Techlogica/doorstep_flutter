// ignore_for_file: file_names, deprecated_member_use
// @dart=2.9

import 'package:doorstep_banking_flutter/Model/Address.dart';
import 'package:doorstep_banking_flutter/Model/AgentLocations.dart';
import 'package:doorstep_banking_flutter/Model/Cart.dart';
import 'package:doorstep_banking_flutter/Model/Favourites.dart';
import 'package:doorstep_banking_flutter/Model/OrderProducts.dart';
import 'package:doorstep_banking_flutter/Model/OrderStatus.dart';
import 'package:doorstep_banking_flutter/Model/Orders.dart';
import 'package:doorstep_banking_flutter/Model/Products.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DSDatabase {
  static final DSDatabase instance = DSDatabase._init();
  static Database _database;

  DSDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('doorstep.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const autoIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const boolType = 'BOOLEAN';
    const integerType = 'INTEGER';
    const textnotNull = 'TEXT NOT NULL';
    const integernotNull = 'INTEGER NOT NULL';
    const intergetAutonotNull = 'INTEGER AUTOINCREMENT';

    await db.execute("CREATE TABLE $products ("
        "${ProductsFields.product_id} $integerType,"
        "${ProductsFields.product_name_en} $textType,"
        "${ProductsFields.product_image_active} $textType,"
        "${ProductsFields.product_image_inactive} $textType,"
        "${ProductsFields.product_cart_flag} $textType,"
        "${ProductsFields.product_wishlist_flag} $textType,"
        "${ProductsFields.product_name_hi} $textType,"
        "${ProductsFields.product_name_ml} $textType,"
        "${ProductsFields.product_name_mr} $textType,"
        "${ProductsFields.product_name_ta} $textType"
        ")");
    await db.execute("CREATE TABLE $cart ("
        '${CartFields.product_id} $integerType,'
        '${CartFields.item_name} $textType,'
        '${CartFields.image} $textType,'
        '${CartFields.amount} $textType,'
        'cart_id $autoIdType'
        ")");
    await db.execute("CREATE TABLE $address ("
        "${AddressFields.address_id} $integernotNull,"
        "${AddressFields.full_address} $textnotNull,"
        "${AddressFields.flat} $textType,"
        "${AddressFields.landmark} $textType,"
        "${AddressFields.save_as} $textType,"
        "${AddressFields.latitude} $textnotNull,"
        "${AddressFields.longitude} $textnotNull,"
        "${AddressFields.default_flag} $textType"
        ")");
    await db.execute("CREATE TABLE $favourites ("
        "${FavouritesFields.fav_product_id} $integerType,"
        "${FavouritesFields.fav_name} $textType,"
        "${FavouritesFields.fav_image} $textType,"
        "${FavouritesFields.fav_withdrawal} $textType,"
        'favour_id $autoIdType'
        ")");
    await db.execute("CREATE TABLE $orders ("
        "${OrdersFields.order_id} $integerType,"
        "${OrdersFields.order_number} $textType,"
        "${OrdersFields.order_status} $textType,"
        "${OrdersFields.order_address_id} $textType,"
        "${OrdersFields.order_full_address} $textType,"
        "${OrdersFields.order_address_type} $textType,"
        "${OrdersFields.order_flat} $textType,"
        "${OrdersFields.order_landmark} $textType,"
        "${OrdersFields.order_latitude} $textType,"
        "${OrdersFields.order_longitude} $textType,"
        "${OrdersFields.order_otp} $textType,"
        "${OrdersFields.order_custom_note} $textType,"
        "${OrdersFields.order_delivery_charge} $textType,"
        "${OrdersFields.order_rating} $textType,"
        "${OrdersFields.order_review} $textType,"
        "${OrdersFields.order_date} $textType,"
        "${OrdersFields.order_total_pages} $textType,"
        "order_auto_id $autoIdType"
        ")");
    await db.execute("CREATE TABLE $order_products ("
        "${OrderProductFields.order_cart_id} $integerType, "
        "${OrderProductFields.order_product_id} $textType,"
        "${OrderProductFields.order_id} $textType,"
        "${OrderProductFields.order_product_name} $textType,"
        "${OrderProductFields.order_product_amount} $textType,"
        "${OrderProductFields.order_product_image} $textType,"
        "tb_id $autoIdType"
        ")");
    await db.execute("CREATE TABLE $agent_locations ("
        "${AgentLocationsFields.agent_name} $textType, "
        "${AgentLocationsFields.agent_latitude} $textType,"
        "${AgentLocationsFields.agent_longitude} $textType,"
        "location_id $idType"
        ")");
    await db.execute("CREATE TABLE $order_status ("
        "${OrderStatusFields.order_status_id} $integerType, "
        "${OrderStatusFields.order_status} $textType,"
        "${OrderStatusFields.order_status_date} $textType"
        ")");
  }

  //------------------------Products--------------------------------//
  // Future<Note> create(Note note) async {
  //   final db = await instance.database;
  //
  //   // final json = note.toJson();
  //   // final columns =
  //   //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
  //   // final values =
  //   //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
  //   // final id = await db
  //   //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
  //
  //   final id = await db.insert(tableNotes, note.toJson());
  //   return note.copy(id: id);
  // }

  // create product table
  Future<Products> insertToProducts(Products productsTable) async {
    final db = await instance.database;
    int productId = productsTable.product_id;
    final result = await db
        .rawQuery("SELECT * FROM products WHERE product_id='$productId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(products, productsTable.toJson());
      return productsTable.copy(product_id: id);
    }
  }

  // Future<List<Note>> readAllNotes() async {
  //   final db = await instance.database;
  //
  //   final orderBy = '${NoteFields.time} ASC';
  //   // final result =
  //   //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
  //
  //   final result = await db.query(tableNotes, orderBy: orderBy);
  //
  //   return result.map((json) => Note.fromJson(json)).toList();
  // }

  //get all products table data
  Future<List<Products>> readAllProducts() async {
    final db = await instance.database;
    final orderBy = '${ProductsFields.product_id} ASC';
    final result = await db.query(products, orderBy: orderBy);
    return result.map((json) => Products.fromJson(json)).toList();
  }

  // Future<Note> readNote(int id) async {
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableNotes,
  //     columns: NoteFields.values,
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [id],
  //   );
  //
  //   if (maps.isNotEmpty) {
  //     return Note.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }

  //get specific product name
  Future<String> getProductName(int productId, String language) async {
    final db = await instance.database;
    if (language == 'hi') {
      final maps = await db.query(
        products,
        columns: ProductsFields.values,
        where: '${ProductsFields.product_id} = ?',
        whereArgs: [productId],
      );
      String productName = "";
      if (maps.isNotEmpty) {
        if (language == 'hi') {
          productName = Products.fromJson(maps.first).product_name_hi;
        } else if (language == 'ml') {
          productName = Products.fromJson(maps.first).product_name_ml;
        } else if (language == 'mr') {
          productName = Products.fromJson(maps.first).product_name_mr;
        } else if (language == 'ta') {
          productName = Products.fromJson(maps.first).product_name_ta;
        } else {
          productName = Products.fromJson(maps.first).product_name_en;
        }
        return productName;
      } else {
        throw Exception('ID $productId not found');
      }
    }
  }

  //product table row count
  Future<int> countProducts() async {
    var db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM products'));
    // assert(count == 2);
    return count;
  }

  // Future<int> update(Note note) async {
  //   final db = await instance.database;
  //
  //   return db.update(
  //     tableNotes,
  //     note.toJson(),
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [note.id],
  //   );
  // }

  //update home products
  Future<void> updateHomeProducts(
      int productId, String cartFlag, String wishlistFlag) async {
    final db = await instance.database;

    final map = {'cart_flag': '$cartFlag', 'wishlist_flag': '$wishlistFlag'};

    return db.update(
      products,
      map,
      where: '${ProductsFields.product_id} = ?',
      whereArgs: [productId],
    );
  }

  //update home products wishlists
  Future<void> updateHomeProductsWishlist(
      int productId, String wishlistFlag) async {
    final db = await instance.database;

    final map = {'wishlist_flag': '$wishlistFlag'};

    return db.update(
      products,
      map,
      where: '${ProductsFields.product_id} = ?',
      whereArgs: [productId],
    );
  }

  //update home products cart
  Future<void> updateHomeProductsCart(int productId, String cartFlag) async {
    final db = await instance.database;

    final map = {'cart_flag': '$cartFlag'};

    return db.update(
      products,
      map,
      where: '${ProductsFields.product_id} = ?',
      whereArgs: [productId],
    );
  }

  //clear product table
  Future<void> clearProducts() async {
    final db = await instance.database;

    return await db.delete(
      products,
      where: null,
      whereArgs: null,
    );
  }

  //-------------------------------Favourites--------------------------------//

  //favourite table row count
  Future<int> countFavourite() async {
    var db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM favourites'));
    // assert(count == 2);
    return count;
  }

  //add product to wishlist
  Future<Favourites> insertToFavourites(Favourites favouritesTable) async {
    final db = await instance.database;
    int productId = favouritesTable.fav_product_id;
    final result = await db
        .rawQuery("SELECT * FROM favourites WHERE product_id='$productId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(favourites, favouritesTable.toJson());
      return favouritesTable.copy(fav_product_id: id);
    }
  }

  Future<int> addTofavourites(Favourites favouritesTable) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT * FROM favourites WHERE product_id='" +
            favouritesTable.fav_product_id.toString() +
            "'",
        null);
    if (result.length >= 1) {
      return 2;
    } else {
      final id = await db.insert(favourites, favouritesTable.toJson());
      if (id == -1) {
        return 0;
      } else {
        return 1;
      }
    }
  }

  //get all favourites table data
  Future<List<Favourites>> getFavourites() async {
    final db = await instance.database;
    const orderBy = 'favour_id DESC';
    final result = await db.query(favourites, orderBy: orderBy);
    return result.map((json) => Favourites.fromJson(json)).toList();
  }

  //delete product from favourites
  Future<int> deleteFavourites(int productId) async {
    final db = await instance.database;

    return await db.delete(
      favourites,
      where: '${FavouritesFields.fav_product_id} = ?',
      whereArgs: [productId],
    );
  }

  //clear favourites table
  Future<void> clearFavourites() async {
    final db = await instance.database;

    return await db.delete(
      favourites,
      where: null,
      whereArgs: null,
    );
  }

  //---------------------------------Cart-----------------------------------//

  // create cart table
  Future<Cart> insertToCart(Cart cartTable) async {
    final db = await instance.database;
    int productId = cartTable.product_id;
    final result =
        await db.rawQuery("SELECT * FROM cart WHERE product_id='$productId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(cart, cartTable.toJson());
      return cartTable.copy(product_id: id);
    }
  }

  Future<int> addTocart(Cart cartTable) async {
    final db = await instance.database;
    int productId = cartTable.product_id;
    final result = await db.rawQuery(
        "SELECT * FROM cart WHERE product_id='$productId'", null);
    if (result.length >= 1) {
      return 2;
    } else {
      final id = await db.insert(cart, cartTable.toJson());
      if (id == -1) {
        return 0;
      } else {
        return 1;
      }
    }
  }

  //get all cart table data
  Future<List<Cart>> getCartProducts() async {
    final db = await instance.database;
    final orderBy = 'cart_id ASC';
    final result = await db.query(cart, orderBy: orderBy);
    return result.map((json) => Cart.fromJson(json)).toList();
  }

  //delete product from cart
  Future<int> deleteProductFromCart(int productId) async {
    final db = await instance.database;

    return await db.delete(
      cart,
      where: '${CartFields.product_id} = ?',
      whereArgs: [productId],
    );
  }

  //update cart withdrawal amount
  Future<void> updateWithdrawalAmount(int productId, String amount) async {
    final db = await instance.database;

    final map = {'amount': '$amount'};

    return db.update(
      cart,
      map,
      where: '${CartFields.product_id} = ?',
      whereArgs: [productId],
    );
  }

  //cart table row count
  Future<int> countCart() async {
    var db = await instance.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cart'));
    // assert(count == 2);
    return count;
  }

  //clear cart table
  Future<int> clearCart() async {
    final db = await instance.database;

    return await db.delete(
      cart,
      where: null,
      whereArgs: null,
    );
  }

  //-----------------------------------Address--------------------------------//

  //insert data into address table
  Future<Address> insertToAddress(Address addressTable) async {
    final db = await instance.database;
    int addressId = addressTable.address_id;
    final result = await db
        .rawQuery("SELECT * FROM address WHERE address_id='$addressId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(address, addressTable.toJson());
      return addressTable.copy(address_id: id);
    }
  }

  //update a single column full values
  Future<void> updateDefaultFlag() async {
    final db = await instance.database;

    final map = {'default_flag': '0'};

    return db.update(
      address,
      map,
      where: null,
      whereArgs: null,
    );
  }

  //update location default flag
  Future<void> setDefaultFlag(int addressId, String defaultFlag) async {
    final db = await instance.database;

    final map = {'default_flag': '$defaultFlag'};

    return db.update(
      address,
      map,
      where: '${AddressFields.address_id} = ?',
      whereArgs: [addressId],
    );
  }

  //update address
  Future<void> updateAddress(
      int addressId,
      String fullAddress,
      String flat,
      String landmark,
      String saveAs,
      String latitude,
      String longitude,
      String defaultValue) async {
    final db = await instance.database;
    final map = {
      '$AddressFields.full_address': fullAddress,
      '$AddressFields.flat': flat,
      '$AddressFields.landmark': landmark,
      '$AddressFields.save_as': '$saveAs',
      '$AddressFields.latitude': '$latitude',
      '$AddressFields.longitude': '$longitude',
      '$AddressFields.default_flag': '$defaultValue'
    };

    return db.update(address, map,
        where: '${AddressFields.address_id} = ?', whereArgs: [addressId]);
  }

  //get all address table data
  Future<List<Address>> getaddress() async {
    final db = await instance.database;
    final orderBy = '${AddressFields.address_id} DESC';
    final result = await db.query(address, orderBy: orderBy);
    return result.map((json) => Address.fromJson(json)).toList();
  }

  //get all default address from table
  Future<List<Address>> getDefaultAddress() async {
    final db = await instance.database;
    String defaultValue = "1";
    final result = await db.query(address,
        where: '${AddressFields.default_flag} = ?', whereArgs: [defaultValue]);
    return result.map((json) => Address.fromJson(json)).toList();
  }

  //address table row count
  Future<int> countAddress() async {
    var db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM address'));
    // assert(count == 2);
    return count;
  }

  //clear address table
  Future<int> deleteAddress(int addressId) async {
    final db = await instance.database;

    return await db.delete(
      address,
      where: '${AddressFields.address_id} = ?',
      whereArgs: [addressId],
    );
  }

  //clear address table
  Future<void> clearAddress() async {
    final db = await instance.database;

    return await db.delete(
      address,
      where: null,
      whereArgs: null,
    );
  }

  //-----------------------------------Orders---------------------------------//

  //update a single column full values(order total pages)
  Future<void> updateOrdersTotalPages(String totalPages) async {
    final db = await instance.database;

    final map = {'total_pages': '$totalPages'};

    return db.update(
      orders,
      map,
      where: null,
      whereArgs: null,
    );
  }

  //insert data into order table
  Future<Orders> insertToOrder(Orders ordersTable) async {
    final db = await instance.database;
    int orderId = ordersTable.order_id;
    final result =
        await db.rawQuery("SELECT * FROM orders WHERE order_id='$orderId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(orders, ordersTable.toJson());
      return ordersTable.copy(order_id: id);
    }
  }

  //get all orders table data
  Future<List<Orders>> getOrders() async {
    final db = await instance.database;
    final orderBy = '${OrdersFields.order_id} DESC';
    final result = await db.query(orders, orderBy: orderBy);
    return result.map((json) => Orders.fromJson(json)).toList();
  }

  //get a specific order data from table
  Future<List<Orders>> getOrderInfo(int orderId) async {
    final db = await instance.database;

    final result = await db.query(
      orders,
      columns: OrdersFields.values,
      where: '${OrdersFields.order_id} = ?',
      whereArgs: [orderId],
    );

    if (result.isNotEmpty) {
      return result.map((json) => Orders.fromJson(json)).toList();
    } else {
      throw Exception('ID $orderId not found');
    }
  }

  //update order status
  Future<void> updateorderStatus(int orderId, String orderStatus) async {
    final db = await instance.database;

    final map = {'${OrdersFields.order_status}': '$orderStatus'};
    return db.update(orders, map,
        where: '${OrdersFields.order_id} = ?', whereArgs: [orderId]);
  }

  //update order rating and reviews
  Future<void> updateorderRatingAndReview(
      int orderId, String rating, String review) async {
    final db = await instance.database;

    final map = {
      '${OrdersFields.order_rating}': '$rating',
      '${OrdersFields.order_review}': '$review'
    };
    return db.update(orders, map,
        where: '${OrdersFields.order_id} = ?', whereArgs: [orderId]);
  }

  //order table row count
  Future<int> countOrders() async {
    var db = await instance.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders'));
    // assert(count == 2);
    return count;
  }

  //get last 5 orders
  Future<int> getLastOrder() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
        'DELETE FROM orders WHERE order_id NOT IN(SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 5)'));
    return count;
  }

  // get first added order in order table
  Future<int> getfirstOrderId() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT MIN(order_id) FROM orders');
    final results = Orders.fromJson(result.elementAt(0)).order_id;
    return results;
  }

  // get last added order in order table
  Future<int> getLastOrderId() async {
    final db = await instance.database;
    final result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT max(order_id) FROM orders'));

    // final results = Orders.fromJson(result.elementAt(0)).order_id;
    print('lastOrder::::' + result.toString());
    // print('lastOrderSize::::' + result.length.toString());
    print('lastOrderId:' + result.toString());
    return result;
  }

  //delete first order data from table
  Future<int> deleteFirstOrder(String tb_id) async {
    final db = await instance.database;

    return await db.delete(
      orders,
      where: '${OrdersFields.order_id} = ?',
      whereArgs: [tb_id],
    );
  }

  //clear orders table
  Future<void> clearOrders() async {
    final db = await instance.database;

    return await db.delete(
      orders,
      where: null,
      whereArgs: null,
    );
  }

  ///------------------------------Order Products------------------------------//

  ///get ordered product data from table
  Future<List<OrderProduct>> getOrderedProductInfo(int orderId) async {
    final db = await instance.database;

    final maps = await db.query(
      order_products,
      columns: OrderProductFields.values,
      where: '${OrderProductFields.order_id} = ?',
      whereArgs: [orderId],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => OrderProduct.fromJson(json)).toList();
    } else {
      throw Exception('ID $orderId not found');
    }
  }

  ///insert data into order product table
  Future<OrderProduct> insertToOrderProduct(
      OrderProduct orderProductTable) async {
    final db = await instance.database;
    int cartId = orderProductTable.order_cart_id;
    final result = await db
        .rawQuery("SELECT * FROM order_products WHERE cart_id='$cartId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(order_products, orderProductTable.toJson());
      return orderProductTable.copy(order_cart_id: id);
    }
  }

  //clear order product table
  Future<int> clearOrderProduct() async {
    final db = await instance.database;

    return await db.delete(
      order_products,
      where: null,
      whereArgs: null,
    );
  }

  ///-----------------------------Agent Locations------------------------------//

  ///insert data into agent location table
  Future<AgentLocations> insertToAgentLocation(
      AgentLocations agentLocationsTable) async {
    final db = await instance.database;
    int agentId = agentLocationsTable.agent_location_id;
    final result = await db
        .rawQuery("SELECT * FROM agent_locations WHERE location_id='$agentId'");
    if (result.length >= 1) {
      return null;
    } else {
      final id = await db.insert(agent_locations, agentLocationsTable.toJson());
      return agentLocationsTable.copy(agent_location_id: id);
    }
  }

  ///clear agent location table
  Future<void> clearagentLocation() async {
    final db = await instance.database;

    return await db.delete(
      agent_locations,
      where: null,
      whereArgs: null,
    );
  }

  ///location table row count
  Future<int> countLocation() async {
    var db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM agent_locations'));
    // assert(count == 2);
    return count;
  }

  //-------------------------order status----------------------------//
// update order status
//   Future<void> orderStatus(String order_id, String orderStatus) async {
//     final db = await instance.database;
//
//     final map = {
//       '${OrderStatusFields.order_status}': '$orderStatus',
//     };
//     return db.update(order_status, map,
//         where: '${OrderStatusFields.order_status_id} = ?',
//         whereArgs: [order_id]);
//   }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
