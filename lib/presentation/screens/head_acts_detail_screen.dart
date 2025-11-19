import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/screens/image_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class HeadActDetailScreen extends StatefulWidget {
  const HeadActDetailScreen({super.key});

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
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    children: state.headActsDetails.asMap().entries.map((e) {
                      final HeadActsDetailsModel data = e.value;

                      if (data.pic1.isEmpty) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Text(
                            data.actDesc,
                            style: TextThemes.normal.copyWith(fontSize: 16),
                          ),
                        );
                      } else {
                        return Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Text(
                                data.actDesc,
                                style: TextThemes.normal.copyWith(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ImageScreen(headActs: data),
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
                                  base64Decode(data.pic1),
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }).toList(),
                  );
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
