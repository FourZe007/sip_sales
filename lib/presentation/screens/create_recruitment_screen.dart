import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/image/dotted_rounded_image_picker.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/custom_textformfield.dart';

class CreateRecruitmentScreen extends StatefulWidget {
  const CreateRecruitmentScreen({super.key});

  @override
  State<CreateRecruitmentScreen> createState() =>
      _CreateRecruitmentScreenState();
}

class _CreateRecruitmentScreenState extends State<CreateRecruitmentScreen> {
  final TextEditingController mediaController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

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
          'Recruitment',
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
              // ~:Body:~
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
                            // ~:Title:~
                            Text(
                              'Informasi Laporan',
                              style: TextThemes.subtitle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ~:Description:~
                            Text(
                              'Masukkan data untuk membuat laporan rekrutmen.',
                              style: TextThemes.normal,
                            ),
                          ],
                        ),
                      ),

                      // ~:User Input:~
                      // includes textfields and image button
                      Column(
                        children: [
                          // ~:Media Textfield:~
                          CustomTextFormField(
                            'e.g. Instagram, Facebook, LinkedIn',
                            'Media',
                            const Icon(Icons.public_rounded),
                            mediaController,
                            inputFormatters: [Formatter.normalFormatter],
                            borderRadius: 20,
                          ),

                          // ~:Position Textfield:~
                          CustomTextFormField(
                            'e.g. Salesman',
                            'Posisi',
                            const Icon(Icons.work),
                            positionController,
                            inputFormatters: [Formatter.normalFormatter],
                            borderRadius: 20,
                          ),

                          // ~:Image Section:~
                          DottedRoundedImagePicker(isUploadWithGallery: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ~:Create Button:~
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
