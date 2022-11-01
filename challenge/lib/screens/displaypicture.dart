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
      appBar: AppBar(
        title: Text('Picture Display'),
        toolbarHeight: 40,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              DeviceInfo(),
              // const Text('Device Info'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.file(
                  photo.image as File,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                height: 80.0,
                decoration: BoxDecoration(
                  border: photo.imaggaResponse.isEmpty
                      ? null
                      : Border.all(
                          color: Colors.blueAccent,
                          width: 5.0,
                        ),
                ),
                child: SingleChildScrollView(
                  // for Vertical scrolling
                  scrollDirection: Axis.vertical,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: photo.imaggaResponse,
                    ),
                  ),
                ),
              ),

              /************ */
              ElevatedButton(
                onPressed: () {
                  photo.savePhoto();
                },
                child: const Text('Save this Picture'),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}


// """{
//   "result": {
//     "tags": [
//       {
//         "confidence": 61.4116096496582,
//         "tag": {
//           "en": "mountain"
//         }
//       },
//       {
//         "confidence": 54.3507270812988,
//         "tag": {
//           "en": "landscape"
//         }
//       },
//       {
//         "confidence": 50.969783782959,
//         "tag": {
//           "en": "mountains"
//         }
//       },
//       {
//         "confidence": 46.1385192871094,
//         "tag": {
//           "en": "wall"
//         }
//       },
//       {
//         "confidence": 40.6059913635254,
//         "tag": {
//           "en": "clouds"
//         }
//       },
//       {
//         "confidence": 37.2282066345215,
//         "tag": {
//           "en": "sky"
//         }
//       },
//       {
//         "confidence": 36.2647514343262,
//         "tag": {
//           "en": "park"
//         }
//       }"""

// Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: RichText(
//                     text: TextSpan(
//                   style: TextStyle(color: Colors.black),
//                   text: '${photo.res}',
//                 )),
//               ),