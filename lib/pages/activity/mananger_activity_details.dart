// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/location/image_view.dart';

class ManagerActivityDetails extends StatelessWidget {
  ManagerActivityDetails(this.index, {super.key});

  int index;

  @override
  Widget build(BuildContext context) {
    final activityDetailsState = Provider.of<SipSalesState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.075
            : MediaQuery.of(context).size.height * 0.075,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Details',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Details',
                style: GlobalFont.terafontRBold,
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.025,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'Coordinate: (${activityDetailsState.managerActivitiesList[index].lat}, ${activityDetailsState.managerActivitiesList[index].lng})',
                  style: GlobalFont.bigfontR,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  activityDetailsState
                      .managerActivitiesList[index].activityDescription,
                  style: GlobalFont.bigfontR,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              (activityDetailsState.managerActivitiesList[index].pic1 != '')
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 7.5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 15.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.memory(
                                  base64Decode(
                                    activityDetailsState
                                        .managerActivitiesList[index].pic1,
                                  ),
                                  fit: BoxFit.cover,
                                  scale: 7.5,
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
                                  builder: (context) => ImageView(
                                    activityDetailsState
                                        .managerActivitiesList[index].pic1,
                                    startTime: activityDetailsState
                                        .managerActivitiesList[index].time,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Lihat',
                              style: GlobalFont.mediumgiantfontRBoldBlue,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
