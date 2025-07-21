// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Calculated pixel radius
  double radius = 60.0;

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

  Stream<bool> fetchIsClose(SipSalesState state) async* {
    bool isClose = false;

    try {
      await GlobalAPI.fetchIsWithinRadius(
        state.getUserAccountList[0].latitude,
        state.getUserAccountList[0].longitude,
        state.getLatDisplay,
        state.getLngDisplay,
      ).then((state) {
        if (state == 'NOT OK') {
          isClose = false;
        } else {
          isClose = true;
        }
      });
    } catch (e) {
      print(e.toString());
      isClose = false;
    }

    yield isClose;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Builder(
              builder: (context) {
                if (Platform.isIOS) {
                  return IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Kembali',
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: (MediaQuery.of(context).size.width < 800) ? 25 : 35,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Kembali',
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: (MediaQuery.of(context).size.width < 800) ? 25 : 35,
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ~:Maps and its details
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                state.getLatDisplay,
                state.getLngDisplay,
              ),
              initialZoom: 19.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.stsj.sipsales',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 100.0,
                    height: 100.0,
                    point: LatLng(
                      state.getLatDisplay,
                      state.getLngDisplay,
                    ),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.black,
                      size: 60.0,
                    ),
                  ),
                  Marker(
                    width: 100.0,
                    height: 100.0,
                    point: LatLng(
                      state.getUserAccountList[0].latitude,
                      state.getUserAccountList[0].longitude,
                    ),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 60.0,
                    ),
                  ),
                ],
              ),
              // Add the circle around the pin location
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(
                      state.getUserAccountList[0].latitude,
                      state.getUserAccountList[0].longitude,
                    ),
                    radius: radius, // Radius in meters
                    color: Colors.blue.withOpacity(0.2), // Fill color
                    borderColor: Colors.blue, // Border color
                    borderStrokeWidth: 2.0, // Border thickness
                    useRadiusInMeter: true,
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
                    stream: fetchIsClose(state),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      } else if (snapshot.hasError) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${snapshot.error}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data == true) {
                          return Text(
                            'Anda berada dalam radius',
                            style: GlobalFont.giantfontRBold,
                          );
                        } else {
                          return Text(
                            'Anda berada di luar radius',
                            style: GlobalFont.giantfontRBoldRed,
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // ~:Legend:~
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            right: 10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.125,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ~:Legend Title:~
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Informasi',
                        style: GlobalFont.bigfontRBold,
                      ),
                    ),
                  ),

                  // ~:Legend Details 1:~
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.black,
                          size: 30,
                        ),
                        Expanded(
                          child: Text(
                            'Lokasi Anda',
                            style: GlobalFont.bigfontR,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ~:Legend Details 2:~
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 30,
                        ),
                        Expanded(
                          child: Text(
                            state.getUserAccountList[0].locationName,
                            style: GlobalFont.bigfontR,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
