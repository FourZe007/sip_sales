import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_event.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_type.dart';
import 'package:sip_sales_clean/presentation/cubit/fu_controls_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/navbar_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_data_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/screens/coordinator_screen.dart';
import 'package:sip_sales_clean/presentation/screens/head_acts_screen.dart';
import 'package:sip_sales_clean/presentation/screens/head_new_acts.dart';
import 'package:sip_sales_clean/presentation/screens/head_dashboard_screen.dart';
import 'package:sip_sales_clean/presentation/screens/head_spk_screen.dart';
import 'package:sip_sales_clean/presentation/screens/profile_screen.dart';
import 'package:sip_sales_clean/presentation/screens/sales_report_screen.dart';
import 'package:sip_sales_clean/presentation/screens/salesman_attendance_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/colored_button.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/panels/category_filter_panel.dart';
import 'package:sip_sales_clean/presentation/widgets/panels/dealer_filter_panel.dart';
import 'package:sip_sales_clean/presentation/widgets/panels/group_dealer_filter_panel.dart';
import 'package:sip_sales_clean/presentation/widgets/panels/leasing_filter_panel.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/user_profile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int preferredTabHeight = 0;
  double panelMaxHeight = 150;
  final PanelController slidingPanelController = PanelController();

  double get getPanelMaxHeight => panelMaxHeight;

  void setPreferredTabHeight(int height) {
    setState(() {
      preferredTabHeight = height;
    });
  }

  void setPanelMaxHeight(double height) {
    setState(() {
      panelMaxHeight = height;
    });
    // panelMaxHeight = height;
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void refreshDashboard(
    BuildContext context,
    EmployeeModel employee,
    DashboardType dashboardState, {
    NavbarType navbarType = NavbarType.home,
    bool sortByName = false,
  }) {
    final salesmanId = employee.employeeID;
    final date = DateTime.now().toIso8601String().substring(0, 10);
    log('Salesman Id: $salesmanId');
    log('Employee Code: ${employee.code}');
    log('Date: $date');
    log('Navbar Type: $navbarType');
    log('Dashboard Type: ${context.read<DashboardSlidingUpCubit>().state}');

    // ~:Head Store:~
    if (employee.code == 0) {
      if (navbarType == NavbarType.home) {
        log('Refresh head store home page');
        context.read<HeadStoreBloc>().add(
          LoadHeadActs(
            employeeID: salesmanId,
            date: date,
          ),
        );
      } else if (navbarType == NavbarType.report) {
        if (dashboardState == DashboardType.spk) {
          log('Refresh head store SPK Report page');
          // ~:Load SPK Leasing Filter Data:~
          context.read<SpkLeasingFilterCubit>().loadFilterData();

          // ~:Load SPK Leasing Data:~
          context.read<SpkLeasingDataCubit>().loadData(
            salesmanId,
            date,
            "${employee.branch}${employee.shop}",
            '',
            '',
            '',
          );
        } else {
          log('Refresh head store Dashboard Report page');
          context.read<HeadStoreBloc>().add(
            LoadHeadDashboard(
              employeeID: salesmanId,
              date: date,
            ),
          );
        }
      }
    }
    // ~:Salesman:~
    else if (employee.code == 1) {
      if (navbarType == NavbarType.home) {
        log('Refresh Salesman Home Screen');
        context.read<SalesmanBloc>().add(
          SalesmanButtonPressed(
            salesmanId: salesmanId,
            startDate: '',
            endDate: '',
          ),
        );
      } else if (navbarType == NavbarType.report) {
        // if (state.name == 'salesman') {
        //   log('Dashboard type: salesman');
        //   context.read<SalesmanBloc>().add(
        //     SalesmanDashboardButtonPressed(
        //       salesmanId: salesmanId,
        //       endDate: date,
        //     ),
        //   );
        // }
        if (dashboardState.name == 'salesman') {
          log('Dashboard type: salesman');
          context.read<SalesmanBloc>().add(
            SalesmanDashboardButtonPressed(
              salesmanId: salesmanId,
              endDate: date,
            ),
          );
        } else if (dashboardState.name == 'followup') {
          log('Dashboard type: followup');
          context.read<FuFilterControlsCubit>().toggleFilter(
            'sortByName',
            false,
          );

          final activeFilters = context
              .read<FuFilterControlsCubit>()
              .state
              .activeFilters;
          if (activeFilters['notFollowedUp'] == true) {
            log('notFollowedUp');
            context.read<FollowupDashboardBloc>().add(
              LoadFollowupDashboard(salesmanId, date, sortByName),
            );
          } else if (activeFilters['deal'] == true) {
            log('deal');
            context.read<FollowupDashboardBloc>().add(
              LoadFollowupDealDashboard(salesmanId, date, sortByName),
            );
          }
        }
      }
    }
  }

  Widget profileTemplateBody(
    BuildContext context,
    EmployeeModel employee,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.blue),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: UserProfileTemplate(employee: employee)),

              IconButton(
                onPressed: () =>
                    context.read<DashboardSlidingUpCubit>().changeType(
                      DashboardSlidingUpType.logout,
                    ),
                tooltip: 'Keluar',
                icon: Icon(
                  Icons.logout_rounded,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
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
                      if (employee.code == 1) {
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
                                          MediaQuery.of(
                                            context,
                                          ).size.width *
                                          0.025,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

                  // ~:App Version Section:~
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: 20,
                      ),
                      child: Text(
                        'Versi 1.2.0 beta',
                        style: TextThemes.normal.copyWith(
                          fontSize: 16,
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
    );
  }

  Widget profileTemplate() {
    if (Platform.isIOS) {
      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => context.read<LoginBloc>().add(
              LoginButtonPressed(
                context: (context.mounted) ? context : context,
                id: await Functions.readAndWriteEmployeeId(),
                pass: await Functions.readAndWriteUserPass(),
                isRefresh: true,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, _) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) =>
                      (current is LoginLoading && current.isRefresh) ||
                      (current is LoginFailed && current.isRefresh) ||
                      (current is LoginSuccess && current.isRefresh),
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      if (Platform.isIOS) {
                        return const CupertinoActivityIndicator(
                          radius: 8,
                          color: Colors.black,
                        );
                      } else {
                        return const AndroidLoading(
                          warna: Colors.black,
                          strokeWidth: 3,
                        );
                      }
                    } else if (state is LoginFailed) {
                      return Center(
                        child: Column(
                          children: [
                            Text(state.message),

                            ElevatedButton(
                              onPressed: () async => context.read<LoginBloc>().add(
                                LoginButtonPressed(
                                  context: (context.mounted)
                                      ? context
                                      : context,
                                  id: await Functions.readAndWriteEmployeeId(),
                                  pass: await Functions.readAndWriteUserPass(),
                                  isRefresh: true,
                                ),
                              ),
                              child: Text(
                                'Refresh',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LoginSuccess) {
                      return profileTemplateBody(
                        context,
                        state.user,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async => context.read<LoginBloc>().add(
          LoginButtonPressed(
            context: (context.mounted) ? context : context,
            id: await Functions.readAndWriteEmployeeId(),
            pass: await Functions.readAndWriteUserPass(),
            isRefresh: true,
          ),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height:
                MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  (current is LoginLoading && current.isRefresh) ||
                  (current is LoginFailed && current.isRefresh) ||
                  (current is LoginSuccess && current.isRefresh),
              builder: (context, state) {
                if (state is LoginLoading) {
                  if (Platform.isIOS) {
                    return const CupertinoActivityIndicator(
                      radius: 8,
                      color: Colors.black,
                    );
                  } else {
                    return const AndroidLoading(
                      warna: Colors.black,
                      strokeWidth: 3,
                    );
                  }
                } else if (state is LoginFailed) {
                  return Center(
                    child: Column(
                      children: [
                        Text(state.message),

                        ElevatedButton(
                          onPressed: () async => context.read<LoginBloc>().add(
                            LoginButtonPressed(
                              context: (context.mounted) ? context : context,
                              id: await Functions.readAndWriteEmployeeId(),
                              pass: await Functions.readAndWriteUserPass(),
                              isRefresh: true,
                            ),
                          ),
                          child: Text(
                            'Refresh',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is LoginSuccess) {
                  return profileTemplateBody(
                    context,
                    state.user,
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      );
    }
  }

  Widget deleteActs(final String activityId) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ~:Header:~
          Column(
            spacing: 8,
            children: [
              // ~:Title:~
              Text(
                'Peringatan!',
                style: TextThemes.normal.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              // ~:Description:~
              Text(
                'Apakah anda yakin ingin menghapus aktivitas ini?',
                style: TextThemes.normal.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // ~:Buttons:~
          Row(
            spacing: 12,
            children: [
              // ~:Cancel Button:~
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<DashboardSlidingUpCubit>().closePanel(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.blue,
                        width: 3.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: TextThemes.normal,
                  ),
                ),
              ),

              // ~:Delete Button:~
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<HeadStoreBloc>().add(
                    DeleteHeadActs(
                      employeeID:
                          (context.read<LoginBloc>().state as LoginSuccess)
                              .user
                              .employeeID,
                      activityID: activityId,
                      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: BlocConsumer<HeadStoreBloc, HeadStoreState>(
                    listener: (context, state) {
                      if (state is HeadStoreDeleteSucceed) {
                        log('Deleted');
                        context.read<DashboardSlidingUpCubit>().closePanel();

                        Functions.customFlutterToast(
                          'Laporan berhasil dihapus!',
                        );

                        context.read<HeadStoreBloc>().add(
                          LoadHeadActs(
                            employeeID:
                                (context.read<LoginBloc>().state
                                        as LoginSuccess)
                                    .user
                                    .employeeID,
                            date: DateFormat('yyyy-MM-dd').format(
                              DateTime.now(),
                            ),
                          ),
                        );
                      } else if (state is HeadStoreDeleteFailed) {
                        log('Failed');
                        Functions.customFlutterToast(
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is HeadStoreLoading &&
                          state.isDelete &&
                          !state.isActs &&
                          !state.isActsDetail &&
                          !state.isDashboard &&
                          !state.isInsert) {
                        if (Platform.isIOS) {
                          return const CupertinoActivityIndicator(
                            radius: 8,
                            color: Colors.black,
                          );
                        } else {
                          return const AndroidLoading(
                            warna: Colors.black,
                            strokeWidth: 3,
                          );
                        }
                      } else {
                        return Text(
                          'Hapus',
                          style: TextThemes.normalWhite,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void valueOnChanged(
    BuildContext context,
    FollowUpStatus? newValue, {
    bool sortByName = false,
  }) async {
    if (newValue != null) {
      context.read<DashboardSlidingUpCubit>().closePanel();
      if (newValue == FollowUpStatus.notYet) {
        context.read<FuFilterControlsCubit>().toggleFilter(
          'notFollowedUp',
          true,
        );
      } else if (newValue == FollowUpStatus.completed) {
        context.read<FuFilterControlsCubit>().toggleFilter(
          'deal',
          true,
        );
      }

      context.read<FuFilterControlsCubit>().toggleFilter(
        'sortByName',
        sortByName,
      );

      refreshDashboard(
        context,
        (context.read<LoginBloc>().state as LoginSuccess).user,
        DashboardType.followup,
        sortByName: sortByName,
      );
    }
  }

  Widget logout() {
    return Container(
      height: 350,
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
                onPressed: () =>
                    context.read<DashboardSlidingUpCubit>().closePanel(),
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
                      () =>
                          context.read<DashboardSlidingUpCubit>().closePanel(),
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

  Widget salesReport(DashboardSlidingUpType type) {
    log('Sales Report Panel');
    return Container(
      height: type == DashboardSlidingUpType.followupfilter ? 200 : 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        spacing: 4,
        children: [
          // Draggable handle
          Container(
            width: 60,
            height: 8,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // ~:Content:~
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BlocBuilder<DashboardSlidingUpCubit, DashboardSlidingUpState>(
                builder: (context, state) {
                  if (state.type == DashboardSlidingUpType.followupfilter) {
                    return Column(
                      spacing: 12,
                      children: [
                        // ~:Filter Title:~
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Filter',
                            style: TextThemes.normal.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // ~:1st Filter:~
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: Row(
                            spacing: 12,
                            children: [
                              // ~:Title:~
                              Expanded(child: Text('Tipe Data')),

                              // ~:Dropdown:~
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child:
                                      BlocBuilder<
                                        FuFilterControlsCubit,
                                        FuFilterControlsState
                                      >(
                                        builder: (context, state) {
                                          return DropdownButton(
                                            value:
                                                state.activeFilters['notFollowedUp'] ==
                                                    true
                                                ? FollowUpStatus.notYet
                                                : FollowUpStatus.completed,
                                            onChanged: (newValue) =>
                                                valueOnChanged(
                                                  context,
                                                  newValue,
                                                ),
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            icon: const Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: Colors.blue,
                                            ),
                                            iconSize: 28,
                                            elevation: 4,
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 16,
                                            ),
                                            underline: SizedBox(),
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                            items: FollowUpStatus.values
                                                .where(
                                                  (element) =>
                                                      element ==
                                                          FollowUpStatus
                                                              .notYet ||
                                                      element ==
                                                          FollowUpStatus
                                                              .completed,
                                                )
                                                .map((
                                                  FollowUpStatus value,
                                                ) {
                                                  switch (value) {
                                                    case FollowUpStatus.notYet:
                                                      return DropdownMenuItem<
                                                        FollowUpStatus
                                                      >(
                                                        value: FollowUpStatus
                                                            .notYet,
                                                        child: Text(
                                                          'Belum Follow Up',
                                                        ),
                                                      );
                                                    case FollowUpStatus
                                                        .completed:
                                                      return DropdownMenuItem<
                                                        FollowUpStatus
                                                      >(
                                                        value: FollowUpStatus
                                                            .completed,
                                                        child: Text(
                                                          'Deal',
                                                        ),
                                                      );
                                                    default:
                                                      return DropdownMenuItem<
                                                        FollowUpStatus
                                                      >(
                                                        value: FollowUpStatus
                                                            .notYet,
                                                        child: Text(
                                                          'Belum Follow Up',
                                                        ),
                                                      );
                                                  }
                                                })
                                                .toList(),
                                          );
                                        },
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ~:2nd Filter:~
                        // Bug: The switch is not properly changed when the switch is toggled
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              // ~:Title:~
                              Expanded(child: Text('Sort names A-Z')),

                              // ~:Switch:~
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      BlocBuilder<
                                        FuFilterControlsCubit,
                                        FuFilterControlsState
                                      >(
                                        builder: (context, state) {
                                          log(
                                            'isSortByName active: ${state.activeFilters['sortByName']!}',
                                          );
                                          return CupertinoSwitch(
                                            value:
                                                state
                                                    .activeFilters['sortByName'] ??
                                                false,
                                            onChanged: (value) => valueOnChanged(
                                              context,
                                              state.activeFilters['notFollowedUp'] ==
                                                      true
                                                  ? FollowUpStatus.notYet
                                                  : FollowUpStatus.completed,
                                              sortByName: value,
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state.type == DashboardSlidingUpType.moreoption) {
                    return Column(
                      spacing: 8,
                      children: [
                        // ~:Title:~
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Quick Action',
                            style: TextThemes.normal.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // ~:CTA WhatsApp:~
                        ElevatedButton.icon(
                          onPressed: () async => Functions.openLink(
                            context,
                            'https://wa.me/62${state.optionalData.replaceFirst('0', '')}',
                          ),
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Hubungi via WhatsApp',
                            style: TextThemes.normal.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              MediaQuery.of(context).size.width,
                              40,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shopHead(EmployeeModel employee) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: SlidingUpPanel(
        controller: slidingPanelController,
        backdropEnabled: true,
        backdropColor: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.0),
        minHeight: 0.0,
        maxHeight: getPanelMaxHeight,
        // maxHeight: context.select<DashboardSlidingUpCubit, double>(
        //   (cubit) => cubit.state.panelHeight,
        // ),
        // maxHeight: context.read<DashboardSlidingUpCubit>().state.panelHeight,
        defaultPanelState: PanelState.CLOSED,
        onPanelClosed: () =>
            context.read<DashboardSlidingUpCubit>().closePanel(),
        panel: Material(
          color: Colors.transparent,
          child: BlocBuilder<DashboardSlidingUpCubit, DashboardSlidingUpState>(
            builder: (context, state) {
              log('Head Sliding Panel State: ${state.type}');
              if (state.type == DashboardSlidingUpType.logout) {
                return logout();
              } else if (state.type ==
                  DashboardSlidingUpType.deleteManagerActivity) {
                return deleteActs(state.optionalData);
              } else if (state.type == DashboardSlidingUpType.groupDealer) {
                return GroupDealerFilterPanel();
              } else if (state.type == DashboardSlidingUpType.dealer) {
                return DealerFilterPanel();
              } else if (state.type == DashboardSlidingUpType.leasing) {
                return LeasingFilterPanel();
              } else if (state.type == DashboardSlidingUpType.category) {
                return CategoryFilterPanel();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        body: DefaultTabController(
          length: 2,
          // initialIndex: context.read<DashboardTypeCubit>().state.index,
          initialIndex: 1,
          animationDuration: Duration(milliseconds: 500),
          child: BlocListener<DashboardSlidingUpCubit, DashboardSlidingUpState>(
            listener: (context, state) {
              if (state.type == DashboardSlidingUpType.deleteManagerActivity ||
                  state.type == DashboardSlidingUpType.logout ||
                  state.type == DashboardSlidingUpType.groupDealer ||
                  state.type == DashboardSlidingUpType.dealer ||
                  state.type == DashboardSlidingUpType.leasing ||
                  state.type == DashboardSlidingUpType.category) {
                log('Opening Sliding Up Panel - State: ${state.type}');
                slidingPanelController.open();
              } else {
                log('Closing Sliding Up Panel - State: ${state.type}');
                slidingPanelController.close();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                // toolbarHeight:
                //     context.read<NavbarCubit>().state == NavbarType.profile
                //     ? 100
                //     : 60,
                toolbarHeight:
                    context.read<NavbarCubit>().state == NavbarType.profile
                    ? 0
                    : 60,
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                shadowColor: Colors.blue,
                centerTitle: false,
                titleSpacing:
                    context.read<NavbarCubit>().state == NavbarType.profile
                    ? 0
                    : 16,
                title: BlocBuilder<NavbarCubit, NavbarType>(
                  builder: (context, state) {
                    if (state == NavbarType.profile) {
                      return UserProfileTemplate(employee: employee);
                    } else if (state == NavbarType.home) {
                      return Text(
                        'Daftar Kegiatan',
                        style: TextThemes.normal.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    } else if (state == NavbarType.report) {
                      return Text(
                        'Laporan Penjualan',
                        style: TextThemes.normal.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                actions: [
                  context.read<NavbarCubit>().state == NavbarType.profile
                      ? IconButton(
                          onPressed: () => context
                              .read<DashboardSlidingUpCubit>()
                              .changeType(
                                DashboardSlidingUpType.logout,
                              ),
                          tooltip: 'Keluar',
                          icon: Icon(
                            Icons.logout_rounded,
                            size: 28,
                            color: Colors.black,
                          ),
                        )
                      : IconButton(
                          onPressed: () => refreshDashboard(
                            context,
                            employee,
                            context.read<DashboardTypeCubit>().state,
                            navbarType: context.read<NavbarCubit>().state,
                          ),
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: (MediaQuery.of(context).size.width < 800)
                                ? 20.0
                                : 36.0,
                            color: Colors.black,
                          ),
                        ),
                  // : BlocBuilder<DashboardTypeCubit, DashboardType>(
                  //     builder: (context, state) {
                  //       if (state == DashboardType.spk) {
                  //         return IconButton(
                  //           onPressed: () => context
                  //               .read<DashboardSlidingUpCubit>()
                  //               .changeType(DashboardSlidingUpType.leasing),
                  //           icon: Icon(
                  //             Icons.filter_alt_rounded,
                  //             size:
                  //                 (MediaQuery.of(context).size.width < 800)
                  //                 ? 24.0
                  //                 : 40.0,
                  //             color: Colors.black,
                  //           ),
                  //         );
                  //       } else {
                  //         return IconButton(
                  //           onPressed: () => refreshDashboard(
                  //             context,
                  //             employee,
                  //             context.read<DashboardTypeCubit>().state,
                  //             navbarType: context.read<NavbarCubit>().state,
                  //           ),
                  //           icon: Icon(
                  //             Icons.refresh_rounded,
                  //             size:
                  //                 (MediaQuery.of(context).size.width < 800)
                  //                 ? 20.0
                  //                 : 36.0,
                  //             color: Colors.black,
                  //           ),
                  //         );
                  //       }
                  //     },
                  //   ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                    context.read<NavbarCubit>().state == NavbarType.report
                        ? 40
                        : 0,
                  ),
                  child: BlocBuilder<NavbarCubit, NavbarType>(
                    builder: (context, state) {
                      if (state == NavbarType.report) {
                        return TabBar(
                          // controller: DefaultTabController.of(context)
                          //   ..index = 0,
                          onTap: (index) {
                            log('Index: ${index.toString()}');

                            context.read<DashboardTypeCubit>().changeType(
                              index == 0
                                  ? DashboardType.salesman
                                  : DashboardType.spk,
                            );

                            if (index == 1) {
                              // ~:Load SPK Leasing Filter Data:~
                              context
                                  .read<SpkLeasingFilterCubit>()
                                  .loadFilterData();
                            }

                            log(
                              'Current DashboardSlidingupCubit state: ${context.read<DashboardSlidingUpCubit>().state.type}',
                            );
                          },
                          indicatorColor: Colors.black,
                          indicatorWeight: 2,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black,
                          unselectedLabelStyle: TextThemes.normal.copyWith(
                            fontSize: 16,
                          ),
                          labelStyle: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(text: 'Dashboard'),
                            Tab(text: 'SPK Leasing'),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
              floatingActionButton: BlocBuilder<NavbarCubit, NavbarType>(
                builder: (context, state) {
                  if (state == NavbarType.home) {
                    return FloatingActionButton(
                      onPressed: () async {
                        context.read<ImageCubit>().clearImage();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HeadNewActsScreen(),
                          ),
                        );
                      },
                      backgroundColor: Colors.blue[200],
                      child: const Icon(
                        Icons.add_rounded,
                        size: 30.0,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              bottomNavigationBar:
                  BlocListener<
                    DashboardSlidingUpCubit,
                    DashboardSlidingUpState
                  >(
                    listener: (context, state) {
                      log('Listening DashboardSlidingUpCubit: ${state.type}');
                      if (state.type == DashboardSlidingUpType.groupDealer) {
                        setPanelMaxHeight(160);
                      } else if (state.type == DashboardSlidingUpType.dealer) {
                        setPanelMaxHeight(200);
                      } else if (state.type == DashboardSlidingUpType.leasing) {
                        setPanelMaxHeight(260);
                      } else if (state.type ==
                          DashboardSlidingUpType.category) {
                        setPanelMaxHeight(360);
                      }
                    },
                    child: BottomNavigationBar(
                      currentIndex: context.read<NavbarCubit>().state.index,
                      onTap: (index) {
                        context.read<NavbarCubit>().changeNavbarType(index);
                        setPreferredTabHeight(index == 1 ? 20 : 0);

                        if (index == 0) {
                          setPanelMaxHeight(150);

                          context.read<DashboardTypeCubit>().changeType(
                            DashboardType.none,
                          );

                          context.read<HeadStoreBloc>().add(
                            LoadHeadActs(
                              employeeID: employee.employeeID,
                              date: DateTime.now().toIso8601String().split(
                                'T',
                              )[0],
                            ),
                          );
                        } else if (index == 1) {
                          log(
                            'Bottom NavBar Sliding Up State: ${context.read<DashboardSlidingUpCubit>().state.type}',
                          );

                          // Reset dashboard type to salesman
                          // just in case user is in spk screen
                          context.read<DashboardTypeCubit>().changeType(
                            DashboardType.salesman,
                          );

                          refreshDashboard(
                            context,
                            employee,
                            context.read<DashboardTypeCubit>().state,
                            navbarType: NavbarType.report,
                          );
                        } else if (index == 2) {
                          setPanelMaxHeight(325);
                          // context.read<DashboardSlidingUpCubit>().changeType(
                          //   DashboardSlidingUpType.logout,
                          // );
                        }
                      },
                      backgroundColor: Colors.white,
                      selectedItemColor: Colors.blue,
                      unselectedItemColor: Colors.grey,
                      elevation: 8.0,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.bar_chart_rounded),
                          label: 'Report',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.blue,
                child: BlocBuilder<NavbarCubit, NavbarType>(
                  builder: (context, state) {
                    if (state == NavbarType.report) {
                      return BlocListener<DashboardTypeCubit, DashboardType>(
                        listener: (context, state) {
                          log("Body state: ${state.toString()}");
                          refreshDashboard(
                            context,
                            employee,
                            state,
                            navbarType: NavbarType.report,
                          );
                        },
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            const HeadDashboardScreen(),
                            const HeadSpkScreen(),
                          ],
                        ),
                      );
                    } else if (state == NavbarType.profile) {
                      return profileTemplate();
                    } else {
                      return HeadActivityPage(employeeModel: employee);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget salesman(EmployeeModel employee) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: SlidingUpPanel(
        controller: slidingPanelController,
        backdropEnabled: true,
        backdropColor: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.0),
        minHeight: 0.0,
        maxHeight: panelMaxHeight,
        defaultPanelState: PanelState.CLOSED,
        onPanelClosed: () =>
            context.read<DashboardSlidingUpCubit>().closePanel(),
        panel: Material(
          color: Colors.transparent,
          child: BlocBuilder<DashboardSlidingUpCubit, DashboardSlidingUpState>(
            builder: (context, state) {
              log('Salesman Sliding Panel State: ${state.type}');
              if (state.type == DashboardSlidingUpType.logout) {
                return logout();
              } else if (state.type == DashboardSlidingUpType.followupfilter ||
                  state.type == DashboardSlidingUpType.moreoption) {
                return salesReport(state.type);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            // toolbarHeight:
            //     context.read<NavbarCubit>().state == NavbarType.profile
            //     ? 100
            //     : context.read<NavbarCubit>().state == NavbarType.report
            //     ? 0
            //     : 60,
            toolbarHeight: context.read<NavbarCubit>().state != NavbarType.home
                ? 0
                : 60,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            shadowColor: Colors.blue,
            centerTitle: false,
            titleSpacing: context.read<NavbarCubit>().state != NavbarType.home
                ? 0
                : 16,
            title: BlocBuilder<NavbarCubit, NavbarType>(
              builder: (context, state) {
                // if (state == NavbarType.profile) {
                //   return UserProfileTemplate(employee: employee);
                // } else
                if (state == NavbarType.home) {
                  return Text(
                    'Absensi',
                    style: TextThemes.normal.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            actions: [
              context.read<NavbarCubit>().state == NavbarType.profile
                  ? IconButton(
                      onPressed: () =>
                          context.read<DashboardSlidingUpCubit>().changeType(
                            DashboardSlidingUpType.logout,
                          ),
                      tooltip: 'Keluar',
                      icon: Icon(
                        Icons.logout_rounded,
                        size: 28,
                        color: Colors.black,
                      ),
                    )
                  : context.read<NavbarCubit>().state == NavbarType.home
                  ? IconButton(
                      onPressed: () => refreshDashboard(
                        context,
                        employee,
                        context.read<DashboardTypeCubit>().state,
                        navbarType: context.read<NavbarCubit>().state,
                      ),
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: (MediaQuery.of(context).size.width < 800)
                            ? 20.0
                            : 35.0,
                        color: Colors.black,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: context.read<NavbarCubit>().state.index,
            onTap: (index) {
              context.read<NavbarCubit>().changeNavbarType(index);
              setPreferredTabHeight(index == 1 ? 20 : 0);

              if (index == 0) {
                setPanelMaxHeight(150);

                refreshDashboard(
                  context,
                  employee,
                  context.read<DashboardTypeCubit>().state,
                  navbarType: NavbarType.home,
                );
              } else if (index == 1) {
                setPanelMaxHeight(200);

                context.read<DashboardTypeCubit>().changeType(
                  DashboardType.salesman,
                );

                refreshDashboard(
                  context,
                  employee,
                  context.read<DashboardTypeCubit>().state,
                  navbarType: NavbarType.report,
                );
              } else if (index == 2) {
                setPanelMaxHeight(325);
              }
            },
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            elevation: 8.0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Report',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          body: BlocListener<DashboardSlidingUpCubit, DashboardSlidingUpState>(
            listener: (context, state) {
              if (state.type == DashboardSlidingUpType.deleteManagerActivity ||
                  state.type == DashboardSlidingUpType.followupfilter ||
                  state.type == DashboardSlidingUpType.moreoption ||
                  state.type == DashboardSlidingUpType.logout) {
                log('Opening Sliding Up Panel - State: ${state.type}');
                slidingPanelController.open();
              } else {
                log('Closing Sliding Up Panel - State: ${state.type}');
                slidingPanelController.close();
              }
            },
            child: BlocBuilder<NavbarCubit, NavbarType>(
              builder: (context, state) {
                if (state == NavbarType.report) {
                  return const SalesReportScreen();
                } else if (state == NavbarType.profile) {
                  return profileTemplate();
                } else {
                  return DecoratedBox(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: SalesmanAttendanceScreen(
                      salesmanId: employee.employeeID,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: false,
        maintainBottomViewPadding: true,
        child: BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (previous, current) =>
              current is LoginSuccess || current is LoginFailed,
          builder: (context, state) {
            if (state is LoginSuccess) {
              log('Login success with code: ${state.user.code}');
              log('User info: ${state.user}');

              // ~:Code Zero for Head Store:~
              if (state.user.code == 0) {
                return shopHead(state.user);
              }
              // ~:Code One for Salesman:~
              else if (state.user.code == 1) {
                return salesman(state.user);
              }
              // ~:Code Two for Shop Coordinator:~
              else if (state.user.code == 2) {
                return CoordinatorScreen(
                  applyUserProfile: false,
                  employee: state.user,
                  openProfile: openProfile,
                );
              }
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
