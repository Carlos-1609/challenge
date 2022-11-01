import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:challenge/screens/displaypicture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
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
    // await FlutterNativeImage.compressImage(_imagePath, quality: 5);
    Uint8List imagebytes = await image!.readAsBytes();
    // base64String = base64.encode(imagebytes);
    final result = await ImageGallerySaver.saveImage(imagebytes);
    print(result);
    fetchImagga();
    notifyListeners();
  }

  fetchImagga() async {
    //'https://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg'
    try {
      // print('esta es la image:');
      // print(image);
      // print('esta es la image path');
      // print(_imagePath);

      // const apiKey = 'acc_20a56c934c2b43a';
      // const apiSecret = '085afbeab88c89b6d52f07541efb73ab';
      // const imageUrl =
      //     'https://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg';
      var url = Uri.https(
          'api.imagga.com', '/v2/tags', {'image_base64': base64String});
      print(url);
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Basic YWNjXzIwYTU2YzkzNGMyYjQzYTowODVhZmJlYWI4OGM4OWI2ZDUyZjA3NTQxZWZiNzNhYg==',
        },
      );
      imaggaResponse = response.body;
      // print('el body: ');
      // print(response.body);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      notifyListeners();
      print(responseData);

      // print(responseData['result']['upload_id']);
      // imageId = responseData['result']['upload_id'];

      // if (imageId == '') return;

      // url =
      //     Uri.https('api.imagga.com', '/v2/tags', {'image_upload_id': imageId});
      // response = await http.get(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'authorization':
      //         'Basic YWNjXzIwYTU2YzkzNGMyYjQzYTowODVhZmJlYWI4OGM4OWI2ZDUyZjA3NTQxZWZiNzNhYg==',
      //   },
      // );
      // print('el body: ');
      // print(response.body);
    } catch (error) {
      rethrow;
    }
  }
}
