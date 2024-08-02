// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/location/carousel_route_details.dart';
import 'package:sip_sales/pages/location/route_details.dart';

class MapListPage extends StatefulWidget {
  MapListPage(this.activityRouteList, {super.key});

  List<ModelActivityRoute> activityRouteList;

  @override
  State<MapListPage> createState() => _MapListPageState();
}

class _MapListPageState extends State<MapListPage> {
  void navigatePage(
    int index,
    List<ModelActivityRoute> list,
  ) {
    if (list[index].detail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[400],
          content: Text(
            'Activity details are not available',
            style: GlobalFont.mediumgiantfontR,
          ),
        ),
      );
    } else {
      if (list[index].detail.length > 1) {
        print('more than 1');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CarouselRouteDetailsPage(),
          ),
        );
      } else {
        print('less than equal to 1');
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
  Widget build(BuildContext context) {
    // Provider State Management
    final mapListState = Provider.of<SipSalesState>(context);

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
          initialCenter: LatLng(
            // Note -> error disini
            widget.activityRouteList[0].lat,
            widget.activityRouteList[0].lng,
          ),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.stsj.sipsales',
          ),
          MarkerLayer(
            markers: [
              for (int i = 0; i < widget.activityRouteList.length; i++)
                Marker(
                  width: 80.0,
                  height: 110.0,
                  point: LatLng(
                    widget.activityRouteList[i].lat,
                    widget.activityRouteList[i].lng,
                  ),
                  child: InkWell(
                    onTap: () {
                      mapListState.setLocationIndex(i);

                      mapListState.fetchDetailsProcessing(
                        mapListState.getLocationIndex,
                      );

                      mapListState.resetIsActive();

                      navigatePage(
                        mapListState.getLocationIndex,
                        mapListState.activityRouteList,
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
                          widget.activityRouteList[i].startTime.substring(0, 5),
                          style: GlobalFont.giantfontRBold,
                        ),
                        Text(
                          widget.activityRouteList[i].endTime.substring(0, 5),
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
    );
  }
}
