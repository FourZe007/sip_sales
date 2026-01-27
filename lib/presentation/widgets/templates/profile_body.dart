import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class ProfileBodyScreen extends StatelessWidget {
  const ProfileBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = (context.read<LoginBloc>().state as LoginSuccess);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.005,
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
            child: Column(
              spacing: 8,
              children: [
                // ~:Settings Title:~
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
                                        MediaQuery.of(context).size.width *
                                        0.025,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

          // ~:App Version Section:~
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: 12,
              ),
              child: Text(
                'Versi 1.2.1',
                style: TextThemes.normal.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
