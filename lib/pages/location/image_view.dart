import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
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
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  void openMap(
    SipSalesState state,
    double lat,
    double lng,
  ) async {
    Uri url = Uri.parse('https://maps.google.com/?q=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        // Custom Alert Dialog for Android and iOS
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Tidak dapat membuka tautan. Silakan periksa URL dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: (Platform.isIOS) ? true : false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

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
                              base64Decode(widget.imageDir),
                              fit: BoxFit.cover,
                              scale: 0.55,
                              height: MediaQuery.of(context).size.height * 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.015,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.0075,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (widget.isManager) {
                                      if (widget.startTime != '') {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[350],
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.all(5.0),
                                          margin: const EdgeInsets.all(5.0),
                                          child: Text(
                                            widget.startTime,
                                            style:
                                                GlobalFont.mediumgiantfontRBold,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    } else {
                                      if (widget.startTime != '' &&
                                          widget.endTime != '') {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[350],
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.all(5.0),
                                          margin: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${widget.startTime} - ${widget.endTime}',
                                            style:
                                                GlobalFont.mediumgiantfontRBold,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    if (widget.lat != 0.0 &&
                                        widget.lng != 0.0) {
                                      return GestureDetector(
                                        onTap: () => openMap(
                                          state,
                                          widget.lat,
                                          widget.lng,
                                        ),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey[350],
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 5,
                                            ),
                                            child: Icon(
                                              Icons.map_rounded,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                          ),
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
                        ],
                      ),
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
