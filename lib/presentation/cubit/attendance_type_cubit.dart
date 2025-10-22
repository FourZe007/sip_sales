import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceTypeCubit extends Cubit<String> {
  AttendanceTypeCubit() : super('');

  void changeType(String type) => emit(type);
}
