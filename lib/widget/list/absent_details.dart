import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsentDetailsPage extends StatefulWidget {
  const AbsentDetailsPage({super.key});

  @override
  State<AbsentDetailsPage> createState() => _AbsentDetailsPageState();
}

class _AbsentDetailsPageState extends State<AbsentDetailsPage> {
  // ~:NEW CHANGES:~
  Future<String> retrieveHighResImage(SipSalesState state) async {
    String img = '';
    await GlobalAPI.fetchAbsentHighResImage(
      GlobalVar.nip!,
      state.getAbsentHistoryDetail.date,
    ).then((String res) {
      if (res == 'not available' || res == 'failed' || res == 'error') {
        img == '';
      } else {
        img = res;
      }
    });

    return img;
  }

  void openEventPhoto(SipSalesState state) {
    GlobalDialog.loadAndPreviewImage(
      context,
      retrieveHighResImage(state),
    );
  }

  void openMap(SipSalesState state) async {
    Uri url = Uri.parse(
      'https://maps.google.com/?q=${state.getAbsentHistoryDetail.userLat},${state.getAbsentHistoryDetail.userLng}',
    );

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
        centerTitle: true,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Detail Absensi',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Detail Absensi',
                style: GlobalFont.terafontRBold,
              ),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
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
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.05,
              0.0,
            ),
            child: Wrap(
              runSpacing: MediaQuery.of(context).size.height * 0.025,
              children: [
                // ~:Photo Section:~
                Builder(
                  builder: (context) {
                    if (state.getAbsentHistoryDetail.eventThumbnail.isEmpty) {
                      return SizedBox();
                    } else {
                      return Wrap(
                        runSpacing: MediaQuery.of(context).size.height * 0.01,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Foto',
                              style: GlobalFont.giantfontRBold,
                            ),
                          ),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Image.memory(
                                    base64Decode(
                                      state.getAbsentHistoryDetail
                                          .eventThumbnail,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.195,
                                left: MediaQuery.of(context).size.width * 0.78,
                                child: GestureDetector(
                                  onTap: () => openEventPhoto(state),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.fullscreen_rounded,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),

                // ~:Map Section:~
                Wrap(
                  runSpacing: MediaQuery.of(context).size.height * 0.01,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Lokasi',
                        style: GlobalFont.giantfontRBold,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              state.getAbsentHistoryDetail.userLat,
                              state.getAbsentHistoryDetail.userLng,
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
                                Marker(
                                  width: 80.0,
                                  height: 100.0,
                                  point: LatLng(
                                    state.getAbsentHistoryDetail.userLat,
                                    state.getAbsentHistoryDetail.userLng,
                                  ),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.black,
                                    size: 60.0,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.195,
                              left: MediaQuery.of(context).size.width * 0.78,
                              child: GestureDetector(
                                onTap: () => openMap(state),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.open_in_new_rounded,
                                    size: 30,
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
