import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/counter.dart';
import 'package:sip_sales_clean/presentation/widgets/image/dotted_rounded_image_picker.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/custom_textformfield.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/title.dart';

class CreateVisitScreen extends StatefulWidget {
  const CreateVisitScreen({super.key});

  @override
  State<CreateVisitScreen> createState() => _CreateVisitScreenState();
}

class _CreateVisitScreenState extends State<CreateVisitScreen> {
  final TextEditingController actTypeController = TextEditingController();
  final TextEditingController displayUnitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text(
          'Visit Market',
          style: TextThemes.normal.copyWith(
            fontSize: 16,
          ),
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
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            spacing: 8,
            children: [
              // ~:Page Content:~
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    spacing: 12,
                    children: [
                      // ~:Header:~
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ~:Screen Title:~
                            CustomText(
                              'Informasi Laporan',
                              fontSize: 16,
                            ),

                            // ~:Screen Subtitle:~
                            CustomText(
                              'Masukkan data untuk membuat laporan visit market.',
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),

                      // ~:User Input:~
                      // includes textfields and counter
                      Column(
                        spacing: 4,
                        children: [
                          // ~:Activity Type Textfield:~
                          CustomTextFormField(
                            'activity type',
                            'Jenis Aktivitas',
                            const Icon(Icons.run_circle_outlined),
                            actTypeController,
                            inputFormatters: [Formatter.normalFormatter],
                            borderRadius: 20,
                          ),

                          // ~:Display Unit Textfield:~
                          CustomTextFormField(
                            'display unit',
                            'Unit Display',
                            const Icon(Icons.pedal_bike_sharp),
                            actTypeController,
                            inputFormatters: [Formatter.normalFormatter],
                            borderRadius: 20,
                          ),

                          // ~:Counter Section:~
                          Column(
                            spacing: 8,
                            children: [
                              // ~:Total Sales:~
                              Counter.person(
                                context,
                                'ttl_sales',
                                'Jumlah Sales',
                                defaultNumber: 0,
                              ),

                              // ~:Database:~
                              Counter.person(
                                context,
                                'db',
                                'Database',
                                defaultNumber: 0,
                              ),

                              // ~:Hot Prospect:~
                              Counter.person(
                                context,
                                'hot_pros',
                                'Hot Prospek',
                                defaultNumber: 0,
                              ),

                              // ~:Deal:~
                              Counter.person(
                                context,
                                'deal',
                                'Deal',
                                defaultNumber: 0,
                              ),

                              // ~:Unit Test Ride:~
                              Counter.person(
                                context,
                                'test_ride',
                                'Unit Test Ride',
                                defaultNumber: 0,
                              ),

                              // ~:Test Ride Participant:~
                              Counter.person(
                                context,
                                'test_ride_participant',
                                'Peserta Test Ride',
                                defaultNumber: 0,
                              ),
                            ],
                          ),

                          // ~:Photo Section:~
                          DottedRoundedImagePicker(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ~:Page Content - Footer:~
              // Create Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    'Buat',
                    style: TextThemes.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
