import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class GlobalDialog {
  static Future<bool> showIOSPermissionGranted(
    BuildContext context,
    String title,
    String content, {
    String acceptText = 'Allow',
    String denyText = 'Deny',
    int actionButtonAmount = 1,
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

  static Future<bool> showAndroidPermissionGranted(
    BuildContext context,
    String title,
    String content,
  ) async {
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
                    'Deny',
                    style: GlobalFont.bigfontR,
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Allow',
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
}
