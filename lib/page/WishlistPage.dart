// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, avoid_print, prefer_const_declarations, prefer_const_constructors, sized_box_for_whitespace, list_remove_unrelated_type

import 'dart:async';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Model/Favourites.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Favourites> productList;
  List<Favourites> localCartModelArrayList = [];
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobile = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  ScaffoldMessengerState scaffoldMessenger;
  final _wishlistController = StreamController<List<Favourites>>.broadcast();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      productList = [];
      productList = await DSDatabase.instance.getFavourites();

      if (productList.isEmpty) {
//                loadServerData();
//         lyout_no_data_msg.setVisibility(View.VISIBLE);
//         lyout_wishList.setVisibility(View.GONE);
      } else {
        loadCartLocalData(productList);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: colors.off_white,
      appBar: _appBar(),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: _cartItemList(context),
      ),
    );
  }

  //app bar
  Widget _appBar() {
    final double circleRadius = 50.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).wishlist.toUpperCase(),
          style: TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      leading: Container(
        margin: EdgeInsets.only(left: 10),
        width: circleRadius,
        height: circleRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primaryColor,
          border: Border.all(color: colors.white, width: 4),
        ),
        child: IconButton(
          padding: EdgeInsets.only(left: 7.0),
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //wishlist list
  Widget _cartItemList(BuildContext context) {
    // double cWidth = MediaQuery.of(context).size.width;
    // double cHeight = MediaQuery.of(context).size.height * 0.6;
    // const double circleRadius = 50.0;
    const Color background = colors.primaryColor;
    const Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 70.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return StreamBuilder(
        initialData: localCartModelArrayList,
        stream: _wishlistController.stream,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: localCartModelArrayList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 100,

                  ///setting two colors to the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: gradient,
                      stops: stops,
                      end: Alignment.center,
                      begin: Alignment.centerLeft,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                flex: 1,

                                ///setting image over image side by side
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.center,
                                        height: 100,
                                        child: Image.asset(
                                            'assets/icons/' +
                                                localCartModelArrayList[index]
                                                    .fav_image +
                                                '.png',
                                            height: 70,
                                            width: 70)),
                                  ],
                                )),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            localCartModelArrayList[index]
                                                .fav_name,
                                            style: const TextStyle(
                                                color: colors.black,
                                                fontSize: 16)),
                                      ],
                                    ),
                                    // localCartModelArrayList[index]
                                    //             .fav_withdrawal ==
                                    //         '0'
                                    //     ? Row(
                                    //         children: [],
                                    //       )
                                    //     : Row(
                                    //         children: [
                                    //           Column(
                                    //             children: [
                                    //               Row(
                                    //                 children: [
                                    //                   Container(
                                    //                     height: 30,
                                    //                     width: 120,
                                    //                     decoration: BoxDecoration(
                                    //                         color: colors
                                    //                             .off_white,
                                    //                         borderRadius:
                                    //                             BorderRadius
                                    //                                 .circular(
                                    //                                     5),
                                    //                         border: Border.all(
                                    //                             color: colors
                                    //                                 .gray)),
                                    //                     child: GestureDetector(
                                    //                       onTap: () {
                                    //                         // setState(() {
                                    //                         //   editAmount =
                                    //                         //       productList[
                                    //                         //               index]
                                    //                         //           .amount;
                                    //                         // });
                                    //                       },
                                    //                       child: TextField(
                                    //                         expands: false,
                                    //                         maxLength: 20,
                                    //                         maxLines: 1,
                                    //                         textAlign:
                                    //                             TextAlign.left,
                                    //                         style: const TextStyle(
                                    //                             fontSize: 16.0,
                                    //                             color: colors
                                    //                                 .primaryColor),
                                    //                         decoration:
                                    //                             InputDecoration(
                                    //                           contentPadding:
                                    //                               const EdgeInsets
                                    //                                       .only(
                                    //                                   left: 5.0,
                                    //                                   bottom:
                                    //                                       12),
                                    //                           counterText: "",
                                    //                           hintText: 'Item',
                                    //                           hintStyle:
                                    //                               const TextStyle(
                                    //                                   color: Colors
                                    //                                       .grey),
                                    //                           focusedBorder:
                                    //                               OutlineInputBorder(
                                    //                             borderSide: const BorderSide(
                                    //                                 color: Colors
                                    //                                     .white),
                                    //                             borderRadius:
                                    //                                 BorderRadius
                                    //                                     .circular(
                                    //                                         32.0),
                                    //                           ),
                                    //                           enabledBorder:
                                    //                               UnderlineInputBorder(
                                    //                             borderSide: const BorderSide(
                                    //                                 color: Colors
                                    //                                     .white),
                                    //                             borderRadius:
                                    //                                 BorderRadius
                                    //                                     .circular(
                                    //                                         32.0),
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               )
                                    //             ],
                                    //           )
                                    //         ],
                                    //       )
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: colors.primaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          removeProductFromWishlist(
                                              localCartModelArrayList[index]
                                                  .fav_product_id);
                                          setState(() {
                                            localCartModelArrayList.remove(
                                                localCartModelArrayList[index]
                                                    .fav_product_id);
                                          });
                                        },
                                        child: Center(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colors.primaryColor,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: colors.black,
                                            ),

                                            /// replace your image with the Icon
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  //remove item from wishlist
  removeProductFromWishlist(int productId) async {
    await DSDatabase.instance.deleteFavourites(productId);
    await DSDatabase.instance.updateHomeProductsWishlist(productId, 'false');
    // int count = await DSDatabase.instance.countFavourite();
    localCartModelArrayList.clear();
    localCartModelArrayList = await DSDatabase.instance.getFavourites();
    _wishlistController.sink.add(localCartModelArrayList);
  }

// add to wishlist
  getAllWishlist(String url) async {
    var headers = {
      'DeviceID': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobile,
      'Password': encryptPassword,
      'Content-Type': 'application/json'
    };
    var request =
        Request('GET', Uri.parse(Apis.BASE_URL + Apis.ADD_TO_WISHLIST));
    // // request.body = '''{"RequestEncrypted":"$encodedBody"}''';
    // String requestBody = request.body.toString();
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    // final resbody = json.decode(response.stream.toString());
    if (statusCode == 200) {
      // cart = Cart.fromJson(decodeData);
      // return cart;
    } else {
      // return productDetails = ProductDetails();
    }
  }

  //load cart local data
  loadCartLocalData(List<Favourites> productsList) {
    if (productsList.isNotEmpty) {
      Favourites favourites;
      for (int i = 0; i < productsList.length; i++) {
        String product_id = productsList.elementAt(i).fav_product_id.toString();
        String productName = productsList.elementAt(i).fav_name;
        String productImage = productsList.elementAt(i).fav_image;
        double productAmount =
            double.tryParse(productsList.elementAt(i).fav_withdrawal);

        favourites = new Favourites(
            fav_name: productName,
            fav_image: productImage,
            fav_withdrawal: productAmount.toString(),
            fav_product_id: int.tryParse(product_id));
        localCartModelArrayList.add(favourites);
        _wishlistController.sink.add(localCartModelArrayList);
      }
    }
  }
}
