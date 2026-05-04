import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_ios_loading.dart';
import 'package:sip_sales_clean/routes.dart';

class LoginBlockedScreen extends StatelessWidget {
  final String message;
  final bool isEmulator;

  const LoginBlockedScreen({
    super.key,
    required this.message,
    required this.isEmulator,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocListener<LoginBloc, LoginState>(
        listenWhen: (_, current) =>
            current is LogoutSuccess || current is LogoutFailed,
        listener: (context, state) {
          if (state is LogoutFailed) {
            Functions.customFlutterToast(state.message);
          } else if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ConstantRoutes.login,
              (_) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    const Icon(
                      Icons.security_outlined,
                      size: 80,
                      color: Color(0xFFD32F2F),
                    ),
                    const Text(
                      'Perangkat Tidak Diizinkan',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2340),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => context.read<LoginBloc>().add(
                          LogoutButtonPressed(context: context),
                        ),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (_, current) =>
                              current is LogoutLoading ||
                              current is LogoutSuccess ||
                              current is LogoutFailed,
                          builder: (context, state) => state is LogoutLoading
                              ? const AndroidIosLoading(
                                  strokeWidth: 3,
                                  indicatorColor: Colors.white,
                                  customizedHeight: 24,
                                  customizedWidth: 24,
                                  iosRadius: 12,
                                )
                              : const Text(
                                  'Kembali ke Login',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
