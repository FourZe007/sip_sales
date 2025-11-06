import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';

class DashboardSlidingUpCubit extends Cubit<DashboardSlidingUpState> {
  DashboardSlidingUpCubit()
    : super(DashboardSlidingUpState(type: DashboardSlidingUpType.none));

  void changeType(DashboardSlidingUpType type, {String data = ''}) => emit(
    DashboardSlidingUpState(
      type: type,
      optionalData: data,
      panelHeight: _getHeightForType(type),
    ),
  );

  void closePanel() {
    if (state.type != DashboardSlidingUpType.none) {
      emit(DashboardSlidingUpState(type: DashboardSlidingUpType.none));
    }
  }

  double _getHeightForType(DashboardSlidingUpType type) {
    switch (type) {
      case DashboardSlidingUpType.none:
        return 150;
      case DashboardSlidingUpType.logout:
        return 325;
      case DashboardSlidingUpType.groupDealer:
        return 150;
      case DashboardSlidingUpType.dealer:
        return 240;
      case DashboardSlidingUpType.leasing:
      case DashboardSlidingUpType.category:
        return 200;
      default:
        return 0;
    }
  }
}

class DashboardSlidingUpState {
  final DashboardSlidingUpType type;
  final double panelHeight;
  final String optionalData;

  DashboardSlidingUpState({
    required this.type,
    this.panelHeight = 0,
    this.optionalData = '',
  });

  DashboardSlidingUpState copyWith({
    DashboardSlidingUpType? type,
    double? panelHeight,
    String? optionalData,
  }) {
    return DashboardSlidingUpState(
      type: type ?? this.type,
      panelHeight: panelHeight ?? this.panelHeight,
      optionalData: optionalData ?? this.optionalData,
    );
  }
}
