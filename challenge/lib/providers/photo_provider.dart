import 'dart:io';
import 'package:camera/camera.dart';
import 'package:challenge/screens/displaypicture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../screens/photogallery.dart';

class PhotoProvider with ChangeNotifier {
  File? image;
  bool isImageTaken = false;

  set setIsImageTaken(bool imageState) {
    isImageTaken = imageState;
    notifyListeners();
  }

  pickImage(BuildContext ctx, ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      notifyListeners();
      Navigator.of(ctx).pushReplacementNamed(DisplayPicture.routeName);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  takePhoto(
      {required CameraController cameraController,
      required Future<void> cameraValue,
      required bool mounted}) async {
    try {
      // Ensure that the camera is initialized.
      await cameraValue;
      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final tmpImage = await cameraController.takePicture();
      image = File(tmpImage.path);
      isImageTaken = true;
      notifyListeners();
      print(image);
      if (!mounted) return;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  savePhoto() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final fileName = basename(image!.path);
    await GallerySaver.saveImage('$appDocPath/$fileName');
  }
}
