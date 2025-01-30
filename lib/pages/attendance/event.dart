import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class EventDescPage extends StatefulWidget {
  const EventDescPage({super.key});

  @override
  State<EventDescPage> createState() => _EventDescPageState();
}

class _EventDescPageState extends State<EventDescPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Event',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Event',
                style: GlobalFont.terafontRBold,
              ),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.075,
              MediaQuery.of(context).size.height * 0.03,
              MediaQuery.of(context).size.width * 0.075,
              0.0,
            ),
            child: Column(
              children: [
                // ~:Page Content:~
                Expanded(
                  child: Wrap(
                    runSpacing: MediaQuery.of(context).size.height * 0.025,
                    children: [
                      // ~:Header:~
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Event',
                            style: GlobalFont.giantfontRBold,
                          ),
                          Text(
                            'Masukkan informasi terkait event dengan lengkap.',
                            style: GlobalFont.bigfontR,
                          ),
                        ],
                      ),

                      // ~:Content:~
                    ],
                  ),
                ),

                // ~:Button Section:~
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Buat',
                    style: GlobalFont.mediumgiantfontR,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
