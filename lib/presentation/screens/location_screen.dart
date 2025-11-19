import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/location_service/location_service_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/location_service/location_service_event.dart';
import 'package:sip_sales_clean/presentation/blocs/location_service/location_service_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Functions.requestPermission(),
      builder: (context, snapshot) {
        if (snapshot.hasData == true) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                color: Colors.grey[300],
                child: Column(
                  spacing: 24,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ~:Location Icon:~
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            size: 80.0,
                          ),
                        ),

                        // ~:Location Text:~
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(
                            'Dimana kamu berada?',
                            style: TextThemes.subtitle.copyWith(
                              fontSize: 24,
                              fontFamily: TextFontFamily.rubik,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // ~:Location Description:~
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(
                            'Lokasi Anda perlu diaktifkan agar aplikasi ini berfungsi.',
                            style: TextThemes.subtitle.copyWith(
                              fontFamily: TextFontFamily.rubik,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    // ~:Continue Button:~
                    InkWell(
                      onTap: () async =>
                          context.read<LocationServiceBloc>().add(
                            LocationServiceButtonPressed(context),
                          ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: const [
                            BoxShadow(
                              // Adjust shadow color as needed
                              color: Colors.grey,
                              // Adjust shadow blur radius
                              blurRadius: 5.0,
                              // Adjust shadow spread radius
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child:
                            BlocConsumer<
                              LocationServiceBloc,
                              LocationServiceState
                            >(
                              listener: (context, state) {
                                log('State: $state');
                                if (state is LocationServiceSuccess) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                } else if (state is LocationServiceFailed) {
                                  Functions.customFlutterToast(
                                    state.message,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is LocationServiceLoading) {
                                  if (Platform.isIOS) {
                                    return const CupertinoActivityIndicator(
                                      radius: 10.0,
                                      color: Colors.white,
                                    );
                                  } else {
                                    return const AndroidLoading(
                                      warna: Colors.white,
                                      customizedHeight: 20.0,
                                      customizedWidth: 20.0,
                                      strokeWidth: 3,
                                    );
                                  }
                                } else {
                                  return Text(
                                    'Continue',
                                    style: TextThemes.title2.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: TextFontFamily.rubik,
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
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          );
        }
      },
    );
  }
}
