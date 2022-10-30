import 'dart:io';

import 'package:challenge/providers/photo_provider.dart';
import 'package:challenge/widgets/deviceinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class DisplayPicture extends StatefulWidget {
  const DisplayPicture({super.key});
  static const routeName = '/displayPicture';

  @override
  State<DisplayPicture> createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  @override
  Widget build(BuildContext context) {
    final photo = Provider.of<PhotoProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            DeviceInfo(),
            // const Text('Device Info'),
            Image.file(
              photo.image as File,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            ElevatedButton(
                onPressed: () {
                  photo.savePhoto();
                },
                child: const Text('Save this Picture'))
          ],
        ),
      )),
    );
  }
}
