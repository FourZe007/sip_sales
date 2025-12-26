// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sip_sales_clean/core/constant/enum.dart';
// import 'package:sip_sales_clean/data/models/employee.dart';
// import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
// import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
// import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
// import 'package:sip_sales_clean/presentation/cubit/dashboard_type.dart';
// import 'package:sip_sales_clean/presentation/cubit/navbar_cubit.dart';
// import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
// import 'package:sip_sales_clean/presentation/screens/head_acts_screen.dart';
// import 'package:sip_sales_clean/presentation/screens/head_dashboard_screen.dart';
// import 'package:sip_sales_clean/presentation/screens/head_new_acts.dart';
// import 'package:sip_sales_clean/presentation/themes/styles.dart';
// import 'package:sip_sales_clean/presentation/widgets/templates/profile_body.dart';
// import 'package:sip_sales_clean/presentation/widgets/templates/user_profile.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// // ~:Not used:~
// class HeadStoreScreen extends StatelessWidget {
//   const HeadStoreScreen({
//     required this.employeeModel,
//     required this.panelController,
//     required this.logoutTemplate,
//     required this.deleteActsTemplate,
//     required this.refreshDashboard,
//     required this.toggleLogOutPage,
//     required this.setPreferredTabHeight,
//     super.key,
//   });

//   final EmployeeModel employeeModel;
//   final PanelController panelController;
//   final Widget logoutTemplate;
//   final Widget deleteActsTemplate;
//   final VoidCallback refreshDashboard;
//   final VoidCallback toggleLogOutPage;
//   final Function setPreferredTabHeight;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: false,
//       maintainBottomViewPadding: true,
//       child: DefaultTabController(
//         length: 2,
//         initialIndex: context.read<DashboardTypeCubit>().state.index,
//         animationDuration: Duration(milliseconds: 500),
//         child: SlidingUpPanel(
//           controller: panelController,
//           backdropEnabled: true,
//           backdropTapClosesPanel:
//               context.read<DashboardSlidingUpCubit>().state.type ==
//               DashboardSlidingUpType.deleteManagerActivity,
//           backdropColor: Colors.black.withValues(alpha: 0.5),
//           borderRadius: BorderRadius.circular(20.0),
//           minHeight: 0.0,
//           maxHeight:
//               context.read<DashboardSlidingUpCubit>().state.type ==
//                   DashboardSlidingUpType.logout
//               ? 350
//               : 150,
//           defaultPanelState: PanelState.CLOSED,
//           onPanelClosed: () =>
//               context.read<DashboardSlidingUpCubit>().closePanel(),
//           panel: Material(
//             color: Colors.transparent,
//             child:
//                 BlocBuilder<DashboardSlidingUpCubit, DashboardSlidingUpState>(
//                   builder: (context, state) {
//                     log('Head Sliding Panel State: $state');
//                     if (state.type == DashboardSlidingUpType.logout) {
//                       return logoutTemplate;
//                     } else if (state.type ==
//                         DashboardSlidingUpType.deleteManagerActivity) {
//                       return deleteActsTemplate;
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//           ),
//           body: BlocListener<DashboardSlidingUpCubit, DashboardSlidingUpState>(
//             listener: (context, state) {
//               if (state.type == DashboardSlidingUpType.deleteManagerActivity) {
//                 log('Opening Sliding Up Panel - State: $state');
//                 panelController.open();
//               } else {
//                 log('Closing Sliding Up Panel - State: $state');
//                 panelController.close();
//               }
//             },
//             child: Scaffold(
//               resizeToAvoidBottomInset: false,
//               appBar: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Colors.blue,
//                 toolbarHeight:
//                     context.read<NavbarCubit>().state == NavbarType.profile
//                     ? 100
//                     : 60,
//                 elevation: 0.0,
//                 scrolledUnderElevation: 0.0,
//                 shadowColor: Colors.blue,
//                 centerTitle: false,
//                 titleSpacing:
//                     context.read<NavbarCubit>().state == NavbarType.profile
//                     ? 0
//                     : 16,
//                 title: BlocBuilder<NavbarCubit, NavbarType>(
//                   builder: (context, state) {
//                     if (state == NavbarType.profile) {
//                       return UserProfileTemplate(employee: employeeModel);
//                     } else if (state == NavbarType.home) {
//                       return Text(
//                         'Daftar Kegiatan',
//                         style: TextThemes.normal.copyWith(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       );
//                     } else if (state == NavbarType.report) {
//                       return Text(
//                         'Laporan Penjualan',
//                         style: TextThemes.normal.copyWith(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       );
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//                 actions: [
//                   context.read<NavbarCubit>().state == NavbarType.profile
//                       ? IconButton(
//                           onPressed: () => toggleLogOutPage(),
//                           tooltip: 'Keluar',
//                           icon: Icon(
//                             Icons.logout_rounded,
//                             size: 28,
//                             color: Colors.black,
//                           ),
//                         )
//                       : IconButton(
//                           onPressed: () => refreshDashboard(),
//                           icon: Icon(
//                             Icons.refresh_rounded,
//                             size: (MediaQuery.of(context).size.width < 800)
//                                 ? 20.0
//                                 : 35.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                 ],
//               ),
//               floatingActionButton: BlocBuilder<NavbarCubit, NavbarType>(
//                 builder: (context, state) {
//                   if (state == NavbarType.home) {
//                     return FloatingActionButton(
//                       onPressed: () async {
//                         context.read<ImageCubit>().clearImage();

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HeadNewActsScreen(),
//                           ),
//                         );
//                       },
//                       backgroundColor: Colors.blue[200],
//                       child: const Icon(
//                         Icons.add_rounded,
//                         size: 30.0,
//                         color: Colors.black,
//                       ),
//                     );
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 },
//               ),
//               bottomNavigationBar: BottomNavigationBar(
//                 currentIndex: context.read<NavbarCubit>().state.index,
//                 onTap: (index) {
//                   context.read<NavbarCubit>().changeNavbarType(index);
//                   setPreferredTabHeight(index == 1 ? 20 : 0);

//                   if (index == 0) {
//                     context.read<DashboardSlidingUpCubit>().changeType(
//                       DashboardSlidingUpType.deleteManagerActivity,
//                     );

//                     context.read<HeadStoreBloc>().add(
//                       LoadHeadActs(
//                         employeeID: employeeModel.employeeID,
//                         date: DateTime.now().toIso8601String().split('T')[0],
//                       ),
//                     );
//                   } else if (index == 1) {
//                     log('Load Head Store Dashboard');
//                     refreshDashboard();
//                   } else if (index == 2) {
//                     context.read<DashboardSlidingUpCubit>().changeType(
//                       DashboardSlidingUpType.logout,
//                     );
//                   }
//                 },
//                 backgroundColor: Colors.white,
//                 selectedItemColor: Colors.blue,
//                 unselectedItemColor: Colors.grey,
//                 elevation: 8.0,
//                 items: const <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.bar_chart_rounded),
//                     label: 'Report',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.person),
//                     label: 'Profile',
//                   ),
//                 ],
//               ),
//               body: Container(
//                 color: Colors.blue,
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: BlocBuilder<NavbarCubit, NavbarType>(
//                   builder: (context, state) {
//                     if (state == NavbarType.report) {
//                       return HeadDashboardScreen();
//                     } else if (state == NavbarType.profile) {
//                       return ProfileBodyScreen();
//                     } else {
//                       return HeadActivityPage(employeeModel: employeeModel);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
