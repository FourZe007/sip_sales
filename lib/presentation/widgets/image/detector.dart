import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageDetector {
  static Future<bool> hasFace(XFile image) async {
    // try {
    //   // final inputImage = await _getInputImage(image);
    //   // if (inputImage == null) return false;

    //   // final faceDetector = FaceDetector(
    //   //   options: FaceDetectorOptions(
    //   //     enableClassification: true,
    //   //     enableLandmarks: true,
    //   //     enableTracking: true,
    //   //     enableContours: true,
    //   //     performanceMode: FaceDetectorMode.accurate,
    //   //   ),
    //   // );
    //   // log(faceDetector.toString());

    //   // final faces = await faceDetector.processImage(inputImage);
    //   // log('is image available: ${faces.isNotEmpty}');
    //   // await faceDetector.close();

    //   // return faces.isNotEmpty;
    //   return false;
    // } catch (e) {
    //   log('face detection error: $e');
    //   return false;
    // }

    // ~:NEW:~
    // // Create a GoogleVisionImage object with data from the image we retrieved from the gallery
    // final googleVisionImage = GoogleVisionImage.fromFilePath(image.path);

    // // Create FaceDetector object
    // final faceDetector = GoogleVision.instance.faceDetector();

    // // Run the process to detect faces
    // final faces = await faceDetector.processImage(googleVisionImage);

    // return faces.isNotEmpty;
    return false;
  }

  // static Future<InputImage?> _getInputImage(XFile? image) async {
  //   if (image == null) return null;

  //   return InputImage.fromFilePath(File(image.path).path);
  // }
}
