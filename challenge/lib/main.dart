import 'package:camera/camera.dart';
import 'package:challenge/providers/battery_provider.dart';
import 'package:challenge/providers/connectivity_provider.dart';
import 'package:challenge/providers/photo_provider.dart';
import 'package:challenge/screens/camera.dart';
import 'package:challenge/screens/displaypicture.dart';
import 'package:challenge/screens/homepage.dart';
import 'package:challenge/screens/takephoto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  runApp(MyApp(
    camera: cameras,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.camera});
  final List<CameraDescription> camera;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   NotificationProvider.initialize(flutterLocalNotificationsPlugin);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.detached) return;
  //   final isAppBackground = state == AppLifecycleState.detached;
  //   if (isAppBackground) {
  //     NotificationProvider.showTextNotification(
  //         title: "Leaving the app",
  //         body: "Press to go back to the app",
  //         fln: flutterLocalNotificationsPlugin);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BatteryProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => PhotoProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          TakePhoto.routeName: (context) => const TakePhoto(),
          Camera.routeName: (context) => Camera(cameras: widget.camera),
          DisplayPicture.routeName: (context) => const DisplayPicture(),
        },
      ),
    );
  }
}
