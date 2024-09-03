import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sip_sales/global/global.dart';

// ignore: must_be_immutable
class ImageView extends StatelessWidget {
  ImageView(
    this.imageDir, {
    this.lat = 0.0,
    this.lng = 0.0,
    this.startTime = '',
    this.endTime = '',
    this.isManager = false,
    super.key,
  });

  String imageDir;
  double lat;
  double lng;
  String startTime;
  String endTime;
  bool isManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.025,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[300],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 13,
              child: PhotoView.customChild(
                customSize: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.55,
                ),
                maxScale: PhotoViewComputedScale.covered * 2,
                minScale: PhotoViewComputedScale.contained,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.memory(
                              base64Decode(imageDir),
                              fit: BoxFit.cover,
                              scale: 0.55,
                              height: MediaQuery.of(context).size.height * 0.5,
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (isManager) {
                                if (startTime != '') {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.all(5.0),
                                    child: Text(
                                      startTime,
                                      style: GlobalFont.mediumgiantfontRBold,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                if (startTime != '' && endTime != '') {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '$startTime - $endTime',
                                      style: GlobalFont.mediumgiantfontRBold,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        if (lat != 0.0 && lng != 0.0) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.045,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.all(5.0),
                            child: Text(
                              '($lat, $lng)',
                              style: GlobalFont.mediumgiantfontRBold,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Kembali',
                    style: GlobalFont.mediumgiantfontR,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
