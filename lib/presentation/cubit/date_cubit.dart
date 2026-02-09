import 'package:flutter_bloc/flutter_bloc.dart';

class DateCubit extends Cubit<String> {
  DateCubit() : super(DateTime.now().toIso8601String().substring(0, 10));

  void setDate(DateTime date) => emit(date.toIso8601String().substring(0, 10));

  void resetDate() => emit(DateTime.now().toIso8601String().substring(0, 10));
}
