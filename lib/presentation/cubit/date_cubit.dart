import 'package:flutter_bloc/flutter_bloc.dart';

class DateCubit extends Cubit<String> {
  DateCubit() : super(DateTime.now().toString().substring(0, 10));

  void setDate(String date) => emit(date.toString().substring(0, 10));

  String getDate() => state;

  void resetDate() => emit(DateTime.now().toString().substring(0, 10));
}
