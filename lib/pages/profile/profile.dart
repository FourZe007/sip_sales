// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/profile/change_password.dart';
import 'package:sip_sales/widget/button/colored_button.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/status/failure_animation.dart';
import 'package:sip_sales/widget/status/loading_animation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  bool isLoggedOut = false;
  PanelController panelController = PanelController();

  void logout(SipSalesState state) async {
    setIsLoading();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // String tempDeviceID = prefs.getString('deviceID') ?? '';
    prefs.clear();
    state.setProfilePicture('');
    state.setProfilePicturePreview('');
    state.setLocationIndex(0);

    setIsLoading();

    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
  }

  void toggleLogOutPage() {
    print('Toggle LogOut Page pressed!!');
    setState(() {
      isLoggedOut = !isLoggedOut;
      if (isLoggedOut == true) {
        panelController.open();
      } else {
        panelController.close();
      }
    });
  }

  Future<double> getDeviceWidth() async {
    return MediaQuery.of(context).size.width;
  }

  void launchLink(BuildContext context) async {
    Uri url =
        Uri.parse('https://yamaha-jatim.co.id/PrivacyPolicySIPSales.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Custom Alert Dialog for Android and iOS
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Unable to open the link. Please check the URL and try again.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oops!',
          'Unable to open the link. Please check the URL and try again.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
  }

  void takePhoto(BuildContext context, SipSalesState state) async {
    print('Take Photo pressed!');
    await state.takeProfilePictureFromCamera(context).then((bool isAvailable) {
      if (isAvailable) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingAnimationPage(
              false,
              false,
              false,
              false,
              true,
              false,
            ),
          ),
        );
      } else {
        // state.setIsProfileUploaded(false);
        state.displayDescription = 'Profil gagal diunggah.';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FailureAnimationPage(),
          ),
        );
      }
    });
  }

  void viewPhoto(
    BuildContext context,
    SipSalesState state,
  ) {
    try {
      print('High Res Image: ${state.getProfilePicturePreview}');
      GlobalDialog.previewProfileImage(
        context,
        state.getProfilePicturePreview,
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void changePassword(SipSalesState state) {
    state.employeeID = state.getUserAccountList[0].employeeID;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePasswordPage(),
      ),
    );
  }

  Future<void> getUserLatestData(SipSalesState state) async {
    final prefs = await SharedPreferences.getInstance();

    // setIsLoading();
    try {
      await GlobalAPI.fetchUserAccount(
        GlobalVar.nip!,
        GlobalVar.password!,
        state.getUUID,
      ).then((res) {
        state.setUserAccountList(res);
      });

      if (state.getUserAccountList.isNotEmpty &&
          state.getProfilePicture.isEmpty &&
          state.getProfilePicturePreview.isEmpty) {
        state.setProfilePicture(state.getUserAccountList[0].profilePicture);
        await GlobalAPI.fetchShowImage(state.getUserAccountList[0].employeeID)
            .then((String highResImg) async {
          if (highResImg == 'not available' ||
              highResImg == 'failed' ||
              highResImg == 'error') {
            state.setProfilePicturePreview('');
            await prefs.setString('highResImage', '');
            print('High Res Image is not available.');
          } else {
            state.setProfilePicturePreview(highResImg);
            await prefs.setString('highResImage', highResImg);
            print('High Res Image successfully loaded.');
            print('High Res Image: $highResImg');
          }
        });
      }
    } catch (e) {
      print('Fetch User Latest Data failed: ${e.toString()}');
      state.setProfilePicturePreview('');
      await prefs.setString('highResImage', '');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Terjadi kesalahan, mohon coba lagi.',
          style: GlobalFont.bigfontRWhite,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
      ));
    }
    // setIsLoading();
  }

  Widget profileBody(SipSalesState state) {
    return Column(
      children: [
        // ~:Profile Section:~
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.grey[100],
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.025,
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Builder(
                builder: (context) {
                  if (state.getProfilePicture == '' &&
                      state.getProfilePicturePreview == '') {
                    return GestureDetector(
                      onTap: () => takePhoto(context, state),
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.black,
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(33),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 43,
                              left: 43,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () => viewPhoto(context, state),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(38),
                            child: Image.memory(
                              base64Decode(
                                state.getProfilePicture,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),

              // ~:Devider:~
              SizedBox(width: 15),

              // User Data, contains of name and employee ID
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.025,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.getUserAccountList[0].employeeName,
                        style: GlobalFont.gigafontRBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        state.getUserAccountList[0].employeeID,
                        style: GlobalFont.mediumgiantfontRBold,
                      ),
                      Text(
                        '${state.getUserAccountList[0].bsName}, ${state.getUserAccountList[0].locationName}',
                        style: GlobalFont.mediumgiantfontR,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ~:Settings Section:~
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          color: Colors.grey[100],
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.015,
            bottom: MediaQuery.of(context).size.height * 0.005,
          ),
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.height * 0.02,
            MediaQuery.of(context).size.height * 0.01,
            MediaQuery.of(context).size.height * 0.005,
            0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan',
                style: GlobalFont.mediumgiantfontRBold,
              ),

              // Background Location Service Switch Button
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.05,
              //   alignment: Alignment.centerLeft,
              //   margin: EdgeInsets.only(
              //     top: MediaQuery.of(context).size.height * 0.01,
              //     bottom: MediaQuery.of(context).size.height * 0.005,
              //   ),
              //   padding: EdgeInsets.fromLTRB(
              //     MediaQuery.of(context).size.height * 0.02,
              //     0.0,
              //     MediaQuery.of(context).size.height * 0.005,
              //     0.0,
              //   ),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       const Icon(Icons.location_on, size: 30.0),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.height * 0.04,
              //       ),
              //       Text(
              //         'Background Location',
              //         style: GlobalFont.mediumgiantfontR,
              //       ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.2,
              //       ),
              //       Switch(
              //         value: isLocationEnabled,
              //         onChanged: toggleLocationSwitch,
              //         activeColor: Colors.blue,
              //       ),
              //     ],
              //   ),
              // ),

              // ~:Privacy Policy Section:~
              Expanded(
                child: InkWell(
                  onTap: () => launchLink(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.privacy_tip_rounded,
                            size: 30.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Privasi Akun',
                                  style: GlobalFont.giantfontR,
                                ),
                                Text(
                                  'Penggunaan data pribadi',
                                  style: GlobalFont.bigfontR,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ~:Change Password Section:~
              Expanded(
                child: InkWell(
                  onTap: () => changePassword(state),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 30.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Keamanan Sandi',
                                  style: GlobalFont.giantfontR,
                                ),
                                Text(
                                  'Ubah kata sandi akun anda',
                                  style: GlobalFont.bigfontR,
                                ),
                              ],
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
        ),
        Column(
          children: [
            // ~:App Version Section:~
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Text(
                'Version 1.1.7',
                style: GlobalFont.bigfontR,
              ),
            ),
            // ~:Log Out Button:~
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.015,
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: ElevatedButton(
                onPressed: toggleLogOutPage,
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.95,
                    MediaQuery.of(context).size.height * 0.04,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.blue[300],
                ),
                child: Builder(
                  builder: (context) {
                    if (isLoading) {
                      return Builder(
                        builder: (context) {
                          if (Platform.isIOS) {
                            return const CupertinoActivityIndicator(
                              radius: 12.5,
                              color: Colors.white,
                            );
                          } else {
                            return const CircleLoading(
                              warna: Colors.white,
                            );
                          }
                        },
                      );
                    } else {
                      return Text(
                        'SIGN OUT',
                        style: GlobalFont.giantfontR,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // State Mangement
    final profileState = Provider.of<SipSalesState>(context);

    return SlidingUpPanel(
      renderPanelSheet: false,
      backdropEnabled: true,
      backdropTapClosesPanel: false,
      minHeight: 0.0,
      maxHeight: (MediaQuery.of(context).size.width < 800)
          ? MediaQuery.of(context).size.height * 0.4
          : MediaQuery.of(context).size.height * 0.35,
      controller: panelController,
      panel: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: IconButton(
                        onPressed: toggleLogOutPage,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Wrap(
                      children: [
                        DefaultTextStyle(
                          style: GlobalFont.mediumgigafontRBold,
                          textAlign: TextAlign.center,
                          child: Text(
                            'Apakah anda ingin keluar dari akun ini?',
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        DefaultTextStyle(
                          style: GlobalFont.bigfontR,
                          textAlign: TextAlign.center,
                          child: Text(
                            'Pastikan anda mengingat username dan password anda.',
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ColoredButton(
                              toggleLogOutPage,
                              'Cancel',
                            ),
                            ColoredButton(
                              () => logout(profileState),
                              'SIGN OUT',
                              isCancel: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Material(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: IconButton(
                          onPressed: toggleLogOutPage,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Apakah anda ingin keluar dari akun ini?',
                            style: GlobalFont.petafontRBold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'Pastikan anda mengingat username dan password anda.',
                            style: GlobalFont.mediumgigafontR,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ColoredButton(
                                toggleLogOutPage,
                                'Cancel',
                                isIpad: true,
                              ),
                              ColoredButton(
                                logout,
                                'SIGN OUT',
                                isCancel: true,
                                isIpad: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
      body: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          toolbarHeight: (MediaQuery.of(context).size.width < 800)
              ? MediaQuery.of(context).size.height * 0.075
              : MediaQuery.of(context).size.height * 0.075,
          title: (MediaQuery.of(context).size.width < 800)
              ? Text(
                  'Profile',
                  style: GlobalFont.giantfontRBold,
                )
              : Text(
                  'Profile',
                  style: GlobalFont.terafontRBold,
                ),
          leading: Builder(
            builder: (context) {
              if (Platform.isIOS) {
                return IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size:
                        (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                    color: Colors.black,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size:
                        (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Builder(
                builder: (context) {
                  if (Platform.isIOS) {
                    return CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () => getUserLatestData(profileState),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, _) => profileBody(profileState),
                            childCount: 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () => getUserLatestData(profileState),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: profileBody(profileState),
                      ),
                    );
                  }
                },
              ),
              // Refresh Behavior with Shimmer Effect
              // child: Builder(
              //   builder: (context) {
              //     if (isLoading) {
              //       return Shimmer.fromColors(
              //         baseColor: Colors.grey[300]!,
              //         highlightColor: Colors.white,
              //         period: const Duration(milliseconds: 1000),
              //         child: ListView(
              //           children: [
              //             // ~:Profile Section:~
              //             ShimmerBox(
              //               MediaQuery.of(context).size.width,
              //               MediaQuery.of(context).size.height * 0.15,
              //               topLeftRadius: 20,
              //               topRightRadius: 20,
              //               color: Colors.grey[100]!,
              //               verticalPadding:
              //                   MediaQuery.of(context).size.height * 0.025,
              //               horizontalPadding:
              //                   MediaQuery.of(context).size.width * 0.05,
              //             ),
              //
              //             ShimmerBox(
              //               MediaQuery.of(context).size.width,
              //               MediaQuery.of(context).size.height * 0.22,
              //               color: Colors.grey[100]!,
              //               verticalPadding:
              //                   MediaQuery.of(context).size.height * 0.025,
              //               horizontalPadding:
              //                   MediaQuery.of(context).size.width * 0.05,
              //               verticalMargin:
              //                   MediaQuery.of(context).size.height * 0.0125,
              //             ),
              //
              //             Column(
              //               children: [
              //                 // ~:App Version Section:~
              //                 Container(
              //                   width: MediaQuery.of(context).size.width,
              //                   alignment: Alignment.centerLeft,
              //                   margin: EdgeInsets.only(
              //                     left:
              //                         MediaQuery.of(context).size.width * 0.05,
              //                     right:
              //                         MediaQuery.of(context).size.width * 0.05,
              //                     top:
              //                         MediaQuery.of(context).size.height * 0.01,
              //                   ),
              //                   child: Text(
              //                     'Version x.x.x',
              //                     style: GlobalFont.bigfontR,
              //                   ),
              //                 ),
              //
              //                 // ~:Log Out Button:~
              //                 ShimmerBox(
              //                   MediaQuery.of(context).size.width,
              //                   MediaQuery.of(context).size.height * 0.05,
              //                   topLeftRadius: 20,
              //                   topRightRadius: 20,
              //                   bottomLeftRadius: 20,
              //                   bottomrightRadius: 20,
              //                   color: Colors.grey[100]!,
              //                   verticalMargin:
              //                       MediaQuery.of(context).size.height * 0.015,
              //                   horizontalMargin:
              //                       MediaQuery.of(context).size.width * 0.03,
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     } else {
              //       return Builder(
              //         builder: (context) {
              //           if (Platform.isIOS) {
              //             return CustomScrollView(
              //               slivers: [
              //                 CupertinoSliverRefreshControl(
              //                   onRefresh: () =>
              //                       getUserLatestData(profileState),
              //                 ),
              //                 SliverList(
              //                   delegate: SliverChildBuilderDelegate(
              //                     (context, _) => profileBody(profileState),
              //                     childCount: 1,
              //                   ),
              //                 ),
              //               ],
              //             );
              //           } else {
              //             return RefreshIndicator(
              //               onRefresh: () => getUserLatestData(profileState),
              //               child: SingleChildScrollView(
              //                 physics: AlwaysScrollableScrollPhysics(),
              //                 child: profileBody(profileState),
              //               ),
              //             );
              //           }
              //         },
              //       );
              //     }
              //   },
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
