import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales_clean/core/helpers/validator.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.controller, {
    this.isAutoFocusEnable = false,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.enableValidator = false,
    this.validatorType = '',
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters = const [],
    this.isLabelFloat = false,
    this.borderRadius = 10,
    this.isEnabled = true,
    this.showPassword = false,
    super.key,
  });

  final String hintText;
  final String labelText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final bool isAutoFocusEnable;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool enableValidator;
  final String validatorType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final bool isLabelFloat;
  final double borderRadius;
  final bool isEnabled;
  bool showPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final _formKey = GlobalKey<FormState>();

  String? Function(String?)? get _getValidator {
    switch (widget.validatorType) {
      case 'email':
        return Validator.emailValidation;
      case 'id':
        return Validator.idValidator;
      case 'name':
        return Validator.nameValidator;
      case 'username':
        return Validator.usernameValidator;
      case 'password':
        return Validator.passwordValidation;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: Alignment.center,
        child: TextFormField(
          maxLines: 1,
          autofocus: widget.isAutoFocusEnable,
          focusNode: FocusNode(canRequestFocus: false),
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          controller: widget.controller,
          enabled: widget.isEnabled,
          obscureText: widget.isPassword && widget.showPassword,
          style: widget.isEnabled
              ? TextThemes.textfieldPlaceholder
              : TextThemes.textfieldPlaceholder.copyWith(
                  color: Colors.grey,
                ),
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white54,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            hintStyle: TextThemes.textfieldPlaceholder,
            hintText: widget.hintText.contains('e.g.')
                ? widget.hintText
                : 'Enter ${widget.hintText}',
            labelText: widget.labelText,
            floatingLabelBehavior: widget.isLabelFloat
                ? FloatingLabelBehavior.always
                : FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      widget.showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.showPassword = !widget.showPassword;
                      });
                    },
                  )
                : null,
            helperText: widget.enableValidator ? ' ' : null,
            helperStyle: const TextStyle(height: 1),
            errorStyle: const TextStyle(height: 1),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.enableValidator ? _getValidator : null,
          onChanged: (newValues) {},
        ),
      ),
    );
  }
}
