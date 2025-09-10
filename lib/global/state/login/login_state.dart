import 'package:sip_sales/global/model.dart';

abstract class LoginState {}

class LoginInit extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final List<ModelUser> user;

  LoginSuccess(this.user);
}

class LoginFailed extends LoginState {
  final String message;

  LoginFailed(this.message);
}
