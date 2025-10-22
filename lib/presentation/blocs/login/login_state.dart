import 'package:sip_sales_clean/data/models/employee.dart';

abstract class LoginState {}

class LoginInit extends LoginState {}

class LoginLoading extends LoginState {
  final bool isRefresh;

  LoginLoading({this.isRefresh = false});
}

class LoginSuccess extends LoginState {
  final bool isRefresh;
  final EmployeeModel user;

  LoginSuccess({this.isRefresh = false, required this.user});
}

class LoginFailed extends LoginState {
  final bool isRefresh;
  final String message;

  LoginFailed({this.isRefresh = false, required this.message});
}

class LoginUnauthenticated extends LoginState {}

class LogoutLoading extends LoginState {}

class LogoutSuccess extends LoginState {}

class LogoutFailed extends LoginState {
  final String message;

  LogoutFailed(this.message);
}
