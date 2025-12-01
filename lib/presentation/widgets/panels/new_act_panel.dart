import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class NewActPanel extends StatefulWidget {
  const NewActPanel({super.key});

  @override
  State<NewActPanel> createState() => _NewActPanelState();
}

class _NewActPanelState extends State<NewActPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Column(
        spacing: 8,
        children: [
          Text(
            'Buat Laporan / Tambah Data',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: Column(
              children: [
                DefaultTextStyle(
                  style: TextThemes.normalTextButton,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Morning Briefing'),
                    ),
                  ),
                ),

                const Divider(height: 0.5),

                DefaultTextStyle(
                  style: TextThemes.normalTextButton,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Visit Market'),
                    ),
                  ),
                ),

                const Divider(height: 0.5),

                DefaultTextStyle(
                  style: TextThemes.normalTextButton,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Recruitment'),
                    ),
                  ),
                ),

                const Divider(height: 0.5),

                DefaultTextStyle(
                  style: TextThemes.normalTextButton,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Interview'),
                    ),
                  ),
                ),

                const Divider(height: 0.5),

                DefaultTextStyle(
                  style: TextThemes.normalTextButton,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Daily Report'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
