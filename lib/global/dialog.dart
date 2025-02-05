import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class GlobalDialog {
  static Future<void> loadAndPreviewImage(
    BuildContext context,
    Future func,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FutureBuilder(
            future: func,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                if (Platform.isIOS) {
                  return const CupertinoActivityIndicator(
                    radius: 12.5,
                    color: Colors.black,
                  );
                } else {
                  return const CircleLoading(
                    warna: Colors.black,
                  );
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Foto tidak tersedia');
              } else {
                if (snapshot.data == 'not available') {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Foto tidak tersedia.',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  );
                } else if (snapshot.data == 'failed') {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Foto gagal dimuat.',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  );
                } else if (snapshot.data == 'failed') {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Terjadi kesalahan. Mohon coba lagi.',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      base64Decode(snapshot.data),
                      fit: BoxFit.contain,
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  static Future<void> previewImage(
    BuildContext context,
    String img,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(
              base64Decode(img),
            ),
          ),
        );
      },
    );
  }

  static Future<void> previewProfileImage(
    BuildContext context,
    String img,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return CircleAvatar(
          foregroundImage: MemoryImage(
            base64Decode(img),
          ),
        );
      },
    );
  }

  static Future<bool> showIOSDialogOption(
    BuildContext context,
    String title,
    String content, {
    String acceptText = 'Allow',
    String denyText = 'Deny',
  }) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(denyText),
                  onPressed: () => Navigator.pop(context, false),
                ),
                CupertinoDialogAction(
                  child: Text(acceptText),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<void> showIOSPermissionDenied(
    BuildContext context,
    String title,
    String content,
  ) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: const Text('Tutup'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCustomIOSDialog(
    BuildContext context,
    String title,
    String content,
    Function acceptHandler,
    String acceptText, {
    Function? cancelHandler,
    String cancelText = '',
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        if (cancelText != '' && cancelHandler != null) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(cancelText),
                onPressed: () => cancelHandler(),
              ),
              CupertinoDialogAction(
                child: Text(acceptText),
                onPressed: () => acceptHandler(),
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(acceptText),
                onPressed: () => acceptHandler(),
              ),
            ],
          );
        }
      },
    );
  }

  static Future<bool> showAndroidDialogOption(
    BuildContext context,
    String title,
    String content, {
    String acceptText = 'Allow',
    String denyText = 'Deny',
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: Text(
                content,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: Text(
                    denyText,
                    style: GlobalFont.bigfontR,
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    acceptText,
                    style: GlobalFont.bigfontRBold,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<void> showCustomAndroidDialog(
    BuildContext context,
    String title,
    String content,
    Function acceptHandler,
    String acceptText, {
    Function? cancelHandler,
    String cancelText = '',
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (cancelText != '' && cancelHandler != null) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  cancelText,
                  textAlign: TextAlign.center,
                ),
                onPressed: () => cancelHandler(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  acceptText,
                  style: GlobalFont.bigfontR,
                  textAlign: TextAlign.center,
                ),
                onPressed: () => acceptHandler(),
              ),
            ],
          );
        } else {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  acceptText,
                  style: GlobalFont.bigfontRBold,
                ),
                onPressed: () => acceptHandler(),
              ),
            ],
          );
        }
      },
    );
  }

  static Future<void> showCrossPlatformDialog(
    BuildContext context,
    String title,
    String content,
    Function handler,
    String text, {
    bool isIOS = false,
    bool isDismissable = false,
  }) {
    if (isIOS) {
      return showCupertinoDialog(
        context: context,
        barrierDismissible: isDismissable,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                onPressed: () => handler(),
                child: Text(text),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: isDismissable,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  text,
                  style: GlobalFont.bigfontR,
                ),
                onPressed: () => handler(),
              ),
            ],
          );
        },
      );
    }
  }

  static void showCrossPlatformCustomOption(
    BuildContext context,
    String title,
    String content,
    String acceptText,
    Function acceptHandler,
    String denyText,
    Function denyHandler, {
    bool isIOS = false,
  }) {
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(denyText),
                onPressed: () => denyHandler(),
              ),
              CupertinoDialogAction(
                child: Text(acceptText),
                onPressed: () => acceptHandler(),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[350],
                ),
                child: Text(
                  denyText,
                  style: GlobalFont.bigfontR,
                ),
                onPressed: () => denyHandler(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  acceptText,
                  style: GlobalFont.bigfontR,
                ),
                onPressed: () => acceptHandler(),
              ),
            ],
          );
        },
      );
    }
  }
}
