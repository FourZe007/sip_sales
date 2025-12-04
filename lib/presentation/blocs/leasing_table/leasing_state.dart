import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/leasing_data_table.dart';

class LeasingState with EquatableMixin {
  final List<LeasingData> data;

  LeasingState(this.data);

  @override
  List<Object?> get props => [data];
}

class LeasingLoading extends LeasingState {
  LeasingLoading(super.data);
}

class LeasingInitial extends LeasingState {
  LeasingInitial(super.data);
}

class AddLeasingData extends LeasingState {
  final List<LeasingData> newData;

  AddLeasingData(this.newData) : super(newData);
}
