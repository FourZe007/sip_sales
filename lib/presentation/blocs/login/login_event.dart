import 'package:flutter/material.dart';

abstract class LoginEvent {
  final BuildContext context;
  final String id;
  final String pass;

  LoginEvent({
    required this.context,
    required this.id,
    required this.pass,
  });
}

class LoginButtonPressed extends LoginEvent {
  final bool isRefresh;

  LoginButtonPressed({
    required super.context,
    required super.id,
    required super.pass,
    this.isRefresh = false,
  });
}

class LogoutButtonPressed extends LoginEvent {
  LogoutButtonPressed({
    required super.context,
    super.id = '',
    super.pass = '',
  });
}
