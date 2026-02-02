import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sip_sales_clean/data/models/result_message_2.dart';
import 'package:sip_sales_clean/domain/repositories/image_domain.dart';
import 'package:sip_sales_clean/presentation/widgets/image/detector.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImageRepo imageRepo;
  final ImagePicker _picker = ImagePicker();

  ImageCubit(this.imageRepo) : super(ImageInitial());

  Future<void> uploadImage(String employeeId) async {
    try {
      emit(ImageLoading());

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Adjust quality as needed
        // maxWidth: 800, // Adjust max width as needed
      );

      if (image != null) {
        // ~:add ML process to check either the photo contains face or not
        final deviceInfoPlugin = DeviceInfoPlugin();
        bool shouldCheckFace = false;

        if (Platform.isIOS) {
          final iosInfo = (await deviceInfoPlugin.iosInfo).systemVersion;
          final double iosVersion = double.parse(iosInfo);
          shouldCheckFace = iosVersion >= 15.5;
        } else {
          final android = (await deviceInfoPlugin.androidInfo).version.sdkInt
              .toString();
          final double androidVersion = double.parse(android);
          shouldCheckFace = androidVersion >= 21;
        }

        if (shouldCheckFace) {
          if (!(await ImageDetector.hasFace(image))) {
            emit(ImageError('Tidak ada wajah yang terdeteksi dalam gambar.'));
            return;
          }
        }

        // ~:API call with its if-else statement:~
        final res = await imageRepo.uploadProfilePicture(
          '1',
          employeeId,
          base64Encode(await image.readAsBytes()),
        );

        if (res['status'] == 'success' &&
            res['code'] == '100' &&
            (res['data'] as ResultMessageModel2).resultMessage
                    .toString()
                    .toLowerCase() ==
                'sukses') {
          emit(ImageCaptured(image));
        } else {
          emit(
            ImageError(
              (res['data'] as ResultMessageModel2).resultMessage,
            ),
          );
        }
      } else {
        emit(const ImageError('No image selected'));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> captureImage() async {
    try {
      emit(ImageLoading());

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Adjust quality as needed
        maxWidth: 800, // Adjust max width as needed
      );

      if (image != null) {
        emit(ImageCaptured(image));
      } else {
        emit(const ImageError('No image selected'));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> pickImage() async {
    try {
      emit(ImageLoading());
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Adjust quality as needed
        maxWidth: 800, // Adjust max width as needed
      );

      if (image != null) {
        emit(ImageCaptured(image));
      } else {
        emit(const ImageError('No image selected'));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  void clearImage({final bool isDeleted = false}) {
    if (!isDeleted) {
      emit(ImageInitial());
    } else {
      emit(ImageDeleted());
    }
  }
}

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object?> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageDeleted extends ImageState {}

class ImageCaptured extends ImageState {
  final XFile image;

  const ImageCaptured(this.image);

  @override
  List<Object?> get props => [image];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object?> get props => [message];
}
