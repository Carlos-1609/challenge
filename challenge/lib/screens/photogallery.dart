import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/photo_provider.dart';

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key});
  static const routeName = '/gallery';

  @override
  Widget build(BuildContext context) {
    final photo = Provider.of<PhotoProvider>(context);
    return Scaffold(
      body: Center(
        child: photo.image != null
            ? Image.file(
                photo.image as File,
                width: 160,
                height: 160,
              )
            : const FlutterLogo(),
      ),
    );
  }
}
