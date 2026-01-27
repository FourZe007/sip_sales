import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/screens/image_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/cards/performance_card.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/report.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/leasing_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/payment_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/salesman_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/stu_report.dart';

class HeadActDetailScreen extends StatefulWidget {
  const HeadActDetailScreen(this.actId, {super.key});

  final String actId;

  @override
  State<HeadActDetailScreen> createState() => _HeadActDetailScreenState();
}

class _HeadActDetailScreenState extends State<HeadActDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            'Detail Kegiatan',
            style: TextThemes.normal.copyWith(fontSize: 16),
          ),
          actions: [
            IconButton(
              onPressed: () => context.read<HeadStoreBloc>().add(
                LoadHeadActsDetail(
                  activityID: widget.actId,
                  employee:
                      (context.read<LoginBloc>().state as LoginSuccess).user,
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                ),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 36.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
            child: BlocBuilder<HeadStoreBloc, HeadStoreState>(
              builder: (context, state) {
                if (state is HeadStoreLoading &&
                    state.isActsDetail &&
                    !state.isActs &&
                    !state.isDashboard &&
                    !state.isInsert) {
                  if (Platform.isIOS) {
                    return const CupertinoActivityIndicator(
                      radius: 12,
                      color: Colors.black,
                    );
                  } else {
                    return const AndroidLoading(
                      warna: Colors.black,
                      strokeWidth: 3,
                    );
                  }
                } else if (state is HeadStoreDataDetailFailed) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is HeadStoreDataDetailLoaded) {
                  switch (widget.actId) {
                    case '00':
                      log('Morning Briefing');
                      if (state.briefingDetail.isNotEmpty) {
                        return briefingDetail(context, state.briefingDetail[0]);
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    case '01':
                      log('Visit Market');
                      if (state.visitDetail.isNotEmpty) {
                        return visitDetail(context, state.visitDetail[0]);
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    case '02':
                      log('Recruitment');
                      if (state.recruitmentDetail.isNotEmpty) {
                        return recruitmentDetail(
                          context,
                          state.recruitmentDetail[0],
                        );
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    case '03':
                      log('Daily Report');
                      if (state.reportDetail.isNotEmpty) {
                        return reportDetail(context, state.reportDetail[0]);
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    case '04':
                      log('Interview');
                      if (state.interviewDetail.isNotEmpty) {
                        return interviewDetail(
                          context,
                          state.interviewDetail[0],
                        );
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    default:
                      log('ActId unidentified');
                      return Center(
                        child: Text('No data available'),
                      );
                  }
                } else {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget briefingDetail(
  BuildContext context,
  HeadBriefingViewModel data,
) {
  final List<Map<String, dynamic>> pieChartList = [
    {
      'title': 'Kepala Toko',
      'number': data.shopManager,
      'color': Color.lerp(Colors.blue[50], Colors.blue, 0.2)!,
    },
    {
      'title': 'Sales Counter',
      'number': data.salesCounter,
      'color': Color.lerp(Colors.blue, Colors.blue[700], 0.5)!,
    },
    {
      'title': 'Salesman',
      'number': data.salesman,
      'color': Color.lerp(Colors.blue[700], Colors.blue[900], 0.7)!,
    },
    {
      'title': 'Others',
      'number': data.others,
      'color': Color.lerp(Colors.blue[900], Colors.purple[700], 0.5)!,
    },
  ]..sort((a, b) => a['number'].compareTo(b['number']));

  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ~:Location:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.3,
              children: [
                // ~:Location:~
                PerformanceCard.baseModel(
                  'Lokasi',
                  Formatter.toTitleCase(data.locationName),
                  boxColor: Colors.lightBlue[100]!,
                ),

                // ~:Topic:~
                PerformanceCard.baseModel(
                  'Topik Kegiatan',
                  data.description,
                  boxColor: Colors.purple[100]!,
                ),
              ],
            ),
          ),

          // ~:Chart:~
          Container(
            width: MediaQuery.of(context).size.width,
            height: 220,
            margin: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                // ~:Title:~
                Text(
                  'Jumlah Peserta',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ~:Chart:~
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ~:Pie Chart:~
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -150,
                            sections: pieChartList
                                .map(
                                  (e) => PieChartSectionData(
                                    value: double.parse(e['number'].toString()),
                                    title: '',
                                    color: e['color'],
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                .toList(),
                            sectionsSpace: 2,
                            // centerSpaceRadius: 32,
                          ),
                        ),
                      ),

                      // ~:Chart Legends:~
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pieChartList.map((e) {
                            final String title = e['title'];
                            final int number = e['number'];
                            final Color color = e['color'];

                            return Row(
                              spacing: 8,
                              children: [
                                // ~:Color Legend:~
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                // ~:Legend Text:~
                                Text(
                                  '$number $title',
                                  style: TextThemes.normal,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ~:Descriptions:~
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ~:Title:~
              Text(
                'Detail Deskripsi',
                style: TextThemes.normal.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ~:Values:~
              Column(
                children: data.details.asMap().entries.map((e) {
                  final int i = e.key + 1;
                  final String detail = e.value.detail;

                  return Row(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${i.toString()}.'),
                      Expanded(
                        child: Text(
                          detail,
                          style: TextThemes.normal.copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),

          // ~:Image Preview:~
          Builder(
            builder: (context) {
              if (data.img.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          img: data.img,
                          lat: data.lat,
                          lng: data.lng,
                          time: data.time,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(4),
                      backgroundColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //     color: Colors.grey[600]!,
                      //     width: 1.5,
                      //   ),
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(20),
                      //   ),
                      // ),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text(
                          'Bukti Foto',
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // ~:Photo:~
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.memory(
                            base64Decode(data.img),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
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
}

Widget visitDetail(
  BuildContext context,
  HeadVisitViewModel data,
) {
  final List<Map<String, dynamic>> pieChartList = [
    {
      'title': 'Jumlah Salesman',
      'number': data.salesman,
      'color': Colors.blue[800]!,
    },
    {
      'title': 'Jumlah Database',
      'number': data.database,
      'color': Colors.blue[400]!,
    },
    {
      'title': 'Jumlah Hot Prospek',
      'number': data.hotProspek,
      'color': Colors.red[800]!,
    },
    {
      'title': 'Jumlah Deal',
      'number': data.deal,
      'color': Colors.yellow[800]!,
    },
    {
      'title': 'Jumlah Test Ride',
      'number': data.pesertaTestRide,
      'color': Colors.purple[800]!,
    },
  ]..sort((a, b) => a['number'].compareTo(b['number']));

  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ~:Grid Boxes:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.3,
              children: [
                // ~:Date and Time:~
                PerformanceCard.baseModel(
                  'Tanggal dan Waktu',
                  '${Formatter.specialDateFormat(data.date)}, ${data.time}',
                  boxColor: Colors.purple[200]!,
                ),

                // ~:Location:~
                PerformanceCard.baseModel(
                  'Lokasi',
                  '${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
                  boxColor: Colors.lightBlue[100]!,
                ),

                // ~:Activity Type:~
                PerformanceCard.baseModel(
                  'Jenis Aktivitas',
                  data.jenisAktivitas,
                  boxColor: Colors.lightBlue[200]!,
                ),

                // ~:Display Unit:~
                PerformanceCard.baseModel(
                  'Unit Display & Test Ride',
                  '${data.unitDisplay} & ${data.unitTestRide}',
                  boxColor: Colors.purple[100]!,
                ),
              ],
            ),
          ),

          // ~:Chart:~
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            margin: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                // ~:Title:~
                Text(
                  'Jumlah Peserta',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ~:Chart:~
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ~:Pie Chart:~
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -150,
                            sections: pieChartList
                                .map(
                                  (e) => PieChartSectionData(
                                    value: double.parse(e['number'].toString()),
                                    title: '',
                                    color: e['color'],
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                .toList(),
                            sectionsSpace: 2,
                            // centerSpaceRadius: 32,
                          ),
                        ),
                      ),

                      // ~:Chart Legends:~
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pieChartList.map((e) {
                            final String title = e['title'];
                            final int number = e['number'];
                            final Color color = e['color'];

                            return Row(
                              spacing: 8,
                              children: [
                                // ~:Color Legend:~
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                // ~:Legend Text:~
                                Text(
                                  '$number $title',
                                  style: TextThemes.normal,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ~:Image Preview:~
          Builder(
            builder: (context) {
              if (data.img.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          img: data.img,
                          lat: data.lat,
                          lng: data.lng,
                          time: data.time,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(4),
                      backgroundColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //     color: Colors.grey[600]!,
                      //     width: 1.5,
                      //   ),
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(20),
                      //   ),
                      // ),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text(
                          'Bukti Foto',
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.memory(
                            base64Decode(data.img),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
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
}

Widget recruitmentDetail(
  BuildContext context,
  HeadRecruitmentViewModel data,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ~:Grid Boxes:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.3,
              children: [
                // ~:Date and Time:~
                PerformanceCard.baseModel(
                  'Tanggal dan Waktu',
                  '${Formatter.specialDateFormat(data.date)}, ${data.time}',
                  boxColor: Colors.purple[200]!,
                ),

                // ~:Location:~
                PerformanceCard.baseModel(
                  'Lokasi',
                  '${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
                  boxColor: Colors.lightBlue[100]!,
                ),

                // ~:Activity Type:~
                PerformanceCard.baseModel(
                  'Media Rekrutmen',
                  data.media,
                  boxColor: Colors.lightBlue[200]!,
                ),

                // ~:Display Unit:~
                PerformanceCard.baseModel(
                  'Posisi',
                  data.posisi,
                  boxColor: Colors.purple[100]!,
                ),
              ],
            ),
          ),

          // ~:Image Preview:~
          Builder(
            builder: (context) {
              if (data.img.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          img: data.img,
                          lat: data.lat,
                          lng: data.lng,
                          time: data.time,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(4),
                      backgroundColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //     color: Colors.grey[600]!,
                      //     width: 1.5,
                      //   ),
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(20),
                      //   ),
                      // ),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text(
                          'Bukti Foto',
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // ~:Photo:~
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.memory(
                            base64Decode(data.img),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
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
}

Widget interviewDetail(
  BuildContext context,
  HeadInterviewViewModel data,
) {
  final List<Map<String, dynamic>> participantPieChartList = [
    {
      'title': 'Jumlah Dipanggil',
      'number': data.dipanggil,
      'color': Colors.blue[800]!,
    },
    {
      'title': 'Jumlah yang Datang',
      'number': data.datang,
      'color': Colors.blue[400]!,
    },
    {
      'title': 'Jumlah yang Diterima',
      'number': data.diterima,
      'color': Colors.purple[800]!,
    },
  ]..sort((a, b) => a['number'].compareTo(b['number']));

  final List<Map<String, dynamic>> mediaPieChartList = [
    {
      'title': Formatter.toTitleCase(data.listMedia[0].mediaName!),
      'number': data.listMedia[0].qty,
      'color': Colors.blue[800]!,
    },
    {
      'title': Formatter.toTitleCase(data.listMedia[1].mediaName!),
      'number': data.listMedia[1].qty,
      'color': Colors.blue[400]!,
    },
    {
      'title': Formatter.toTitleCase(data.listMedia[2].mediaName!),
      'number': data.listMedia[2].qty,
      'color': Colors.purple[800]!,
    },
    {
      'title': Formatter.toTitleCase(data.listMedia[3].mediaName!),
      'number': data.listMedia[3].qty,
      'color': Colors.red[800]!,
    },
    {
      'title': Formatter.toTitleCase(data.listMedia[4].mediaName!),
      'number': data.listMedia[4].qty,
      'color': Colors.yellow[800]!,
    },
  ]..sort((a, b) => a['number'].compareTo(b['number']));

  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ~:Grid Boxes:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.3,
              children: [
                // ~:Date and Time:~
                PerformanceCard.baseModel(
                  'Tanggal dan Waktu',
                  '${Formatter.specialDateFormat(data.currentDate)}, ${data.currentTime}',
                  boxColor: Colors.purple[200]!,
                ),

                // ~:Location:~
                PerformanceCard.baseModel(
                  'Lokasi',
                  '${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
                  boxColor: Colors.lightBlue[100]!,
                ),
              ],
            ),
          ),

          // ~:Participant Chart:~
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            margin: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                // ~:Title:~
                Text(
                  'Jumlah Peserta',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ~:Chart:~
                Expanded(
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ~:Pie Chart:~
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -150,
                            sections: participantPieChartList
                                .map(
                                  (e) => PieChartSectionData(
                                    value: double.parse(e['number'].toString()),
                                    title: '',
                                    color: e['color'],
                                    radius: 40,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                .toList(),
                            sectionsSpace: 2,
                            // centerSpaceRadius: 32,
                          ),
                        ),
                      ),

                      // ~:Chart Legends:~
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: participantPieChartList.map((e) {
                            final String title = e['title'];
                            final int number = e['number'];
                            final Color color = e['color'];

                            return Row(
                              spacing: 8,
                              children: [
                                // ~:Color Legend:~
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                // ~:Legend Text:~
                                Text(
                                  '$number $title',
                                  style: TextThemes.normal,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ~:Media Chart:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: Column(
              children: [
                // ~:Title:~
                Text(
                  'Media',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ~:Chart:~
                Expanded(
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ~:Pie Chart:~
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -150,
                            sections: mediaPieChartList
                                .map(
                                  (e) => PieChartSectionData(
                                    value: double.parse(e['number'].toString()),
                                    title: '',
                                    color: e['color'],
                                    radius: 40,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                .toList(),
                            sectionsSpace: 2,
                            // centerSpaceRadius: 32,
                          ),
                        ),
                      ),

                      // ~:Chart Legends:~
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mediaPieChartList.map((e) {
                            final String title = e['title'];
                            final int number = e['number'];
                            final Color color = e['color'];

                            return Row(
                              spacing: 8,
                              children: [
                                // ~:Color Legend:~
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                // ~:Legend Text:~
                                Text(
                                  '$number $title',
                                  style: TextThemes.normal,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ~:Image Preview:~
          Builder(
            builder: (context) {
              if (data.img.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          img: data.img,
                          lat: data.lat,
                          lng: data.lng,
                          time: data.currentTime,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(4),
                      backgroundColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //     color: Colors.grey[600]!,
                      //     width: 1.5,
                      //   ),
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(20),
                      //   ),
                      // ),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text(
                          'Bukti Foto',
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // ~:Photo:~
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.memory(
                            base64Decode(data.img),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
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
}

Widget reportDetail(
  BuildContext context,
  HeadReportViewModel data,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ~:Grid Boxes:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.3,
              children: [
                // ~:Date and Time:~
                PerformanceCard.baseModel(
                  'Tanggal dan Waktu',
                  '${Formatter.specialDateFormat(data.currentDate)}, ${data.currentTime}',
                  boxColor: Colors.purple[200]!,
                ),

                // ~:Location:~
                PerformanceCard.baseModel(
                  'Lokasi',
                  '${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
                  boxColor: Colors.lightBlue[100]!,
                ),
              ],
            ),
          ),

          // ~:STU Data Table:~
          ReportDataGrid(
            dataSource: StuInsertDataSource(
              data.stuCategories,
              isEditingAllowed: false,
            ),
            tableHeight:
                (115 +
                double.parse((50 * data.stuCategories.length).toString())),
            loadedData: StuType.values.map((e) => e.name.toString()).toList(),
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            textStyle: TextThemes.normal,
          ),

          // ~:Payment Data Table:~
          ReportDataGrid(
            dataSource: PaymentInsertDataSource(
              data.payment,
              isEditingAllowed: false,
            ),
            loadedData: PaymentType.values
                .map((e) => e.name.toString())
                .toList(),
            tableHeight:
                (115 +
                double.parse(
                  (50 * data.payment.length).toString(),
                )),
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            textStyle: TextThemes.normal,
          ),

          // ~:Leasing Data Table:~
          ReportDataGrid(
            dataSource: LeasingInsertDataSource(
              data.leasing,
              isEditingAllowed: false,
            ),
            loadedData: LeasingType.values
                .map((e) => e.name.toString())
                .toList(),
            tableHeight:
                (115 +
                double.parse(
                  (50 * data.leasing.length).toString(),
                )),
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            textStyle: TextThemes.normal,
          ),

          // ~:Salesman Data Table:~
          ReportDataGrid(
            dataSource: SalesmanInsertDataSource(
              data.employee,
              isEditingAllowed: false,
            ),
            loadedData: SalesmanType.values
                .map((e) => e.name.toString())
                .toList(),
            tableHeight:
                (115 +
                double.parse(
                  (50 * data.employee.length).toString(),
                )),
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            textStyle: TextThemes.normal,
          ),

          // ~:Image Preview Box:~
          Builder(
            builder: (context) {
              if (data.img.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          img: data.img,
                          lat: data.lat,
                          lng: data.lng,
                          time: data.currentTime,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(4),
                      backgroundColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //     color: Colors.grey[600]!,
                      //     width: 1.5,
                      //   ),
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(20),
                      //   ),
                      // ),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text(
                          'Bukti Foto',
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // ~:Photo:~
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.memory(
                            base64Decode(data.img),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
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
}
