import 'package:challenge/providers/photo_provider.dart';

import 'package:challenge/widgets/deviceinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../providers/notification_provider.dart';
import 'camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool showNotification = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationProvider.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isAppBackground = state == AppLifecycleState.paused;
    if (isAppBackground && showNotification) {
      NotificationProvider.showTextNotification(
          title: "Leaving the app",
          body: "Press to go back to the app",
          fln: flutterLocalNotificationsPlugin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = Provider.of<PhotoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        toolbarHeight: 40,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const DeviceInfo(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //photo.pickImage(context, ImageSource.camera);
                    photo.setIsImageTaken = false;
                    photo.showResponse = false;
                    photo.imaggaResponse = '';
                    Navigator.of(context).pushNamed(Camera.routeName);
                  },
                  child: Text('Take new picture'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showNotification = false;
                    photo.imaggaResponse = '';
                    photo.showResponse = false;
                    if (Platform.isAndroid) {
                      await photo.pickImage(context, ImageSource.gallery);
                      showNotification = true;
                    } else {
                      photo.pickImage(context, ImageSource.gallery);
                      showNotification = true;
                    }
                  },
                  child: Text('Load Picture from Gallery'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
