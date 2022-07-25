// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, missing_return, sized_box_for_whitespace, prefer_const_constructors, avoid_print, await_only_futures, use_key_in_widget_constructors, library_prefixes, unrelated_type_equality_checks, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Model/AgentLocations.dart';
import 'package:doorstep_banking_flutter/Model/Cart.dart';
import 'package:doorstep_banking_flutter/Model/Favourites.dart';
import 'package:doorstep_banking_flutter/Model/OrderProducts.dart';
import 'package:doorstep_banking_flutter/Model/Orders.dart';
import 'package:doorstep_banking_flutter/Model/Products.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/OrderPage.dart';
import 'package:doorstep_banking_flutter/page/ProfilePage.dart';
import 'package:doorstep_banking_flutter/page/SettingsPage.dart';
import 'package:doorstep_banking_flutter/page/ViewStatusPage.dart';
import 'package:doorstep_banking_flutter/utils/Category.dart';
import 'package:doorstep_banking_flutter/utils/LocationProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:lottie/lottie.dart' as Lottie;
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'AddAddressPage.dart';
import 'CartPage.dart';
import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Products> CategoryProductList;
  List<Products> CategoryModelList;
  final Set<Marker> _markers = {};
  String fullAddress = '',
      latitude = '',
      longitude = '';
  Future locationFuture;
  var HomeCategoryModelList = <String, dynamic>{};
  List<Products> homeCategoryList = [];
  List<Orders> orderList = [];
  List<String> favourFlag = [];
  List<String> cartFlag = [];
  List<AgentLocations> agentLocations = [];
  bool homeCategory = true;
  bool orderqr = false;
  bool orderrating = false;
  String orderOtp = "",
      orderNumber = "";
  List<AgentLocations> agentLocationList = [];
  ScaffoldMessengerState scaffoldMessenger;
  GoogleMapController newGoogleMapController;
  final _listController = StreamController<List<Products>>.broadcast();
  final _flagController = StreamController<String>.broadcast();
  final _locationController = StreamController<Set<Marker>>.broadcast();

  Stream<String> get stream => _flagController.stream;
  final _cartflagController = StreamController<String>.broadcast();
  List<Color> favourColor = [];
  Icon favourClickIcon = Icon(
    Icons.favorite,
    color: colors.red,
  );
  Icon favourIcon = Icon(
    Icons.favorite,
    color: colors.gray_dark,
  );

  final StreamController<int> _countController = StreamController<int>();
  final TextEditingController _amountController = new TextEditingController();

  // Position currentPosition;
  // var geolocator = Geolocator();
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobileNumber = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  String userName = PrefManager.getUsername();
  String language = PrefManager.getSelectedLanguageKey();
  String profilePic;
  LatLong.LatLng currentPostion;
  int cartCount = 0,
      addressCount;
  int orderTableCount;
  bool hasConnection = false;
  bool locFlag = false;
  Color favour_icon;
  bool loading = false;
  bool toggle;
  static const platform =
  const MethodChannel('flutter.native/Encryptionhelper');
  Icon dragIcon = Icon(
    Icons.keyboard_arrow_up,
    color: colors.primaryColor,
    size: 25,
  );
  bool animationVisibility = true;

  @override
  void dispose() {
    super.dispose();
    _flagController.close();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initalization();
    if (PrefManager.getProfile() == null || PrefManager.getProfile() == '') {
      profilePic = null;
    } else {
      profilePic = PrefManager.getProfile();
    }

    CategoryModelList = [];
    if (PrefManager.getisLoginFlag()) {
      loadHomeCategory();
      loadOrders();
      agentLocation();
    } else {
      getproductCount();
    }
    locationFuture = agentLocation();
  }

  //getting product count from database
  getproductCount() async {
    int count = await DSDatabase.instance.countProducts();
    if (count == 0) {
      loadHomeCategory();
    }
    loadLocalData();
  }

  //setting home product list
  Future<List<Products>> loadHomeCategory() async {
    try {
      //set listview visibility here
      //set hide order layout here
      CategoryModelList.clear();
      HomeCategoryModelList.clear;
      CategoryProductList = await DSDatabase.instance.readAllProducts();
      if (CategoryProductList.isEmpty) {
        List<String> categoryNameEn = Category.CategoryListEn;
        List<String> categoryNameHi = Category.CategoryListHi;
        List<String> categoryNameMl = Category.CategoryListMl;
        List<String> categoryNameMr = Category.CategoryListMr;
        List<String> categoryNameTa = Category.CategoryListTa;
        List<String> categoryImageActive = [
          "ic_money_transfer",
          "ic_atm_withdrawal",
          "ic_deposit",
          "ic_electricity",
          "ic_water",
          "ic_fast_tag",
          "ic_mobile_recharge",
          "ic_landline",
          "ic_dth",
          "ic_gas"
        ];
        List<String> categoryImageInactive = [
          "ic_money_treasfer_light",
          "atm_withdrawal_light",
          "ic_deposit_light",
          "ic_electricity_light",
          "ic_water_light",
          "ic_fast_tag_light",
          "ic_mobile_recharge_light",
          "ic_landline_light",
          "ic_dth_light",
          "ic_gas_light"
        ];

        await DSDatabase.instance.clearProducts();
        Products productsModel;
        cartFlag.clear();
        for (int i = 0; i < categoryNameEn.length; i++) {
          String id = i.toString() + "".trim();
          String img_active = categoryImageActive[i];
          String img_inactive = categoryImageInactive[i];
          String nameEn = categoryNameEn[i];
          String cart_flag = "false";
          String favour_flag = "false";
          String nameHi = categoryNameHi[i];
          String nameMl = categoryNameMl[i];
          String nameMr = categoryNameMr[i];
          String nameTa = categoryNameTa[i];

          productsModel = new Products(
              product_id: int.tryParse(id),
              product_name_en: nameEn,
              product_image_active: img_active,
              product_image_inactive: img_inactive,
              product_cart_flag: cart_flag,
              product_wishlist_flag: favour_flag,
              product_name_hi: nameHi,
              product_name_ml: nameMl,
              product_name_mr: nameMr,
              product_name_ta: nameTa);
          await DSDatabase.instance.insertToProducts(productsModel);
          setState(() {
            HomeCategoryModelList = {
              'product_id': id,
              'product_name_en': nameEn,
              'product_image_active': img_active,
              'product_image_inactive': img_inactive,
              'product_cart_flag': cart_flag,
              'product_wishlist_flag': favour_flag,
              'product_name_hi': nameHi,
              'product_name_ml': nameMl,
              'product_name_mr': nameMr,
              'product_name_ta': nameTa
            };
            CategoryModelList.add(productsModel);
            favourFlag.add('false');
            cartFlag.add('false');
            favourColor.add(colors.gray_dark);
            log('Category:$HomeCategoryModelList');
          });
        }
        // tvCartCount.setVisibility(View.GONE);
      } else {
        cartFlag.clear();
        for (int i = 0; i < CategoryProductList.length; i++) {
          int id = CategoryProductList
              .elementAt(i)
              .product_id;
          String img_active =
              CategoryProductList
                  .elementAt(i)
                  .product_image_active;
          String img_inactive =
              CategoryProductList
                  .elementAt(i)
                  .product_image_inactive;
          String name = CategoryProductList
              .elementAt(i)
              .product_name_en;
          String cart_flag = CategoryProductList
              .elementAt(i)
              .product_cart_flag;
          String favour_flag =
              CategoryProductList
                  .elementAt(i)
                  .product_wishlist_flag;
          String nameHi = CategoryProductList
              .elementAt(i)
              .product_name_hi;
          String nameMl = CategoryProductList
              .elementAt(i)
              .product_name_ml;
          String nameMr = CategoryProductList
              .elementAt(i)
              .product_name_mr;
          String nameTa = CategoryProductList
              .elementAt(i)
              .product_name_ta;

          Products productModel = new Products(
              product_id: id,
              product_name_en: name,
              product_image_active: img_active,
              product_image_inactive: img_inactive,
              product_cart_flag: cart_flag,
              product_wishlist_flag: favour_flag,
              product_name_hi: nameHi,
              product_name_ml: nameMl,
              product_name_mr: nameMr,
              product_name_ta: nameTa);
          setState(() {
            HomeCategoryModelList = {
              'product_id': id,
              'product_name_en': name,
              'product_image_active': img_active,
              'product_image_inactive': img_inactive,
              'product_cart_flag': cart_flag,
              'product_wishlist_flag': favour_flag,
              'product_name_hi': nameHi,
              'product_name_ml': nameMl,
              'product_name_mr': nameMr,
              'product_name_ta': nameTa
            };
            CategoryModelList.add(productModel);
            favourFlag.add(favour_flag);
            cartFlag.add(cart_flag);
            log('Category:$HomeCategoryModelList');
            if (favour_flag == 'true') {
              favourColor.add(colors.red);
            } else {
              favourColor.add(colors.gray_dark);
            }
          });
        }
        // if (cartCount == 0){
        //   // tvCartCount.setVisibility(View.GONE);
        // }else {
        //   // tvCartCount.setText(cartCount+"");
        //   // tvCartCount.setVisibility(View.VISIBLE);
        // }
      }
      cartCount = await DSDatabase.instance.countCart();
      _countController.sink.add(cartCount);
      _listController.sink.add(CategoryModelList);
      print('CategoryModelList:' + CategoryModelList.length.toString());
      print('CategoryListSize:' + HomeCategoryModelList.length.toString());
      return CategoryModelList;
      // homeCategoryList = CategoryModelList.
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    const double circleRadius = 60.0;
    const Color background = colors.primaryColor;
    const Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 36.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Scaffold(
        drawer: _drawer(),
        body: Stack(
            children: [
            Builder(
            builder: (context) => Stack(
        fit: StackFit.expand,
        children: [
        googleMapUi(),
    _productBottomsheet(context),
    _buttons(),
    Positioned(
    top: 30,
    child: Container(
    margin: const EdgeInsets.only(left: 10),
    width: circleRadius,
    height: circleRadius,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: colors.primaryColor,
    border: Border.all(color: colors.white, width: 4),
    ),
    child: IconButton(
    onPressed: () {
    Scaffold.of(context).openDrawer();
    },
    icon: Icon(
    Icons.menu_outlined,
    color: colors.white,
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    Visibility(
    child: loadingWidget(context),
    visible: loading
    ,
    )
    ]
    ,
    )
    );
  }

  //drawer
  Widget _drawer() {
    const Color background = colors.primaryColor;
    const Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 36.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Container(
      width: 250,
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                ///setting to colors for a container
                gradient: LinearGradient(
                  colors: gradient,
                  stops: stops,
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
                boxShadow: [

                  ///shadow for the container
                  BoxShadow(
                    color: Colors.grey[350],
                    offset: const Offset(-4, 4),
                    blurRadius: 5,
                    spreadRadius: 2.5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: colors.light_color, width: 5),
                      ),
                      child: profilePic != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          profilePic,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/icons/ic_profile.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                          color: colors.primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('View profile'),
              leading: Icon(
                Icons.person,
                color: colors.black,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
                // Navigator.pop(context);
                // Navigator.pushNamed(context, RouteConstants.PROFILE);
              },
            ),
            ListTile(
              title: const Text('Manage Address'),
              leading: Icon(
                Icons.add_location_alt_rounded,
                color: colors.black,
              ),
              onTap: () async {
                addressCount = await DSDatabase.instance.countAddress();
                if (addressCount != 0) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAddressPage()));
                } else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAddressPage()));
                }
              },
            ),
            ListTile(
              title: const Text('My orders'),
              leading: Icon(
                Icons.directions_bike,
                color: colors.black,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrdersPage()));
                // Navigator.pop(context);
                // Navigator.pushNamed(context, RouteConstants.MYORDERS);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              leading: Icon(
                Icons.settings,
                color: colors.black,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
                // Navigator.pop(context);
                // Navigator.pushNamed(context, RouteConstants.SETTINGS);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: Icon(
                Icons.power_settings_new_sharp,
                color: colors.black,
              ),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // //drawer open button
  // Widget _drawerOpenBtn() {
  //   const double circleRadius = 60.0;
  // }

  //buttons in home
  Widget _buttons() {
    return Positioned(
      top: 30,
      right: 10,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _profileImage(),
            SizedBox(
              height: 5.0,
            ),
            _cartBtn(),
          ]),
      // Positioned(child: child),
    );
  }

  //profile image
  Widget _profileImage() {
    const double circleRadius = 60.0;
    return Container(
      width: circleRadius,
      height: circleRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: colors.primaryColor, width: 2),
      ),
      child: profilePic != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.network(
          profilePic,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.asset(
          'assets/icons/ic_profile.png',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //cart button
  Widget _cartBtn() {
    return GestureDetector(
      child: Container(
        width: 55.0,
        height: 55.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primaryColor,
          border: Border.all(color: colors.primaryColor, width: 5),
        ),
        child: StreamBuilder(
          initialData: cartCount,
          stream: _countController.stream,
          builder: (_, snapshot) =>
              BadgeIcon(
                icon: Image.asset(
                  'assets/icons/ic_scooter.png',
                  width: 42,
                  height: 42,
                ),
                badgeCount: cartCount,
              ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartPage()));
      },
    );
  }

  //product bottomsheet
  Widget _productBottomsheet(BuildContext context) {
    return SizedBox.expand(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (DraggableScrollableNotification DSNotification) {
          if (animationVisibility && DSNotification.extent >= 0.8) {
            setState(() {
              animationVisibility = false;
              dragIcon = const Icon(
                Icons.keyboard_arrow_down,
                color: colors.primaryColor,
                size: 25,
              );
            });
          } else if (!animationVisibility && DSNotification.extent < 0.3) {
            setState(() {
              animationVisibility = true;
              dragIcon = const Icon(
                Icons.keyboard_arrow_up,
                color: colors.primaryColor,
                size: 25,
              );
            });
          }
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.28,
          minChildSize: 0.28,
          maxChildSize: 0.85,
          builder: (BuildContext context, ScrollController controller) {
            return Container(
                height: 900,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView(controller: controller, children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        height: 60,
                        width: 235,
                        decoration: const BoxDecoration(
                          color: colors.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Hi",
                                  style: TextStyle(color: colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(color: colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 1,
                        right: 260,
                        top: 0,
                        child: Visibility(
                            visible: animationVisibility,
                            child: Lottie.Lottie.asset(
                                'assets/animations/swipe_up_ic.json',
                                height: 100,
                                width: 100)),
                      ),
                      Positioned(
                          top: 10,
                          right: 40,
                          bottom: 0,
                          child: Image.asset(
                            "assets/icons/img_delivery_man.png",
                            width: 130,
                            height: 120,
                          )),
                    ],
                  ),
                  Container(
                    height: 450,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: colors.off_white,
                      borderRadius: BorderRadius.circular(70.0),
                      border: Border.all(color: colors.white, width: 7),
                    ),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/atm_bharath_logo.png",
                                  width: 60,
                                  height: 40,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                dragIcon,
                              ],
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: homeCategory,
                        child: Container(
                          alignment: Alignment.center,
                          height: 370,
                          width: 350,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: StreamBuilder(
                            initialData: CategoryModelList,
                            stream: _cartflagController.stream,
                            builder: (context, snapshot) {
                              return GridView.builder(
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0.0,
                                  crossAxisSpacing: 0.0,
                                ),
                                itemCount: CategoryModelList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String cartFlag = CategoryModelList[index]
                                      .product_cart_flag;
                                  return Container(
                                    height: 120,
                                    child: Column(children: <Widget>[
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: colors.off_white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: GestureDetector(
                                            onTap: () async {
                                              if (CategoryModelList[index]
                                                  .product_cart_flag ==
                                                  'true') {
                                                await DSDatabase.instance
                                                    .deleteProductFromCart(
                                                    CategoryModelList[index]
                                                        .product_id);
                                                await DSDatabase.instance
                                                    .updateHomeProducts(
                                                    CategoryModelList[index]
                                                        .product_id,
                                                    'false',
                                                    CategoryModelList[index]
                                                        .product_wishlist_flag);
                                                Products products = new Products(
                                                    product_id:
                                                    CategoryModelList[index]
                                                        .product_id,
                                                    product_name_en:
                                                    CategoryModelList[index]
                                                        .product_name_en,
                                                    product_image_active:
                                                    CategoryModelList[index]
                                                        .product_image_active,
                                                    product_image_inactive:
                                                    CategoryModelList[index]
                                                        .product_image_inactive,
                                                    product_cart_flag: 'false',
                                                    product_wishlist_flag:
                                                    CategoryModelList[index]
                                                        .product_wishlist_flag,
                                                    product_name_hi:
                                                    CategoryModelList[index]
                                                        .product_name_hi,
                                                    product_name_ml:
                                                    CategoryModelList[index]
                                                        .product_name_ml,
                                                    product_name_mr:
                                                    CategoryModelList[index]
                                                        .product_name_mr,
                                                    product_name_ta:
                                                    CategoryModelList[index]
                                                        .product_name_ta);
                                                CategoryModelList.insert(
                                                    index, products);
                                                CategoryModelList.removeAt(
                                                    index + 1);
                                                _cartflagController.sink
                                                    .add('false');
                                                int cartCount = await DSDatabase
                                                    .instance
                                                    .countCart();
                                                _countController.sink
                                                    .add(cartCount);
                                              } else {
                                                _showBottomSheet(
                                                    context, index);
                                              }
                                            },
                                            child: Image.asset(
                                              cartFlag == 'true'
                                                  ? 'assets/icons/' +
                                                  CategoryModelList[index]
                                                      .product_image_active +
                                                  '.png'
                                                  : 'assets/icons/' +
                                                  CategoryModelList[index]
                                                      .product_image_inactive +
                                                  '.png',
                                              width: 75,
                                              height: 75,
                                            )),
                                      ),
                                      Text(
                                          language == 'hi'
                                              ? CategoryModelList[index]
                                              .product_name_hi
                                              : language == 'ml'
                                              ? CategoryModelList[index]
                                              .product_name_ml
                                              : language == 'mr'
                                              ? CategoryModelList[index]
                                              .product_name_mr
                                              : language == 'ta'
                                              ? CategoryModelList[
                                          index]
                                              .product_name_ta
                                              : CategoryModelList[
                                          index]
                                              .product_name_en,
                                          style: const TextStyle(
                                              color: colors.black,
                                              fontSize: 12.0)),
                                    ]),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Visibility(
                          visible: orderqr,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            height: 350,
                            child: qrCode(),
                          )),
                      Visibility(
                          visible: orderrating,
                          child: Container(
                            height: 350,
                            color: Colors.blue,
                          ))
                    ]),
                  ),
                ]));
          },
        ),
      ),
    );
  }

  //google map
  Widget googleMapUi() {
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        _markers.removeWhere((marker) => model.markerId == '1');
        _markers.addAll(model.markers.values);
        return FutureBuilder(
            future: locationFuture,
            builder: (context, snapshot) {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                CameraPosition(target: model.locationPosition, zoom: 15),
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: _markers,
                padding: const EdgeInsets.only(top: 150, left: 35.0),
                onMapCreated: (GoogleMapController controller) {
                  PrefManager.saveUserLatitude(
                      model.locationPosition.latitude.toString());
                  PrefManager.saveUserLongitude(
                      model.locationPosition.longitude.toString());
                  getAddressFromMarker(LatLng(model.locationPosition.latitude,
                      model.locationPosition.longitude));
                  print('lat::' + model.locationPosition.longitude.toString());
                  // _markers;
                },
              );
            });
      } else {
        return Container();
      }
    });
  }

  //qr Code
  Widget qrCode() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            height: 50,
            width: 280,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              color: colors.white,
              border: Border.all(color: colors.primaryColor, width: 3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextButton(
              onPressed: () =>
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => ViewStatusPage())),
              child: Text(
                S
                    .of(context)
                    .viewStatus
                    .toUpperCase(),
                style: TextStyle(
                    color: colors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              margin: new EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colors.off_white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4, 4),
                      // blurRadius: 15,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      // blurRadius: 15,
                      // spreadRadius: 1.0,
                    ),
                  ]),
              child: Column(children: [
                Container(
                  child: Center(
                    child: QrImage(
                      //place where the QR Image will be shown
                      data: orderOtp,
                      size: 180,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "OrderID : #" + orderNumber,
                  style: TextStyle(
                      color: colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'OTP: ' + orderOtp,
                  style: TextStyle(
                      color: colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
              ]))
        ],
      ),
    );
  }

  //rating widget
  Widget orderRating() {
    return Container();
  }

  //bottomsheet for adding product to cart
  _showBottomSheet(BuildContext context, int index) {
    String cartFlag = CategoryModelList[index].product_cart_flag;
    String favourFlag = CategoryModelList[index].product_wishlist_flag;
    _flagController.sink.add(favourFlag);
    print('CategoryListModel::' + CategoryModelList[index].product_cart_flag);
    print(
        'CategoryListModel::' + CategoryModelList[index].product_wishlist_flag);
    print('CartFlag::' + cartFlag.toString());
    print('FavourFlag' + favourFlag.toString());
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamBuilder(
            initialData: favourFlag,
            stream: _flagController.stream,
            builder: (context, snapshot) {
              String favour = snapshot.data.toString();
              log('favour:$favour');
              return Container(
                  color: colors.off_white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              CategoryModelList[index]
                                  .product_name_en
                                  .toString(),
                              style: TextStyle(
                                  color: colors.black, fontSize: 18.0),
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: IconButton(
                                  icon: favour == 'true'
                                      ? favourClickIcon
                                      : favourIcon,
                                  onPressed: () async {
                                    Favourites favourites = new Favourites(
                                        fav_name: CategoryModelList[index]
                                            .product_name_en,
                                        fav_image: CategoryModelList[index]
                                            .product_image_active,
                                        fav_withdrawal: '0',
                                        fav_product_id: CategoryModelList[index]
                                            .product_id);
                                    int result = await DSDatabase.instance
                                        .addTofavourites(favourites);
                                    log('result: $result');
                                    if (result == 1) {
                                      // add favour
                                      await DSDatabase.instance
                                          .updateHomeProducts(
                                          CategoryModelList[index]
                                              .product_id,
                                          cartFlag,
                                          'true');
                                      setState(() {
                                        Products products = new Products(
                                            product_id: CategoryModelList[index]
                                                .product_id,
                                            product_name_en:
                                            CategoryModelList[index]
                                                .product_name_en,
                                            product_image_active:
                                            CategoryModelList[index]
                                                .product_image_active,
                                            product_image_inactive:
                                            CategoryModelList[index]
                                                .product_image_inactive,
                                            product_cart_flag: cartFlag,
                                            product_wishlist_flag: 'true',
                                            product_name_hi:
                                            CategoryModelList[index]
                                                .product_name_hi,
                                            product_name_ml:
                                            CategoryModelList[index]
                                                .product_name_ml,
                                            product_name_mr:
                                            CategoryModelList[index]
                                                .product_name_mr,
                                            product_name_ta:
                                            CategoryModelList[index]
                                                .product_name_ta);
                                        // homeCategoryList;
                                        // _listController.sink
                                        //     .add(CategoryModelList);
                                        CategoryModelList.insert(
                                            index, products);
                                        CategoryModelList.removeAt(index + 1);
                                        print('updated Category' + favourFlag);
                                        toggle = true;
                                        // favour = true;
                                        favourFlag = 'true';
                                        _flagController.sink.add('true');
                                      });
                                    } else {
                                      // remove favour
                                      await DSDatabase.instance
                                          .deleteFavourites(
                                          CategoryModelList[index]
                                              .product_id);
                                      await DSDatabase.instance
                                          .updateHomeProducts(
                                          CategoryModelList[index]
                                              .product_id,
                                          cartFlag,
                                          'false');
                                      setState(() {
                                        Products products = new Products(
                                            product_id: CategoryModelList[index]
                                                .product_id,
                                            product_name_en:
                                            CategoryModelList[index]
                                                .product_name_en,
                                            product_image_active:
                                            CategoryModelList[index]
                                                .product_image_active,
                                            product_image_inactive:
                                            CategoryModelList[index]
                                                .product_image_inactive,
                                            product_cart_flag: cartFlag,
                                            product_wishlist_flag: 'false',
                                            product_name_hi:
                                            CategoryModelList[index]
                                                .product_name_hi,
                                            product_name_ml:
                                            CategoryModelList[index]
                                                .product_name_ml,
                                            product_name_mr:
                                            CategoryModelList[index]
                                                .product_name_mr,
                                            product_name_ta:
                                            CategoryModelList[index]
                                                .product_name_ta);
                                        CategoryModelList.insert(
                                            index, products);
                                        CategoryModelList.removeAt(index + 1);
                                        print('updated Category' + favourFlag);
                                        toggle = false;
                                        // favour = false;
                                        favourFlag = 'false';
                                        _flagController.sink.add('false');
                                      });
                                    }
                                  })),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        thickness: 1,
                        color: colors.black,
                      ),
                      CategoryModelList[index].product_name_en ==
                          'ATM Withdrawal'
                          ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.credit_card,
                                color: colors.black,
                              ),
                              Text(
                                S
                                    .of(context)
                                    .atmService,
                                style: TextStyle(
                                    color: colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CustomPaint(
                              size: const Size(360, 5),
                              painter: DashedLineHorizontalPainter()),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S
                                    .of(context)
                                    .cashWithdrawal,
                                style: TextStyle(
                                    color: colors.black, fontSize: 18.0),
                              ),
                              Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 5.0),
                                padding:
                                EdgeInsets.symmetric(horizontal: 5.0),
                                height: 40,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                    BorderRadius.circular(2.0)),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: colors.black),
                                  decoration: InputDecoration(
                                      hintText: 'Enter the amount'),
                                  controller: _amountController,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                          : SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              height: 45,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: colors.white,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  S
                                      .of(context)
                                      .cancel,
                                  style: TextStyle(
                                    color: colors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 45,
                              width: 120,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: colors.primaryColor,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  String amount = "";
                                  if (CategoryModelList[index]
                                      .product_name_en !=
                                      'ATM Withdrawal') {
                                    amount = "0";
                                  } else {
                                    amount = _amountController.text
                                        .toString()
                                        .trim();
                                  }
                                  Cart cart = new Cart(
                                      item_name: CategoryModelList[index]
                                          .product_name_en,
                                      product_id:
                                      CategoryModelList[index].product_id,
                                      image: CategoryModelList[index]
                                          .product_image_active,
                                      amount: amount);
                                  int result =
                                  await DSDatabase.instance.addTocart(cart);
                                  if (result == 1) {
                                    await DSDatabase.instance
                                        .updateHomeProducts(
                                        CategoryModelList[index].product_id,
                                        'true',
                                        CategoryModelList[index]
                                            .product_wishlist_flag);
                                    setState(() {
                                      Products products = new Products(
                                          product_id: CategoryModelList[index]
                                              .product_id,
                                          product_name_en:
                                          CategoryModelList[index]
                                              .product_name_en,
                                          product_image_active:
                                          CategoryModelList[index]
                                              .product_image_active,
                                          product_image_inactive:
                                          CategoryModelList[index]
                                              .product_image_inactive,
                                          product_cart_flag: 'true',
                                          product_wishlist_flag:
                                          CategoryModelList[index]
                                              .product_wishlist_flag,
                                          product_name_hi:
                                          CategoryModelList[index]
                                              .product_name_hi,
                                          product_name_ml:
                                          CategoryModelList[index]
                                              .product_name_ml,
                                          product_name_mr:
                                          CategoryModelList[index]
                                              .product_name_mr,
                                          product_name_ta:
                                          CategoryModelList[index]
                                              .product_name_ta);
                                      CategoryModelList.insert(index, products);
                                      CategoryModelList.removeAt(index + 1);
                                    });
                                    log('CartFlag:$cartFlag');

                                    int cartCount =
                                    await DSDatabase.instance.countCart();
                                    log('cart_count2==$cartCount');
                                    if (cartCount == 0) {
                                      //cartcount visibility gone
                                    } else {
                                      _countController.sink.add(cartCount);
                                      //cartcount visibility visible
                                    }
                                    _showSnackBar(
                                        context, S
                                        .of(context)
                                        .cartSuccessMsg);
                                  } else {
                                    _showSnackBar(
                                        context, S
                                        .of(context)
                                        .cartFailMsg);
                                  }
                                  Navigator.of(context).pop();
                                  log('CartFlag:$cartFlag');
                                },
                                child: Text(
                                  S
                                      .of(context)
                                      .addCart,
                                  style: TextStyle(
                                    color: colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ));
            },
          );
        });
  }

  //setting product to favourites
  favourButtonClick(String id, String name, String image, String index,
      String cartFlag) async {
    Favourites favourites = Favourites(
        fav_name: name,
        fav_image: image,
        fav_withdrawal: '0',
        fav_product_id: int.tryParse(id));
    int result =
    (await DSDatabase.instance.insertToFavourites(favourites)) as int;
    if (result == 1) {
      // add favour
      await DSDatabase.instance
          .updateHomeProducts(int.tryParse(id), cartFlag, 'true');
      setState(() {
        favour_icon = colors.red;
      });

      // categoryModel.setFavourFlag("true");
    } else {
      // remove favour
      await DSDatabase.instance.deleteFavourites(int.tryParse(id));
      setState(() {
        favour_icon = colors.gray_dark;
      });

      await DSDatabase.instance
          .updateHomeProducts(int.tryParse(id), cartFlag, 'false');
    }
  }

  //getting address from map marker
  void getAddressFromMarker(LatLng latLng) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    String street = placemarks
        .elementAt(0)
        .street;
    String subLocality = placemarks
        .elementAt(0)
        .subLocality;
    String locality = placemarks
        .elementAt(0)
        .locality;
    String district = placemarks
        .elementAt(0)
        .subAdministrativeArea;
    String state = placemarks
        .elementAt(0)
        .administrativeArea;
    String pinCode = placemarks
        .elementAt(0)
        .postalCode;
    setState(() {
      fullAddress = street +
          ',' +
          subLocality +
          ',' +
          locality +
          ',' +
          district +
          ',' +
          state +
          ',' +
          pinCode;

      latitude = latLng.latitude.toString();
      longitude = latLng.longitude.toString();
    });
    print('full Address::' + fullAddress);
    PrefManager.saveDeviceLocationAddress(fullAddress);
  }

  // get nearest agents location
  agentLocation() async {
    String requestResult, responseResult;
    // log('The location is: <${currentPostion.latitude}, ${currentPostion.longitude}>\nYou have pushed the button this many times:');
    var body = {
      'latitude': PrefManager.getUserLatitude(),
      'longitude': PrefManager.getUserLongitude()
    };
    var headers = {
      'DeviceID': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobileNumber,
      'Password': encryptPassword,
      'Content-Type': 'application/json'
    };
    final jsonbody = json.encode(body);
    try {
      requestResult = await platform.invokeMethod(
          'RequestEncrypt', <String, String>{
        'request': jsonbody.toString(),
        'DeviceId': userEmail
      });
      log("request: $requestResult");
    } on PlatformException catch (e) {
      print(e);
    }
    log("body: $jsonbody");
    var request =
    Request('POST', Uri.parse(Apis.BASE_URL + Apis.GET_LOCATIONS));
    request.body = '''{"request_encrypted":'$requestResult'}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = await response.stream.bytesToString();
      String responseBody = body.replaceAll('{"response_encrypted":"', '');
      responseBody = responseBody.replaceAll('"}', "");
      try {
        responseResult = await platform.invokeMethod('ResponseDecrypt',
            <String, String>{'response': responseBody, 'DeviceId': userEmail});
        log('OTPVerResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      if (valueMap['status']) {
        locFlag = true;
        loading = false;
        Map<String, dynamic> order = valueMap['data'];
        String orderStatus = order['order_status'];
        String orderId = order['order_id'].toString();
        print('orderStatus:' + orderStatus);
        print('orderId' + orderId);
        if (orderStatus != "") {
          DSDatabase.instance
              .updateorderStatus(int.tryParse(orderId), orderStatus);
        }
        String agentLat = order['agent_lat'].toString().trim();
        String agentLong = order['agent_long'].toString().trim();
        String userLat = order['user_lat'].toString();
        String userLong = order['user_long'].toString();
        PrefManager.saveUserOrderLatitude(userLat);
        PrefManager.saveUserOrderLongitude(userLong);
        log('latitude:$agentLat');
        log('longitude:$agentLong');
        if (agentLat.isNotEmpty || agentLong.isNotEmpty) {
          // double userLat = order['user_lat'];
          // double userLong = order['user_long'];
          // String agentName = order['agent_name'];
          // agentLocation(userLat, userLong, double.tryParse(agentLat),
          //     double.tryParse(agentLong), agentName);
        } else {
          List<dynamic> location = order['locations'];
          print('list size::' + location.length.toString());
          List<Marker> markerList = [];
          for (int i = 0; i < location.length; i++) {
            // String name = location[i]['merchant_name'];
            String agentId = location[i]['customer_code'];
            double agentLat = location[i]['latitude'];
            double agentLong = location[i]['longitude'];
            markerList.add(Marker(
              markerId: MarkerId(agentId),
              position: LatLng(agentLat, agentLong),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ));
          }
          _markers.clear();
          setState(() {
            _markers.addAll(markerList);
            print('location Size::' + _markers.length.toString());
            _locationController.sink.add(_markers);
          });
        }
        loadLocalData();
        return _markers;
      } else {
        loading = false;
        _showSnackBar(context, message);
      }
    } else {
      loading = false;
      _showSnackBar(context, S
          .of(context)
          .noNetworkConnection);
    }
  }

  //loading database datas
  loadLocalData() async {
    orderTableCount = await DSDatabase.instance.countOrders();
    if (orderTableCount == 0) {
      loadHomeCategory();
    } else {
      int lastOrderId = await DSDatabase.instance.getLastOrderId();
      print('lastOrderId:' + lastOrderId.toString());

      orderList.clear();
      orderList = await DSDatabase.instance.getOrderInfo(lastOrderId);

      String orderStatus = orderList
          .elementAt(0)
          .order_status
          .trim();
      String orderNumber = orderList
          .elementAt(0)
          .order_number;
      String orderOtp = orderList
          .elementAt(0)
          .order_otp;
      String orderId = orderList
          .elementAt(0)
          .order_id
          .toString();

      homeCardViews(orderStatus, orderNumber, orderOtp, orderId);
    }
  }

  //load qr code
  loadQrCode(String otp, String order_number) {
    // tv_qrcode.setText(getString(R.string.order_number)+order_number);
    // tv_orderOtp.setText(getString(R.string.otp)+otp);

    setState(() {
      orderOtp = otp;
      orderNumber = order_number;
    }); // Whatever you need to encode in the QR code
    setState(() {
      orderrating = false;
      orderqr = true;
    });
  }

  //setting home bottomsheet cards
  homeCardViews(String orderStatus, String orderNumber, String orderOtp,
      String orderId) async {
    if (orderStatus == "Completed" || orderStatus == "Cancelled") {
      homeCategory = true;
      orderqr = false;
      loadHomeCategory();
    } else {
      homeCategory = false;
      orderqr = true;

      if (orderStatus == "Delivered") {
        setState(() {
          orderqr = false;
          orderrating = true;
        });

        // btRating.setOnClickListener(v -> {
        // Intent intent = new Intent(HomeActivity.this, OrderRatingActivity.class);
        // intent.putExtra("orderId",orderId);
        // intent.putExtra("orderCode",orderNumber);
        // startActivity(intent);
        // });
      } else {
        setState(() {
          orderqr = true;
          orderrating = false;
        });
        loadQrCode(orderOtp, orderNumber);
      }
    }
  }

  //adding locations to database
  addLocations(dynamic location) async {
    //database function
    agentLocationList.clear();
    int agentLocationCount = await DSDatabase.instance.countLocation();
    if (agentLocationCount > 0) {
      await DSDatabase.instance.clearagentLocation();
    }
    AgentLocations agentLocations;
    for (int i = 0; i < location.length(); i++) {
      double latitude = location['latitude'];
      double longitude = location['longitude'];
      String name = location['merchant_name'];

      agentLocations = new AgentLocations(
          agent_location_id: i,
          agent_name: name,
          agent_latitude: latitude.toString(),
          agent_longitude: longitude.toString());
      await DSDatabase.instance.insertToAgentLocation(agentLocations);

      //map
      // LatLng latLng = new LatLng(latitude, longitude);
      // MarkerOptions m = new MarkerOptions().position(latLng).title(name);
      // mMap.addMarker(m);
    }
  }

  //snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: colors.primaryColor,
      content: Text(message),
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }

  // order data
  loadOrders() async {
    loading = true;
    String requestResult, responseResult;
    try {
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobileNumber,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      log("Header: $headers");
      var body = {'page_no': '1'};
      final jsonbody = json.encode(body);
      log('Body: $jsonbody');
      try {
        requestResult = await platform.invokeMethod(
            'RequestEncrypt', <String, String>{
          'request': jsonbody.toString(),
          'DeviceId': userEmail
        });
        log("request: $requestResult");
      } on PlatformException catch (e) {
        print(e);
      }
      var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.LIST_ORDER));
      request.body = '''{"request_encrypted":"$requestResult"}''';
      request.headers.addAll(headers);
      log('request: $request');

      StreamedResponse response = await request.send();
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String body = await response.stream.bytesToString();
        log('responseBody: $body');
        String responseBody = body.replaceAll('{"response_encrypted":"', '');
        responseBody = responseBody.replaceAll('"}', "");
        log('response: $responseBody');
        try {
          responseResult = await platform.invokeMethod(
              "ResponseDecrypt", <String, String>{
            'response': responseBody,
            'DeviceId': userEmail
          });
          log('Response:$responseResult');
        } on PlatformException catch (e) {
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        if (valueMap['status']) {
          loading = false;
          List<dynamic> order = valueMap['data'];
          if (order.isNotEmpty) {
            await DSDatabase.instance.clearOrderProduct();
            Orders orders;
            OrderProduct orderProduct;
            for (int i = 0; i < order.length; i++) {
              String orderStatus = order[i]['order_status'];
              String addressType = order[i]['address_type'];
              String orderNumber = order[i]['order_number'];
              double latitude = order[i]['latitude'];
              double longitude = order[i]['longitude'];
              String fullAddress = order[i]['full_address'];
              String landmark = order[i]['landmark'];
              double orderId = order[i]['order_id'];
              double addressId = order[i]['address_id'];
              String buildingType = order[i]['building_type'];
              String note = order[i]['custom_notes'];
              String deliveryCharge = order[i]['delivery_charge'];
              String review = order[i]['review'];
              String orderDate = order[i]['order_date'];
              double rating = order[i]['rating'];
              String otp = order[i]['otp'];
              int totalPages = order[i]['page_count'];
              orders = new Orders(
                  order_id: orderId.toInt(),
                  order_number: orderNumber,
                  order_status: orderStatus,
                  order_address_id: addressId.toString(),
                  order_full_address: fullAddress,
                  order_address_type: addressType,
                  order_flat: buildingType,
                  order_landmark: landmark,
                  order_latitude: latitude.toString(),
                  order_longitude: longitude.toString(),
                  order_otp: otp,
                  order_custom_note: note,
                  order_delivery_charge: deliveryCharge,
                  order_rating: rating.toString(),
                  order_review: review,
                  order_date: orderDate,
                  order_total_pages: totalPages.toString());
              await DSDatabase.instance.insertToOrder(orders);
              int order_id = orderId.toInt();
              List<dynamic> product = order[i]['product'];
              for (int j = 0; j < product.length; j++) {
                double cartId = product[j]['cart_id'];
                String productId = product[j]['product_id'];
                String productName = product[j]['product_name'];
                double productAmount = product[j]['amount'];
                String productImage = product[j]['image_name'];
                orderProduct = new OrderProduct(
                    order_cart_id: cartId.toInt(),
                    order_product_id: productId,
                    order_id: order_id.toString(),
                    order_product_name: productName,
                    order_product_amount: productAmount.toString(),
                    order_product_image: productImage);
                await DSDatabase.instance.insertToOrderProduct(orderProduct);
              }
            }
          }
          if (PrefManager.getisLoginFlag()) {
            PrefManager.saveLoginFlag(false);
            loadLocalData();
          }
        } else {
          loading = false;
          _showSnackBar(context, message);
        }
      } else {
        loading = false;
        _showSnackBar(context, S
            .of(context)
            .noNetworkConnection);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //alert dialog
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.pop(context);
        PrefManager.savePassword('');
        PrefManager.saveProfile('');
        PrefManager.saveUsername('');
        PrefManager.saveEmail('');
        PrefManager.saveGender('');
        PrefManager.saveMobile('');
        PrefManager.saveLoginFlag(false);
        PrefManager.saveLogin(false);
        await DSDatabase.instance.clearProducts();
        await DSDatabase.instance.clearCart();
        await DSDatabase.instance.clearOrderProduct();
        await DSDatabase.instance.clearagentLocation();
        await DSDatabase.instance.clearAddress();
        await DSDatabase.instance.clearFavourites();
        await DSDatabase.instance.clearOrders();
        await DSDatabase.instance.clearProducts();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //loading widget
  loadingWidget(BuildContext context) {
    return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/icons/loading_animation.gif',
          width: 60,
          height: 60,
        ));
  }
}

//dash divider
class DashedLineHorizontalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9,
        dashSpace = 3,
        startX = 0;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//cart counter
class BadgeIcon extends StatelessWidget {
  BadgeIcon({this.icon,
    this.badgeCount = 0,
    this.showIfZero = false,
    this.badgeColor = Colors.red,
    TextStyle badgeTextStyle})
      : badgeTextStyle = badgeTextStyle ??
      TextStyle(
        color: Colors.white,
        fontSize: 8,
      );
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      icon,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) =>
      Positioned(
        right: 0,
        child: new Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(8.5),
          ),
          constraints: BoxConstraints(
            minWidth: 10,
            minHeight: 10,
          ),
          child: Text(
            count.toString(),
            style: new TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
