import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';

class LeasingTableState with EquatableMixin {
  final List<HeadLeasingMasterModel> data;

  LeasingTableState(this.data);

  @override
  List<Object?> get props => [data];
}

class LeasingLoading extends LeasingTableState {
  LeasingLoading(super.data);
}

class LeasingInitial extends LeasingTableState {
  LeasingInitial(super.data);
}

class AddLeasingData extends LeasingTableState {
  final List<HeadLeasingMasterModel> newData;

  AddLeasingData(this.newData) : super(newData);
}
