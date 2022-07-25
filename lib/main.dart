// @dart=2.9
// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:developer';

import 'package:doorstep_banking_flutter/page/HomePage.dart';
import 'package:doorstep_banking_flutter/page/SplashScreenPage.dart';
import 'package:doorstep_banking_flutter/utils/FireBaseMessagingService.dart';
import 'package:doorstep_banking_flutter/utils/LocationProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';

import 'Helper/PrefManager.dart';
import 'Localization/language_constants.dart';
import 'generated/l10n.dart';

///receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PrefManager.init();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = '';
  String NOTIFICATION_CHANNEL_ID = "com.itw.firebasepushnotificationdemo";
  final int NOTIFICATION_ID = 11;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      print(message.data.toString());
      if (message.data != null) {
        print(message.data['description']);
        print(message.data['title']);
      }

      LocalNotificationService.display(message);
    });

    ///when the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    });

    getDeviceToken();
  }

  //getting device token
  getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value;
    });
    log('Token:$token');
  }

  Future<void> initPlatformState() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
      print(udid.toString());
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }

    if (!mounted) return;

    setState(() {
      udid = udid;
      if (PrefManager.getKeyDeviceId() == null) {
        PrefManager.saveKeyDeviceId(udid);
        log('deviceId: $udid');
        String deviceId = PrefManager.getKeyDeviceId() ?? '';
        log('keydeviceId: $deviceId');
      } else {}
    });
  }

  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: const HomePage(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => LocationProvider(),
        //   child: ManageAddressPage(),
        // ),
      ],
      child: _locale == null
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.purple[800])),
            )
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Flutter Localization Demo",
              theme: ThemeData(primarySwatch: Colors.purple),
              locale: _locale,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              // onGenerateRoute: AppRouter.generatedRoute,
              home: const SplashScreen(),
            ),
    );
  }
}
