import 'dart:io';

import 'package:camera/camera.dart';
import 'package:challenge/screens/displaypicture.dart';
import 'package:challenge/widgets/deviceinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/photo_provider.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Camera({super.key, required this.cameras});
  static const routeName = '/camera';

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    initCamera(selectedCameraIdx);
  }

  initCamera(int indexCamera) async {
    _cameraController =
        CameraController(widget.cameras[indexCamera], ResolutionPreset.high);
    //cameraValue = _cameraController.initialize();

    // If the controller is updated then update the UI.
    // 4
    _cameraController.addListener(
      () {
        // 5
        if (mounted) {
          setState(() {});
        }

        if (_cameraController.value.hasError) {
          print('Camera error ${_cameraController.value.errorDescription}');
        }
      },
    );

    // 6
    try {
      cameraValue = _cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = Provider.of<PhotoProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const DeviceInfo(),
                  //const Text('Device Info'),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: photo.isImageTaken,
                    child: ElevatedButton(
                      child: const Text('Clear'),
                      onPressed: () {
                        photo.setIsImageTaken = false;
                      },
                    ),
                  )
                ],
              ),
              !photo.isImageTaken
                  ? FutureBuilder(
                      future: cameraValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CameraPreview(_cameraController),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.file(
                        photo.image as File,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // print('List of cameras: ${widget.cameras}');
                        // onSwitchCamera()
                        selectedCameraIdx =
                            selectedCameraIdx < 1 ? selectedCameraIdx + 1 : 0;
                        //CameraDescription selectedCamera = widget.cameras[selectedCameraIdx];
                        print(widget.cameras[selectedCameraIdx]);
                        initCamera(selectedCameraIdx);
                      },
                      child: const Text('Flip Camera')),
                  ElevatedButton(
                      onPressed: () {
                        photo.takePhoto(
                          cameraController: _cameraController,
                          cameraValue: cameraValue,
                          mounted: mounted,
                        );
                      },
                      child: const Text('Take Picture')),
                  ElevatedButton(
                      onPressed: photo.isImageTaken
                          ? () {
                              Navigator.of(context).pushReplacementNamed(
                                  DisplayPicture.routeName);
                            }
                          : null,
                      child: const Text('Next'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}