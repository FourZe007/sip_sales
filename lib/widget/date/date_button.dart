import 'package:flutter/material.dart';
import 'package:sip_sales/widget/format.dart';

class DateFilterButton extends StatefulWidget {
  const DateFilterButton(this.tgl, this.handle, this.isDisable, {super.key});

  final String tgl;
  final Function handle;
  final bool isDisable;

  @override
  State<DateFilterButton> createState() => _DateFilterButtonState();
}

class _DateFilterButtonState extends State<DateFilterButton> {
  String tgl = '';

  @override
  void initState() {
    tgl = widget.tgl == ''
        ? DateTime.now().toString().substring(0, 10)
        : widget.tgl;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.parse(tgl)) {
      setState(() {
        tgl = picked.toString().substring(0, 10);
      });
      widget.handle(tgl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.3125,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Adjust shadow color as needed
              offset: Offset(2.0, 4.0), // Adjust shadow offset
              blurRadius: 5.0, // Adjust shadow blur radius
              spreadRadius: 1.0, // Adjust shadow spread radius
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Icon(
                Icons.date_range_rounded,
                size: 20,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                Format.tanggalFormat(tgl),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
