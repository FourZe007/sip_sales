// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/status/failure_animation.dart';
import 'package:sip_sales/widget/status/loading_animation.dart';
import 'package:sip_sales/widget/status/success_animation.dart';
import 'package:sip_sales/widget/textfield/adjustabledescbox.dart';

class EventDescPage extends StatefulWidget {
  const EventDescPage({super.key});

  @override
  State<EventDescPage> createState() => _EventDescPageState();
}

class _EventDescPageState extends State<EventDescPage> {
  bool isLoading = false;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void eventPhotoInteraction(
    BuildContext context,
    SipSalesState state,
  ) async {
    if (state.getEventPhoto.isEmpty || state.getEventPhoto == null) {
      await state.uploadImageFromCamera(context).then((isUploaded) {
        if (isUploaded) {
          state.setEventPhoto(state.getFilteredList[0]);
          FocusScope.of(context).unfocus();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccessAnimationPage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FailureAnimationPage(),
            ),
          );
        }
      });
    } else {
      // Display image by pop it up
      GlobalDialog.previewImage(context, state.getEventPhoto);
    }
    FocusScope.of(context).unfocus();
  }

  void createEvent(SipSalesState state) async {
    print('Create Event Function');
    setIsLoading(true);
    await state.eventCheckIn().then((value) {
      setIsLoading(false);
      if (value == 'sukses') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingAnimationPage(
              false,
              false,
              false,
              true,
              false,
              false,
              stateMessage: value,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingAnimationPage(
              false,
              false,
              false,
              true,
              false,
              false,
              stateMessage: value,
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<SipSalesState>(context, listen: false)
        .eventTextController
        .clear();
    Provider.of<SipSalesState>(context, listen: false).eventPhoto = '';
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Event',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Event',
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.075,
              MediaQuery.of(context).size.height * 0.03,
              MediaQuery.of(context).size.width * 0.075,
              MediaQuery.of(context).size.height * 0.015,
            ),
            child: Column(
              children: [
                // ~:Page Content:~
                Expanded(
                  child: Wrap(
                    runSpacing: MediaQuery.of(context).size.height * 0.025,
                    children: [
                      // ~:Header:~
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Event',
                            style: GlobalFont.giantfontRBold,
                          ),
                          Text(
                            'Masukkan informasi terkait event dengan lengkap.',
                            style: GlobalFont.bigfontR,
                          ),
                        ],
                      ),

                      // ~:Content:~
                      Wrap(
                        runSpacing: 20,
                        children: [
                          // ~:Description Box:~
                          AdjustableDescBox(state.eventTextController),

                          // ~:Photo Box:~
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DottedBorder(
                              // Dash length: 6, Gap length: 3
                              dashPattern: const [6, 3],
                              strokeWidth: 2,
                              color: Colors.grey,
                              // Rounded rectangle border
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: GestureDetector(
                                onTap: () =>
                                    eventPhotoInteraction(context, state),
                                onLongPress: () {
                                  if (state.getEventPhoto.isNotEmpty) {
                                    // Delete image
                                    print('Delete image');
                                    state.setEventPhoto('');
                                  }
                                },
                                child: Builder(
                                  builder: (context) {
                                    if (state.getEventPhoto.isEmpty) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.125,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Tap to add photos',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            base64Decode(state.getEventPhoto),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.125,
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ~:Button Section:~
                ElevatedButton(
                  onPressed: () => createEvent(state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      if (isLoading) {
                        if (Platform.isIOS) {
                          return CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.white,
                          );
                        } else {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                      } else {
                        return Text(
                          'Buat',
                          style: GlobalFont.mediumgiantfontR,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
