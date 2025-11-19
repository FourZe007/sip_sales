import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/colored_button.dart';

// ~:NOT USED:~
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({required this.toggleLogOutPage, super.key});

  final Function toggleLogOutPage;

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => toggleLogOutPage(),
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
                      () => toggleLogOutPage(),
                      'Cancel',
                    ),

                    // ~:Logout Button:~
                    BlocListener<LoginBloc, LoginState>(
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
                      child: ColoredButton(
                        () => context.read<LoginBloc>().add(
                          LogoutButtonPressed(
                            context: context,
                          ),
                        ),
                        'SIGN OUT',
                        isCancel: true,
                        isLoading: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
