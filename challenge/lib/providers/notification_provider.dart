import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showTextNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_ids',
      'channel_names',
      importance: Importance.max,
      priority: Priority.high,
    );

    var notification = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    await fln.show(0, title, body, notification);
    print('se mando la notification');
  }
  // static final _notifications = FlutterLocalNotificationsPlugin();

  // static Future _notificationDetails() async {
  //   return NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'channel id',
  //         'channel name',
  //         channelDescription: 'channel description',
  //       ),
  //       iOS: DarwinNotificationDetails());
  // }

  // static Future showNotification(
  //         {int id = 0, String? title, String? body, String? payload}) async =>
  //     _notifications.show(id, title, body, await _notificationDetails(),
  //         payload: payload);
}
