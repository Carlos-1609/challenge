import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:challenge/screens/displaypicture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PhotoProvider with ChangeNotifier {
  File? image; //path de la image file
  XFile? _compressedFile;
  String _imagePath = '';
  String imageId = '';
  String? base64String;
  bool isImageTaken = false;
  var imaggaResponse = '';

  set setIsImageTaken(bool imageState) {
    isImageTaken = imageState;
    notifyListeners();
  }

  pickImage(BuildContext ctx, ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      _compressedFile = image;
      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      notifyListeners();
      Navigator.of(ctx).pushNamed(DisplayPicture.routeName);
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
    _imagePath =
        '$appDocPath/$fileName'; //este es el directorio donde esta la imagen en el phone
    Uint8List imagebytes = await image!.readAsBytes();
    base64String = base64.encode(imagebytes);
    final result = await ImageGallerySaver.saveImage(imagebytes);
    print(result);
    fetchImagga();
    notifyListeners();
  }

  fetchImagga() async {
    try {
      var url = Uri.https('api.imagga.com', '/v2/tags');
      var response = await http.post(
        url,
        body: {'image_base64': base64String},
        headers: {
          'authorization':
              'Basic YWNjXzIwYTU2YzkzNGMyYjQzYTowODVhZmJlYWI4OGM4OWI2ZDUyZjA3NTQxZWZiNzNhYg==',
        },
      );
      imaggaResponse = response.body;
      Map<String, dynamic> responseData = jsonDecode(response.body);
      notifyListeners();
      print(responseData);
    } catch (error) {
      rethrow;
    }
  }
}
