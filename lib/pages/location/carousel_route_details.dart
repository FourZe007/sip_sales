// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/provider.dart';

class CarouselRouteDetailsPage extends StatefulWidget {
  const CarouselRouteDetailsPage({super.key});

  @override
  State<CarouselRouteDetailsPage> createState() =>
      CarouselRouteDetailsPageState();
}

class CarouselRouteDetailsPageState extends State<CarouselRouteDetailsPage> {
  int carouselActiveIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Activity Route Details State Management
    final carouselRouteDetailsState = Provider.of<SipSalesState>(context);

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
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.0,
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.height * 0.85,
                    onPageChanged: (index, reason) {
                      carouselRouteDetailsState.resetSelectImage();
                      carouselRouteDetailsState.onCarouselChanged(index);
                      setState(() {
                        carouselActiveIndex = index;
                      });
                    },
                  ),
                  items: carouselRouteDetailsState.activityRouteDetailsList
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
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            (carouselRouteDetailsState
                                        .imageList[carouselRouteDetailsState
                                            .getIsActive]
                                        .isNotEmpty &&
                                    carouselRouteDetailsState
                                                .imageList[
                                                    carouselRouteDetailsState
                                                        .getIsActive][
                                                    carouselRouteDetailsState
                                                        .getSelectedImage]
                                                .imageDir
                                                .length %
                                            4 ==
                                        0)
                                ? InkWell(
                                    onTap: () =>
                                        carouselRouteDetailsState.openImageView(
                                      context,
                                      carouselRouteDetailsState
                                          .imageList[carouselRouteDetailsState
                                                  .getIsActive][
                                              carouselRouteDetailsState
                                                  .getSelectedImage]
                                          .imageDir,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.memory(
                                          base64Decode(
                                            carouselRouteDetailsState
                                                .imageList[
                                                    carouselRouteDetailsState
                                                        .getIsActive][
                                                    carouselRouteDetailsState
                                                        .getSelectedImage]
                                                .imageDir,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    child: Text(
                                      'Photos are not available',
                                      style: GlobalFont.mediumgiantfontR,
                                    ),
                                  ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (carouselRouteDetailsState
                                              .imageList[
                                                  carouselRouteDetailsState
                                                      .getIsActive]
                                              .length >
                                          1)
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: carouselRouteDetailsState
                                                .imageList[
                                                    carouselRouteDetailsState
                                                        .getIsActive]
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final int index = entry.key;
                                              final ModelImage image =
                                                  entry.value;

                                              return InkWell(
                                                onTap: () =>
                                                    carouselRouteDetailsState
                                                        .setSelectImage(
                                                  carouselRouteDetailsState
                                                      .getIsActive,
                                                  index,
                                                ),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: (image.isSelected ==
                                                            true)
                                                        ? Border.all(
                                                            color: Colors.red,
                                                            width: 3.0,
                                                          )
                                                        : Border.all(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
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
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      route.contactName,
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
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
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      '+62${route.contactNumber}',
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
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
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      route.actDesc,
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
                                                    ),
                                                  ],
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
            ),

            // Dot Indicator
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.0425,
                alignment: Alignment.center,
                child: DotsIndicator(
                  dotsCount: carouselRouteDetailsState.imageList.length,
                  position: carouselRouteDetailsState.getIsActive,
                  decorator: DotsDecorator(
                    size: const Size(8.0, 8.0),
                    activeSize: const Size(12.0, 12.0),
                    activeColor: Colors.blue[700],
                    // activeColor: Colors.blue,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
