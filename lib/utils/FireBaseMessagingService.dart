// ignore_for_file: non_constant_identifier_names, file_names, unnecessary_const, import_of_legacy_library_into_null_safe

import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/page/HomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings());
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      const id = 11;
      const NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'firebasepushnotificationdemo',
          'firebasepushnotificationdemo channel',
          channelDescription: 'this is our channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(),
      );

      await _notificationsPlugin.show(
        id,
        message.data['title'],
        message.data['description'],
        notificationDetails,
        // payload: message.data['route'],
      );

      String orderId = message.data['transaction_id'].toString();
      String orderStatus = message.data['transation_status'];
      await DSDatabase.instance
          .updateorderStatus(int.tryParse(orderId), orderStatus);
    } on Exception catch (e) {
      print(e);
    }
  }
}
