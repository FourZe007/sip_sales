// NOT USED YET
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales/global/global.dart';

class MultilineTextField extends StatefulWidget {
  final String initialText;
  final String hintText;
  final Function(String) onChanged;

  const MultilineTextField({
    Key? key,
    required this.initialText,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  MultilineTextFieldState createState() => MultilineTextFieldState();
}

class MultilineTextFieldState extends State<MultilineTextField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9./@\s:()%+-?]*'),
                ),
              ],
              style: GlobalFont.mediumgiantfontR,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[400],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.015,
                ),
                hintStyle: GlobalFont.mediumbigfontM,
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        );
      },
    );
  }
}
