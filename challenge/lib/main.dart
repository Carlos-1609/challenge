import 'package:camera/camera.dart';
import 'package:challenge/providers/battery_provider.dart';
import 'package:challenge/providers/connectivity_provider.dart';
import 'package:challenge/providers/photo_provider.dart';
import 'package:challenge/screens/camera.dart';
import 'package:challenge/screens/displaypicture.dart';
import 'package:challenge/screens/photogallery.dart';
import 'package:challenge/screens/homepage.dart';
import 'package:challenge/screens/takephoto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  runApp(MyApp(
    camera: cameras,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});
  final List<CameraDescription> camera;

  // This widget is the root of your application.
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
          PhotoGallery.routeName: (context) => const PhotoGallery(),
          TakePhoto.routeName: (context) => const TakePhoto(),
          Camera.routeName: (context) => Camera(cameras: camera),
          DisplayPicture.routeName: (context) => const DisplayPicture(),
        },
      ),
    );
  }
}
