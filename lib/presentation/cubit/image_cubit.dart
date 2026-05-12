import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:sip_sales_clean/data/models/result_message_2.dart';
import 'package:sip_sales_clean/domain/repositories/image_domain.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImageRepo imageRepo;
  final ImagePicker _picker = ImagePicker();

  ImageCubit(this.imageRepo) : super(ImageInitial());

  Future<void> showHdImage(
    String branch,
    String shop,
    String actId,
    String date,
  ) async {
    try {
      emit(ImageLoading());

      final res = await imageRepo.getHDImage(branch, shop, actId, date);
      log('ShowHdImage: $res');

      if (res['status'] == 'success' &&
          res['code'] == '100' &&
          res['data'] != '') {
        emit(ImageAvailable(res['data']));
      } else {
        emit(ImageNotAvailable(res['code']));
      }
    } catch (e) {
      emit(ImageNotAvailable(e.toString()));
    }
  }

  Future<void> uploadImage(String employeeId) async {
    try {
      emit(ImageLoading());
      log('uploading image');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Adjust quality as needed
        // maxWidth: 800, // Adjust max width as needed
      );
      log('image taken from camera');

      if (image != null) {
        log('Image is not null');
        // ~:add ML process to check either the photo contains face or not
        // Step 1 — Decode JPEG to img.Image (mirrors convertCameraImage for raw frames)
        final bytes = await image.readAsBytes();
        final decodedImage = img.decodeImage(Uint8List.fromList(bytes));
        if (decodedImage == null) {
          emit(
            const ImageError('Tidak ada wajah yang terdeteksi dalam gambar.'),
          );
          return;
        }
        log(
          'Decode JPEG to img.Image (mirrors convertCameraImage for raw frames)',
        );

        // Step 2 — Build InputImage from decoded bytes (mirrors InputImage.fromBytes in onProcessCameraFrame)
        final bgraBytes = Uint8List.fromList(
          decodedImage.getBytes(order: img.ChannelOrder.bgra),
        );
        final inputImage = InputImage.fromBytes(
          bytes: bgraBytes,
          metadata: InputImageMetadata(
            size: Size(
              decodedImage.width.toDouble(),
              decodedImage.height.toDouble(),
            ),
            rotation: InputImageRotation.rotation0deg,
            format: switch (Platform.isIOS) {
              true => InputImageFormat.bgra8888,
              false => InputImageFormat.nv21,
            },
            bytesPerRow: decodedImage.width * 4,
          ),
        );
        log('Build InputImage from decoded bytes');

        // Step 3 — Detect face (mirrors _faceDetector.processImage)
        final faceDetector = FaceDetector(
          options: FaceDetectorOptions(enableClassification: true),
        );

        try {
          final faces = await faceDetector.processImage(inputImage);
          if (faces.isEmpty) {
            emit(
              const ImageError('Tidak ada wajah yang terdeteksi dalam gambar.'),
            );
            return;
          }
        } catch (e) {
          // fail safe — if detection throws, allow upload to proceed
          log('Face detector error: $e');
          emit(ImageError('Face Detector error: $e'));
          return;
        } finally {
          faceDetector.close();
        }
        log('face detected');

        // ~:API call with its if-else statement:~
        final res = await imageRepo.uploadProfilePicture(
          '1',
          employeeId,
          base64Encode(await image.readAsBytes()),
        );
        log(
          'API call result: ${res['status']}, ${res['code']}, ${(res['data'] as ResultMessageModel2).resultMessage}',
        );

        if (res['status'] == 'success' &&
            res['code'] == '100' &&
            (res['data'] as ResultMessageModel2).resultMessage
                    .toString()
                    .toLowerCase() ==
                'sukses') {
          log('Image successfully captured');
          emit(ImageCaptured(image));
        } else {
          log('Image failed to capture');
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
      log('UploadImage Error: $e');
      emit(ImageError(e.toString()));
    }
  }

  Future<void> uploadCapturedImage(String employeeId, XFile image) async {
    try {
      emit(ImageLoading());
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
        emit(ImageError((res['data'] as ResultMessageModel2).resultMessage));
      }
    } catch (e) {
      log('uploadCapturedImage error: $e');
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

class ImageAvailable extends ImageState {
  final String image;

  const ImageAvailable(this.image);

  @override
  List<Object?> get props => [image];
}

class ImageNotAvailable extends ImageState {
  final String message;

  const ImageNotAvailable(this.message);

  @override
  List<Object?> get props => [message];
}
