import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/colored_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedOut = false;
  final PanelController panelController = PanelController();

  void toggleLogOutPage() {
    log('Toggle LogOut Page pressed!!');
    setState(() {
      isLoggedOut = !isLoggedOut;
      if (isLoggedOut == true) {
        panelController.open();
      } else {
        panelController.close();
      }
    });
  }

  void viewPhoto(BuildContext context, EmployeeModel employee) {
    try {
      log('High Res Image: ${employee.profilePicture}');
      // Functions.previewProfileImage(
      //   context,
      //   employee.profilePicture,
      // );
    } catch (e) {
      log('Error: $e');
    }
  }

  void takePhoto(BuildContext context, EmployeeModel employee) async {
    if (employee.code == 1) {
      log('Take Photo pressed!');
      // await Functions.takeProfilePictureFromCamera(context).then((
      //   bool isAvailable,
      // ) {
      //   if (isAvailable) {
      //     // ~:Loading:~
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(
      //     //     builder: (context) => LoadingAnimationPage(
      //     //       false,
      //     //       false,
      //     //       false,
      //     //       false,
      //     //       true,
      //     //       false,
      //     //     ),
      //     //   ),
      //     // );
      //   } else {
      //     // ~:Failed:~s
      //     // state.setIsProfileUploaded(false);
      //     // state.displayDescription = 'Profil gagal diunggah.';
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(
      //     //     builder: (context) => const FailureAnimationPage(),
      //     //   ),
      //     // );
      //   }
      // });
    }
  }

  Widget profileTemplate() {
    final loginState = (context.read<LoginBloc>().state as LoginSuccess);

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
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Builder(
                builder: (context) {
                  log(
                    'Profile Picture: ${loginState.user.profilePicture.isEmpty}',
                  );
                  // log(
                  //   'Profile Picture Preview: ${loginState.user.profilePicturePreview.isEmpty}',
                  // );
                  if (loginState.user.profilePicture.isEmpty) {
                    return GestureDetector(
                      onTap: () {
                        if (loginState.user.code == 1) {
                          takePhoto(context, loginState.user);
                        }
                      },
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
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                if (loginState.user.code == 0 ||
                                    loginState.user.code == 2) {
                                  return SizedBox.shrink();
                                } else {
                                  return Positioned(
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
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    if (loginState.user.profilePicture.isEmpty) {
                      return CircleAvatar(
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
                      );
                    }

                    return InkWell(
                      onTap: () => viewPhoto(context, loginState.user),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(38),
                            child: Image.memory(
                              base64Decode(
                                loginState.user.profilePicture,
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

              // User Data, contains of name and employee ID
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loginState.user.employeeName,
                        style: TextThemes.normal.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        loginState.user.employeeID,
                        style: TextThemes.normal.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${Formatter.toTitleCase(loginState.user.bsName)}, ${Formatter.toTitleCase(loginState.user.locationName)}',
                        style: TextThemes.normal.copyWith(
                          fontSize: 18,
                        ),
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
          color: Colors.grey[100],
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.015,
            bottom: MediaQuery.of(context).size.height * 0.005,
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.015,
          ),
          child: Column(
            spacing: 8,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  'Pengaturan',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ~:Privacy Policy Section:~
              InkWell(
                // onTap: () => launchLink(context),
                onTap: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: const Icon(
                          Icons.privacy_tip_rounded,
                          size: 30.0,
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
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Penggunaan data pribadi',
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 16,
                                  ),
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
              InkWell(
                // onTap: () => changePassword(state),
                onTap: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
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
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Ubah kata sandi akun anda',
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 16,
                                  ),
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

              // ~:User Guideline:~
              Builder(
                builder: (context) {
                  if (loginState.user.code == 1) {
                    return InkWell(
                      // onTap: () => openUserGuideline(),
                      onTap: () {},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: const Icon(
                                Icons.menu_book_rounded,
                                size: 30.0,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Manual Book',
                                      style: TextThemes.normal.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'Cara menggunakan setiap fitur aplikasi',
                                      style: TextThemes.normal.copyWith(
                                        fontSize: 16,
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
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),

        // ~:Footer Section:~
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
                'Version 1.2.0',
                style: TextThemes.normal.copyWith(
                  fontSize: 16,
                ),
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
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  backgroundColor: Colors.blue[300],
                ),
                child: BlocConsumer<LoginBloc, LoginState>(
                  listenWhen: (previous, current) =>
                      current is LogoutLoading ||
                      current is LogoutSuccess ||
                      current is LogoutFailed,
                  listener: (context, state) {
                    if (state is LogoutFailed) {
                      Functions.customFlutterToast(state.message);
                    } else if (state is LogoutSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LogoutLoading) {
                      return Builder(
                        builder: (context) {
                          if (Platform.isIOS) {
                            return const CupertinoActivityIndicator(
                              radius: 12.5,
                              color: Colors.white,
                            );
                          } else {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                        },
                      );
                    } else {
                      return Text(
                        'SIGN OUT',
                        style: TextThemes.normal.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: SlidingUpPanel(
        renderPanelSheet: false,
        backdropEnabled: true,
        backdropTapClosesPanel: false,
        minHeight: 0.0,
        // maxHeight: (MediaQuery.of(context).size.width < 800)
        //     ? MediaQuery.of(context).size.height * 0.4
        //     : MediaQuery.of(context).size.height * 0.35
        maxHeight: 325,
        controller: panelController,
        panel: Material(
          color: Colors.transparent,
          child: Container(
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

                // ~:Logout Panel:~
                Container(
                  height: 230,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ~:Logout Title:~
                      DefaultTextStyle(
                        style: TextThemes.normal.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        child: Text(
                          'Apakah anda ingin keluar dari akun ini?',
                        ),
                      ),

                      // ~:Logout Description:~
                      DefaultTextStyle(
                        style: TextThemes.normal.copyWith(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        child: Text(
                          'Pastikan anda mengingat username dan password anda.',
                        ),
                      ),

                      // ~:Logout Buttons:~
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ~:Cancel Button:~
                          ColoredButton(
                            toggleLogOutPage,
                            'Cancel',
                          ),

                          // ~:Logout Button:~
                          ColoredButton(
                            () => context.read<LoginBloc>().add(
                              LogoutButtonPressed(context: context),
                            ),
                            'SIGN OUT',
                            isCancel: true,
                            isLoading: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blue,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            title: (MediaQuery.of(context).size.width < 800)
                ? Text(
                    'Profile',
                    style: TextThemes.normal.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    'Profile',
                    style: TextThemes.normal.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            leading: Builder(
              builder: (context) {
                if (Platform.isIOS) {
                  return IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Kembali',
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: (MediaQuery.of(context).size.width < 800)
                          ? 20.0
                          : 35.0,
                      color: Colors.black,
                    ),
                  );
                } else {
                  return IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Kembali',
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: (MediaQuery.of(context).size.width < 800)
                          ? 20.0
                          : 35.0,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
          ),
          body: DecoratedBox(
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
                          // onRefresh: () => getUserLatestData(profileState),
                          onRefresh: () {
                            return Future.delayed(const Duration(seconds: 1));
                          },
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, _) => SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.825,
                              child: profileTemplate(),
                            ),
                            childCount: 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return RefreshIndicator(
                      // onRefresh: () => getUserLatestData(profileState),
                      onRefresh: () {
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.825,
                          child: profileTemplate(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
