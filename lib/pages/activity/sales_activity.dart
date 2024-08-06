import 'package:flutter/material.dart';

class SalesActivityPage extends StatefulWidget {
  const SalesActivityPage({super.key});

  @override
  State<SalesActivityPage> createState() => _SalesActivityPageState();
}

class _SalesActivityPageState extends State<SalesActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: const Text('Sales Activity'),
      ),
    );
  }
}
