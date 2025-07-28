import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/enum.dart';

class DashboardTypeCubit extends Cubit<DashboardType> {
  DashboardTypeCubit() : super(DashboardType.salesman);

  DashboardType get getDashboardType => state;

  void changeType(DashboardType type) => emit(type);
}
