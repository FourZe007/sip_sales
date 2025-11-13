import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class SalesmanAttandanceDetailsScreen extends StatefulWidget {
  const SalesmanAttandanceDetailsScreen({
    this.photo = '',
    this.lat = 0.0,
    this.lng = 0.0,
    super.key,
  });

  final String photo;
  final double lat;
  final double lng;

  @override
  State<SalesmanAttandanceDetailsScreen> createState() =>
      _SalesmanAttandanceDetailsScreenState();
}

class _SalesmanAttandanceDetailsScreenState
    extends State<SalesmanAttandanceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            'Detail Absensi',
            style: TextThemes.normal.copyWith(fontSize: 16),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_back_rounded,
              size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
              color: Colors.black,
            ),
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              widget.photo.isNotEmpty ? 16 : 0,
              20,
              8,
            ),
            child: Column(
              spacing: 20,
              children: [
                // ~:Photo Section:~
                Builder(
                  builder: (context) {
                    if (widget.photo.isNotEmpty) {
                      return Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ~:Title:~
                          Text(
                            'Foto',
                            style: TextThemes.normal.copyWith(fontSize: 16),
                          ),

                          // ~:Body:~
                          Stack(
                            children: [
                              // ~:Photo:~
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Image.memory(
                                    base64Decode(widget.photo),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              // ~:Enlarge Photo Icon:~
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.185,
                                left: MediaQuery.of(context).size.width * 0.75,
                                child: GestureDetector(
                                  onTap: () => Functions.viewPhoto(
                                    context,
                                    widget.photo,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.fullscreen_rounded,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),

                // ~:Map Section:~
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ~:Title:~
                    Text(
                      'Lokasi',
                      style: TextThemes.normal.copyWith(fontSize: 16),
                    ),

                    // ~:Body:~
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(widget.lat, widget.lng),
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.stsj.sipsales',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 100.0,
                                  point: LatLng(widget.lat, widget.lng),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.black,
                                    size: 60.0,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.185,
                              left: MediaQuery.of(context).size.width * 0.75,
                              child: GestureDetector(
                                onTap: () => Functions.openMap(
                                  widget.lat,
                                  widget.lng,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.open_in_new_rounded,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
