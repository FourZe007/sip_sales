import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_event.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SalesmanLocationScreen extends StatefulWidget {
  const SalesmanLocationScreen({
    required this.lat,
    required this.lng,
    super.key,
  });

  final double lat;
  final double lng;

  @override
  State<SalesmanLocationScreen> createState() => _SalesmanLocationScreenState();
}

class _SalesmanLocationScreenState extends State<SalesmanLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: Stack(
          children: [
            // ~:Maps and its details
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  widget.lat,
                  widget.lng,
                ),
                initialZoom: 19.0,
              ),
              children: [
                // ~:Flutter Map:~
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.stsj.sipsales',
                ),

                // ~:Markers:~
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 100.0,
                      height: 100.0,
                      point: LatLng(
                        widget.lat,
                        widget.lng,
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
                        (context.read<LoginBloc>().state as LoginSuccess)
                            .user
                            .latitude,
                        (context.read<LoginBloc>().state as LoginSuccess)
                            .user
                            .longitude,
                      ),
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 60.0,
                      ),
                    ),
                  ],
                ),

                // ~:Circle:~
                CircleLayer(
                  optimizeRadiusInMeters: true,
                  circles: [
                    CircleMarker(
                      point: LatLng(
                        (context.read<LoginBloc>().state as LoginSuccess)
                            .user
                            .latitude,
                        (context.read<LoginBloc>().state as LoginSuccess)
                            .user
                            .longitude,
                      ),
                      radius: 30, // Radius in meters
                      color: Colors.blue.withAlpha(51), // Fill color
                      borderColor: Colors.blue, // Border color
                      borderStrokeWidth: 2.0, // Border thickness
                      useRadiusInMeter: true,
                    ),
                  ],
                ),

                // ~:Radius Checker:~
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).padding.bottom - 20,
                  child: Container(
                    height: 75,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: (Platform.isIOS)
                          ? BorderRadius.circular(50)
                          : BorderRadius.circular(25),
                    ),
                    child: BlocBuilder<RadiusCheckerBloc, RadiusCheckerState>(
                      buildWhen: (previous, current) =>
                          (current is RadiusCheckerLoading) ||
                          (current is RadiusCheckerSuccess) ||
                          (current is RadiusCheckerError),
                      builder: (context, state) {
                        if (state is RadiusCheckerLoading) {
                          return Center(
                            child: Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          );
                        } else if (state is RadiusCheckerError) {
                          return Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ~:Status:~
                              Column(
                                spacing: 4,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ~:Status Message:~
                                  Text(
                                    state.message,
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),

                                  // ~:OSM Copyright:~
                                  GestureDetector(
                                    onTap: () => Functions.openLink(
                                      context,
                                      'https://www.openstreetmap.org/copyright',
                                    ),
                                    child: Text(
                                      '© OpenStreetMap contributors',
                                      style: TextThemes.normal.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ~:Refresh Button:~
                              IconButton(
                                onPressed: () async =>
                                    context.read<RadiusCheckerBloc>().add(
                                      RadiusCheckerEventCheck(
                                        userLat:
                                            (context.read<LoginBloc>().state
                                                    as LoginSuccess)
                                                .user
                                                .latitude,
                                        userLng:
                                            (context.read<LoginBloc>().state
                                                    as LoginSuccess)
                                                .user
                                                .longitude,
                                        currentLat: widget.lat,
                                        currentLng: widget.lng,
                                        isRefresh: true,
                                      ),
                                    ),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          );
                        } else if (state is RadiusCheckerSuccess) {
                          log('isClose? ${state.isClose.toString()}');
                          return Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                spacing: 4,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ~:Status Message:~
                                  state.isClose
                                      ? Text(
                                          'Anda berada dalam radius.',
                                          style: TextThemes.normal.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          'Anda berada di luar radius.',
                                          style: TextThemes.normal.copyWith(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                  // ~:OSM Copyright:~
                                  GestureDetector(
                                    onTap: () => Functions.openLink(
                                      context,
                                      'https://www.openstreetmap.org/copyright',
                                    ),
                                    child: Text(
                                      '© OpenStreetMap contributors',
                                      style: TextThemes.normal.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ~:Refresh Button:~
                              IconButton(
                                onPressed: () async =>
                                    context.read<RadiusCheckerBloc>().add(
                                      RadiusCheckerEventCheck(
                                        userLat:
                                            (context.read<LoginBloc>().state
                                                    as LoginSuccess)
                                                .user
                                                .latitude,
                                        userLng:
                                            (context.read<LoginBloc>().state
                                                    as LoginSuccess)
                                                .user
                                                .longitude,
                                        currentLat: widget.lat,
                                        currentLng: widget.lng,
                                        isRefresh: true,
                                      ),
                                    ),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  // ~:Status Message:~
                                  Text(
                                    'Anda berada di luar radius :)',
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),

                                  // ~:OSM Copyright:~
                                  GestureDetector(
                                    onTap: () => Functions.openLink(
                                      context,
                                      'https://www.openstreetmap.org/copyright',
                                    ),
                                    child: Text(
                                      '© OpenStreetMap contributors',
                                      style: TextThemes.normal.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ~:Refresh Button:~
                              IconButton(
                                onPressed: () async =>
                                    context.read<RadiusCheckerBloc>().add(
                                      RadiusCheckerEventCheck(
                                        userLat:
                                            (context.read<LoginBloc>().state
                                                    as LoginSuccess)
                                                .user
                                                .latitude,
                                        userLng:
                                            (context.read<LoginBloc>().state
                                                    as LoginSuccess)
                                                .user
                                                .longitude,
                                        currentLat: widget.lat,
                                        currentLng: widget.lng,
                                        isRefresh: true,
                                      ),
                                    ),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // ~:Legend:~
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 10,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.125,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
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
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                              style: TextThemes.normal.copyWith(
                                fontSize: 18,
                              ),
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
                              Formatter.toTitleCase(
                                (context.read<LoginBloc>().state
                                        as LoginSuccess)
                                    .user
                                    .locationName,
                              ),
                              style: TextThemes.normal.copyWith(
                                fontSize: 18,
                              ),
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
      ),
    );
  }
}
