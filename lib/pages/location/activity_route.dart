// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/location/carousel_route_details.dart';
import 'package:sip_sales/pages/location/route_details.dart';
import 'package:sip_sales/pages/map/map_list.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class ActivityRoutePage extends StatefulWidget {
  const ActivityRoutePage({super.key});

  @override
  State<ActivityRoutePage> createState() => _ActivityRoutePageState();
}

class _ActivityRoutePageState extends State<ActivityRoutePage> {
  // Map Details
  String employeeID = '';
  List<ModelActivityRoute> activityRouteList = [];

  // Filter
  String filterDate = DateTime.now().toString().substring(0, 10);

  // Location Service
  Location location = Location();
  double? latitude = 0.0;
  double? longitude = 0.0;
  String time = '';

  void setDate(String value) {
    filterDate = value;
  }

  void setDateFilter(
    BuildContext context,
    String tgl,
    Function handle,
  ) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      setState(() {
        tgl = picked.toString().substring(0, 10);
      });
      handle(tgl);
    }
  }

  void openMap(List<ModelActivityRoute> list) {
    // Note -> navigate to MapListPage which will display bigger size of the map
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapListPage(list),
      ),
    );
  }

  void navigatePage(
    int index,
    List<ModelActivityRoute> list,
  ) {
    if (list[index].detail.isEmpty) {
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Details are not available.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Details are not available.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    } else {
      if (list[index].detail.length > 1) {
        // print('more than 1');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CarouselRouteDetailsPage(),
          ),
        );
      } else {
        // print('less than equal to 1');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RouteDetailsPage(),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    employeeID = '';
    activityRouteList.clear();
    filterDate = '';

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider State Management
    final activityRouteState = Provider.of<SipSalesState>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.05,
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.12,
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Open Filter Button
                InkWell(
                  onTap: null,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.025,
                ),
                // Modify Begin Date
                InkWell(
                  onTap: () => setDateFilter(
                    context,
                    filterDate,
                    setDate,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Text(
                      Format.tanggalFormat(filterDate),
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6425,
            alignment: Alignment.center,
            child: FutureBuilder<List<ModelActivityRoute>>(
              future: activityRouteState.fetchActivityRouteList(filterDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleLoading(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'Loading...',
                        style: GlobalFont.mediumgiantfontR,
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            snapshot
                                .data![activityRouteState.getLocationIndex].lat,
                            snapshot
                                .data![activityRouteState.getLocationIndex].lng,
                          ),
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
                              for (int i = 0; i < snapshot.data!.length; i++)
                                Marker(
                                  width: 80.0,
                                  height: 110.0,
                                  point: LatLng(
                                    snapshot.data![i].lat,
                                    snapshot.data![i].lng,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      activityRouteState.setLocationIndex(i);

                                      activityRouteState.fetchDetailsProcessing(
                                        activityRouteState.getLocationIndex,
                                      );

                                      activityRouteState.resetIsActive();

                                      navigatePage(
                                        activityRouteState.getLocationIndex,
                                        activityRouteState.activityRouteList,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.black,
                                          size: 50.0,
                                        ),
                                        Text(
                                          snapshot.data![i].startTime
                                              .substring(0, 5),
                                          style: GlobalFont.giantfontRBold,
                                        ),
                                        Text(
                                          snapshot.data![i].endTime
                                              .substring(0, 5),
                                          style: GlobalFont.giantfontRBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 7.5,
                          vertical: 3.0,
                        ),
                        child: IconButton(
                          onPressed: () => openMap(snapshot.data!),
                          icon: const Icon(
                            Icons.aspect_ratio_rounded,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
