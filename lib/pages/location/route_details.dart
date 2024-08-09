// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/location/image_view.dart';

class RouteDetailsPage extends StatefulWidget {
  const RouteDetailsPage({super.key});

  @override
  State<RouteDetailsPage> createState() => RouteDetailsPageState();
}

class RouteDetailsPageState extends State<RouteDetailsPage> {
  int carouselActiveIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Activity Route Details State Management
    final routeDetailsState = Provider.of<SipSalesState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Activity Details',
          style: (MediaQuery.of(context).size.width < 800)
              ? GlobalFont.giantfontRBold
              : GlobalFont.terafontRBold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: routeDetailsState.activityRouteDetailsList
              .asMap()
              .entries
              .map((entry) {
            final route = entry.value;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (routeDetailsState
                                      .imageList[routeDetailsState.getIsActive]
                                      .length >
                                  1)
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: routeDetailsState.imageList[
                                            routeDetailsState.getIsActive]
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final ModelImage image = entry.value;

                                      return InkWell(
                                        onTap: () =>
                                            routeDetailsState.openImageView(
                                          context,
                                          routeDetailsState
                                              .imageList[
                                                  routeDetailsState.getIsActive]
                                                  [routeDetailsState
                                                      .getSelectedImage]
                                              .imageDir,
                                        ),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: (image.isSelected == true)
                                                ? Border.all(
                                                    color: Colors.red,
                                                    width: 3.0,
                                                  )
                                                : Border.all(
                                                    color: Colors.transparent,
                                                  ),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                            vertical: 5.0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.memory(
                                              base64Decode(
                                                image.imageDir,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                route.contactName != ''
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              'Customer Name',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            Text(
                                              route.contactName,
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                route.contactNumber != ''
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              'Phone Number',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            Text(
                                              '+62${route.contactNumber}',
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                route.actDesc != ''
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              'Description',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            Text(
                                              route.actDesc,
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                (routeDetailsState
                                            .imageList[
                                                routeDetailsState.getIsActive]
                                            .isNotEmpty &&
                                        routeDetailsState
                                                    .imageList[routeDetailsState
                                                            .getIsActive][
                                                        routeDetailsState
                                                            .getSelectedImage]
                                                    .imageDir
                                                    .length %
                                                4 ==
                                            0)
                                    ? InkWell(
                                        onTap: () =>
                                            routeDetailsState.openImageView(
                                          context,
                                          routeDetailsState
                                              .imageList[
                                                  routeDetailsState.getIsActive]
                                                  [routeDetailsState
                                                      .getSelectedImage]
                                              .imageDir,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0,
                                            vertical: 7.5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Wrap(
                                                spacing: 15.0,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: Image.memory(
                                                      base64Decode(
                                                        routeDetailsState
                                                            .imageList[
                                                                routeDetailsState
                                                                    .getIsActive]
                                                                [
                                                                routeDetailsState
                                                                    .getSelectedImage]
                                                            .imageDir,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      scale: 10.0,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.075,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Bukti Aktivitas',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageView(
                                                        routeDetailsState
                                                            .imageList[
                                                                routeDetailsState
                                                                    .getIsActive]
                                                                [
                                                                routeDetailsState
                                                                    .getSelectedImage]
                                                            .imageDir,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Lihat',
                                                  style: GlobalFont
                                                      .mediumgiantfontRBoldBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
