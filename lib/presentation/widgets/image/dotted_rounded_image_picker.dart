import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class DottedRoundedImagePicker extends StatelessWidget {
  const DottedRoundedImagePicker({this.isUploadWithGallery = false, super.key});

  final bool isUploadWithGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(16),
          color: Colors.black,
          strokeWidth: 2,
          dashPattern: const [4, 4],
          strokeCap: StrokeCap.round,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: BlocConsumer<ImageCubit, ImageState>(
            listener: (context, state) {
              if (state is ImageError) {
                Functions.customSnackBar(
                  context,
                  state.message,
                );
              } else if (state is ImageDeleted) {
                Functions.customSnackBar(
                  context,
                  'Foto berhasil dihapus!',
                );
              } else if (state is ImageCaptured) {
                Functions.customSnackBar(
                  context,
                  'Foto berhasil diupload!',
                );
              }
            },
            builder: (context, state) {
              if (state is ImageLoading) {
                if (Platform.isIOS) {
                  return const CupertinoActivityIndicator(
                    radius: 12.5,
                    color: Colors.black,
                  );
                } else {
                  return const AndroidLoading(
                    warna: Colors.black,
                    strokeWidth: 3,
                  );
                }
              } else if (state is ImageCaptured) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Stack(
                    children: [
                      // ~:Display uploaded image:~
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                  child: Image.file(
                                    File(state.image.path),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          child: Image.file(
                            File(state.image.path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // ~:Delete image button:~
                      Positioned(
                        top: 4,
                        left: 52,
                        child: InkWell(
                          onTap: () => context.read<ImageCubit>().clearImage(
                            isDeleted: true,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                              4,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // ~:Upload image button:~
                // works only when the img var is empty!
                return InkWell(
                  onTap: () async => isUploadWithGallery
                      ? context.read<ImageCubit>().pickImage()
                      : context.read<ImageCubit>().captureImage(),
                  child: SizedBox(
                    width: MediaQuery.of(
                      context,
                    ).size.width,
                    child: const Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                        ),
                        Text(
                          'Upload Foto',
                          style: TextThemes.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
