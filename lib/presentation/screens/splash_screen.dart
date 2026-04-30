import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/face_recognition_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/screens/login_blocked_screen.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_ios_loading.dart';
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
      Functions.runSecurityCheck(context);
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
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          // Only listen to states that require navigation or a toast
          listenWhen: (_, current) =>
              current is LoginSuccess ||
              current is LoginFailed ||
              current is LoginUnauthenticated ||
              current is LoginBlocked,
          listener: (context, state) async {
            log('Login State: $state');
            if (state is LoginBlocked) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginBlockedScreen(
                      message: state.message,
                      isEmulator: state.isEmulator,
                    ),
                  ),
                  (_) => false,
                );
              }
            } else if (state is LoginUnauthenticated || state is LoginFailed) {
              if (state is LoginFailed &&
                  state.message.toLowerCase().contains('failed host lookup')) {
                Functions.customFlutterToast('No internet connection');
              } else if (context.mounted) {
                Navigator.pushReplacementNamed(context, ConstantRoutes.login);
              }
            } else if (state is LoginSuccess) {
              await Functions.enrollFaceIfNeeded(context, state.user).then((_) {
                log(
                  'FaceRecognitionBloc state: ${context.read<FaceRecognitionBloc>().state}',
                );
                log('Face enrolled');
              });
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  state.user.code == 2
                      ? ConstantRoutes.home
                      : ConstantRoutes.location,
                );
              }
            }
          },
          buildWhen: (_, __) => false,
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Image(
                    image: const AssetImage('assets/SIP.png'),
                    width: MediaQuery.of(context).size.width * 0.55,
                    fit: BoxFit.cover,
                  ),
                  const AndroidIosLoading(strokeWidth: 3),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
