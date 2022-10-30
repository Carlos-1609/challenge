import 'dart:io';
import 'package:camera/camera.dart';
import 'package:challenge/widgets/deviceinfo.dart';
import 'package:flutter/material.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({super.key});

  ///final CameraDescription camera;
  static const routeName = '/takephoto';

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  late CameraController _controller;
  late List<CameraDescription> _availableCameras;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
    // // To display the current output from the Camera,
    // // create a CameraController.
    // _controller = CameraController(widget.camera, ResolutionPreset.high);

    // // Next, initialize the controller. This returns a Future.
    //_initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras.first);
  }

  Future<void> _initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.max);
    try {
      await _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  takeImage() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      if (!mounted) return;

      // If the picture was taken, display it on a new screen.
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPictureScreen(
      //       // Pass the automatically generated path to
      //       // the DisplayPictureScreen widget.
      //       imagePath: image.path,
      //     ),
      //   ),
      // );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const DeviceInfo(),
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Flip Camera')),
              ElevatedButton(onPressed: () {}, child: Text('Take Picture')),
              ElevatedButton(onPressed: () {}, child: Text('Next'))
            ],
          )
        ],
      ),
    );
  }
}

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }