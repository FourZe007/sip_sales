import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sip_sales/global/global.dart';

// ignore: must_be_immutable
class ImageView extends StatelessWidget {
  ImageView(this.imageDir, {super.key});

  String imageDir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Image Preview',
          style: (MediaQuery.of(context).size.width < 800)
              ? GlobalFont.giantfontRBold
              : GlobalFont.terafontRBold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
      ),
      body: PhotoView(
        maxScale: PhotoViewComputedScale.covered * 2,
        minScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        imageProvider: MemoryImage(base64Decode(imageDir)),
      ),
    );
  }
}
