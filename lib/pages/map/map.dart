// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  MapPage(this.longitude, this.latitude, {super.key});

  double longitude;
  double latitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Builder(
              builder: (context) {
                if (Platform.isIOS) {
                  return const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  );
                } else {
                  return const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.stsj.sipsales',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(
                  latitude,
                  longitude,
                ),
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.black,
                  size: 60.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
