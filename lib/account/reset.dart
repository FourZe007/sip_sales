import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  String password = '';
  String confirm = '';

  void setPassword(String value) {
    password = value;
  }

  void setConfirm(String value) {
    confirm = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const Image(
            image: AssetImage(
              './assets/password.png',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: CustomUserInput2(
              setPassword,
              password,
              mode: 0,
              isPass: true,
              isIcon: true,
              icon: Icons.lock,
              hint: 'Password',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: CustomUserInput2(
              setConfirm,
              confirm,
              mode: 0,
              isPass: true,
              isIcon: true,
              icon: Icons.lock,
              hint: 'Password Konfirmasi',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.04,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Adjust shadow color as needed
                    offset: Offset(2.0, 4.0), // Adjust shadow offset
                    blurRadius: 5.0, // Adjust shadow blur radius
                    spreadRadius: 1.0, // Adjust shadow spread radius
                  ),
                ],
              ),
              child: Text(
                'RESET',
                style: GlobalFont.bigfontMWhiteBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
