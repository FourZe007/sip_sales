// ignore_for_file: must_be_immutable

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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          alignment: Alignment.center,
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30.0,
              color: Colors.white,
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
                  // Icons.pin_drop_rounded,
                  Icons.location_on_rounded,
                  color: Colors.black,
                  size: 50.0,
                ),
              ),
              // Add more markers as needed using the same structure
            ],
          ),
        ],
      ),
    );
  }
}
