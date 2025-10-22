import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';

class DashboardSlidingUpCubit extends Cubit<DashboardSlidingUpState> {
  DashboardSlidingUpCubit()
    : super(DashboardSlidingUpState(type: DashboardSlidingUpType.none));

  void changeType(DashboardSlidingUpType type, {String data = ''}) =>
      emit(DashboardSlidingUpState(type: type, optionalData: data));

  void closePanel() {
    if (state.type != DashboardSlidingUpType.none) {
      emit(DashboardSlidingUpState(type: DashboardSlidingUpType.none));
    }
  }
}

class DashboardSlidingUpState {
  final DashboardSlidingUpType type;
  final String optionalData;

  DashboardSlidingUpState({
    required this.type,
    this.optionalData = '',
  });
}
