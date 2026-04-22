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
  final bool isRealDevice;
  final bool isJailBroken;
  final bool isNewLogin;

  LoginButtonPressed({
    required super.context,
    required super.id,
    required super.pass,
    this.isRefresh = false,
    this.isRealDevice = false,
    this.isJailBroken = false,
    this.isNewLogin = false,
  });
}

class LogoutButtonPressed extends LoginEvent {
  LogoutButtonPressed({
    required super.context,
    super.id = '',
    super.pass = '',
  });
}
