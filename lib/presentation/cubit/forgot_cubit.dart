import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/domain/repositories/login_domain.dart';

class ForgotCubit extends Cubit<ForgotState> {
  final LoginRepo loginRepository;

  ForgotCubit({required this.loginRepository}) : super(ForgotInitial());

  Future<void> resetState() async {
    emit(ForgotInitial());
  }

  Future<void> forgotPassword(
    String employeeId,
    String currentPassword,
    String newPassword,
  ) async {
    if (employeeId.isEmpty && currentPassword.isEmpty && newPassword.isEmpty) {
      emit(PasswordChangeFailed(message: 'Semua field harus diisi!'));
    } else {
      try {
        emit(ForgotLoading());

        final res = await loginRepository.forgotPassword(
          employeeId,
          currentPassword,
          newPassword,
        );

        if (res['status'] == 'success') {
          emit(PasswordChangeSucceed(newPass: newPassword));
        } else {
          emit(PasswordChangeFailed(message: res['data']));
        }
      } catch (e) {
        emit(PasswordChangeFailed(message: e.toString()));
      }
    }
  }

  Future<void> resetPassword(
    String employeeId,
  ) async {
    if (employeeId.isEmpty) {
      emit(PasswordResetFailed(message: 'Employee ID harus diisi!'));
    } else {
      try {
        emit(ForgotLoading());

        final res = await loginRepository.resetPassword(employeeId);

        if (res['status'] == 'success') {
          emit(PasswordResetSucceed());
        } else {
          emit(PasswordResetFailed(message: res['data']));
        }
      } catch (e) {
        emit(PasswordResetFailed(message: e.toString()));
      }
    }
  }

  Future<void> requestId(
    String phoneNumber,
  ) async {
    if (phoneNumber.isEmpty) {
      emit(RequestIdFailed(message: 'Nomor telepon harus diisi!'));
    } else {
      emit(ForgotLoading());
      try {
        final res = await loginRepository.requestId(phoneNumber);

        if (res['status'] == 'success') {
          emit(RequestIdSucceed());
        } else {
          emit(RequestIdFailed(message: res['data']));
        }
      } catch (e) {
        emit(RequestIdFailed(message: e.toString()));
      }
    }
  }
}

class ForgotState {}

class ForgotInitial extends ForgotState {}

class ForgotLoading extends ForgotState {}

class PasswordChangeSucceed extends ForgotState {
  final String newPass;

  PasswordChangeSucceed({required this.newPass});
}

class PasswordChangeFailed extends ForgotState {
  final String message;

  PasswordChangeFailed({required this.message});
}

class PasswordResetSucceed extends ForgotState {}

class PasswordResetFailed extends ForgotState {
  final String message;

  PasswordResetFailed({required this.message});
}

class RequestIdSucceed extends ForgotState {}

class RequestIdFailed extends ForgotState {
  final String message;

  RequestIdFailed({required this.message});
}
