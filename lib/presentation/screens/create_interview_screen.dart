import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/counter.dart';
import 'package:sip_sales_clean/presentation/widgets/image/dotted_rounded_image_picker.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/title.dart';

class CreateInterviewScreen extends StatefulWidget {
  const CreateInterviewScreen({super.key});

  @override
  State<CreateInterviewScreen> createState() => _CreateInterviewScreenState();
}

class _CreateInterviewScreenState extends State<CreateInterviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text(
          'Interview',
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
                              'Masukkan data untuk membuat laporan interview.',
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),

                      // ~:Body:~
                      Column(
                        children: [
                          // ~:Counter Section:~
                          Column(
                            spacing: 8,
                            children: [
                              Counter.person(
                                context,
                                'called_mp',
                                'Jumlah yg dipanggil',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'came_mp',
                                'Jumlah yg datang',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'acc_mp',
                                'Jumlah yg diterima',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'fb_itv',
                                'Facebook',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'ig_itv',
                                'Instagram',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'training_itv',
                                'Balai Latihan Kerja',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'cv_itv',
                                'Kirim CV langsung',
                                defaultNumber: 0,
                              ),
                              Counter.person(
                                context,
                                'other_itv',
                                'Other',
                                defaultNumber: 0,
                              ),
                              Counter.automaticPerson(
                                context,
                                'Jumlah lamaran kerja',
                                [
                                  'fb_itv',
                                  'ig_itv',
                                  'training_itv',
                                  'cv_itv',
                                  'other_itv',
                                ],
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
