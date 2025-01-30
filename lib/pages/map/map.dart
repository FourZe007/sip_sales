// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';

class MapPage extends StatefulWidget {
  MapPage(this.longitude, this.latitude, {super.key});

  double longitude;
  double latitude;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // ~:Not Used for awhile:~
  Stream<String> fetchCoordinateToAddress(
    double lat,
    double lng,
  ) async* {
    // Convert the coordinates to an address
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    // Get the first result (if available)
    if (placemarks.isNotEmpty) {
      Placemark firstResult = placemarks.first;
      print('Placemark: $firstResult');

      // Access the street address
      String address = firstResult.street!;
      print('Address: $address');

      // Print the address
      print('Address: $address');
      yield firstResult.street!;
    }

    yield '';
  }

  Stream<bool> fetchIsClose() async* {
    bool isClose = false;

    await for (Position position in Geolocator.getPositionStream()) {
      isClose = await GlobalAPI.fetchIsWithinRadius(
        GlobalVar.userAccountList[0].latitude,
        GlobalVar.userAccountList[0].longitude,
        position.latitude,
        position.longitude,
      ).then((state) {
        if (state == 'NOT OK') {
          return false;
        } else {
          return true;
        }
      });

      yield isClose;
    }
  }

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
          initialCenter: LatLng(widget.latitude, widget.longitude),
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
                height: 100.0,
                point: LatLng(
                  widget.latitude,
                  widget.longitude,
                ),
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.black,
                  size: 60.0,
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(
                  GlobalVar.userAccountList[0].latitude,
                  GlobalVar.userAccountList[0].longitude,
                ),
                child: const Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                  size: 60.0,
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 25,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: (Platform.isIOS)
                    ? BorderRadius.circular(50)
                    : BorderRadius.circular(25),
              ),
              child: StreamBuilder(
                stream: fetchIsClose(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return Text(
                        'Anda berada dalam radius',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      );
                    } else {
                      return Text(
                        'Anda berada di luar radius',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      );
                    }
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
