import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/screens/image_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    child: Text('Data Tidak Ditemukan'),
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
  HeadBriefingDetailsModel data,
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
          // ~:Location:~
          Text(
            'Lokasi: ${Formatter.toTitleCase(data.locationName)}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Head Store:~
          Text(
            'Kepala Toko: ${data.shopManager}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Sales Counter:~
          Text(
            'Sales Counter: ${data.salesCounter}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Salesman:~
          Text(
            'Salesman: ${data.salesman}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Other Participants:~
          Text(
            'Lain-lain: ${data.others}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Description:~
          Text(
            'Deskripsi: ${data.description}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey[600]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.memory(
                        base64Decode(data.img),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
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
  HeadVisitDetailsModel data,
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
          // ~:Date and Time:~
          Text(
            'Tanggal ${Formatter.dateFormat(data.date)}, Pukul ${data.time}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Location:~
          Text(
            'Lokasi: ${data.lokasi} ${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Activity Type:~
          Text(
            'Jenis aktivitas: ${data.jenisAktivitas}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Salesman:~
          Text(
            'Jumlah salesman: ${data.salesman}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Unit Display Name:~
          Text(
            'Unit display: ${data.unitDisplay}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Customer Database:~
          Text(
            'Jumlah database: ${data.database}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Hot Prospect:~
          Text(
            'Jumlah hot prospek: ${data.hotProspek}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Deal:~
          Text(
            'Jumlah deal: ${data.deal}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Unit Test Ride Name:~
          Text(
            'Unit test ride: ${data.unitTestRide}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Test Ride:~
          Text(
            'Jumlah test ride: ${data.pesertaTestRide}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey[600]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.memory(
                        base64Decode(data.img),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
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
  HeadRecruitmentDetailsModel data,
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
          // ~:Date and Time:~
          Text(
            'Tanggal ${Formatter.dateFormat(data.date)}, Pukul ${data.time}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Location:~
          Text(
            'Lokasi: ${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Media Name:~
          Text(
            'Media: ${data.media}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Position:~
          Text(
            'Posisi: ${data.posisi}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey[600]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.memory(
                        base64Decode(data.img),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
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
  HeadInterviewDetailsModel data,
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
          // ~:Date and Time:~
          Text(
            'Tanggal ${Formatter.dateFormat(data.currentDate)}, Pukul ${data.currentTime}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Location:~
          Text(
            'Lokasi: ${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Called Employee:~
          Text(
            'Jumlah dipanggil: ${data.dipanggil}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Arrived Employee:~
          Text(
            'Jumlah yang datang: ${data.datang}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Number of Accepted Employee:~
          Text(
            'Jumlah yang diterima: ${data.diterima}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Sources of Media with their numbers:~
          ListView(
            children: data.listMedia.asMap().entries.map((e) {
              final value = e.value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(Formatter.toTitleCase(value.mediaName!)),
                  Text(value.qty.toString()),
                ],
              );
            }).toList(),
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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey[600]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.memory(
                        base64Decode(data.img),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
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
  HeadReportDetailsModel data,
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
          // ~:Date and Time:~
          Text(
            'Tanggal ${Formatter.dateFormat(data.currentDate)}, Pukul ${data.currentTime}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),

          // ~:Location:~
          Text(
            'Lokasi: ${Formatter.toTitleCase(data.bsName)}, ${Formatter.toTitleCase(data.area)}',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey[600]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.memory(
                        base64Decode(data.img),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
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
