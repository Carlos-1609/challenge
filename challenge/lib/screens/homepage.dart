import 'package:challenge/providers/notification_provider.dart';
import 'package:challenge/providers/photo_provider.dart';

import 'package:challenge/widgets/deviceinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    photo.imaggaResponse = '';
                    Navigator.of(context).pushNamed(Camera.routeName);
                  },
                  child: Text('Take new picture'),
                ),
                ElevatedButton(
                  onPressed: () {
                    photo.imaggaResponse = '';
                    photo.pickImage(context, ImageSource.gallery);
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
