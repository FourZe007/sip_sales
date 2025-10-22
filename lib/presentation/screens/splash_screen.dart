import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginBloc>().add(
        LoginButtonPressed(
          context: context,
          id: '',
          pass: '',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginUnauthenticated || state is LoginFailed) {
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  ConstantRoutes.login,
                );
              }
            } else if (state is LoginSuccess) {
              // On auto-login success, continue to next screen (e.g., location)
              if (context.mounted) {
                if (state.user.code == 2) {
                  Navigator.pushReplacementNamed(
                    context,
                    ConstantRoutes.home,
                  );
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    ConstantRoutes.location,
                  );
                }
              }
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ~:Logo:~
                Image(
                  image: const AssetImage('assets/SIP.png'),
                  width: MediaQuery.of(context).size.width * 0.55,
                  fit: BoxFit.cover,
                ),

                // ~:Loading Indicator:~
                Builder(
                  builder: (context) {
                    if (Platform.isIOS) {
                      return const CupertinoActivityIndicator(
                        radius: 12,
                      );
                    } else {
                      return const AndroidLoading(
                        strokeWidth: 3,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
