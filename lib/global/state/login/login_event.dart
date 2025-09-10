import 'package:flutter/material.dart';
import 'package:sip_sales/global/state/provider.dart';

abstract class AccountEvent {
  final BuildContext context;
  final SipSalesState appState;
  final String id;
  final String pass;

  AccountEvent({
    required this.context,
    required this.appState,
    required this.id,
    required this.pass,
  });
}

class LoginEvent extends AccountEvent {
  LoginEvent({
    required super.context,
    required super.appState,
    required super.id,
    required super.pass,
  });
}
