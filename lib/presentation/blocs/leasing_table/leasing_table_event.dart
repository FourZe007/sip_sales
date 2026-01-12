import 'package:sip_sales_clean/data/models/head_store.dart';

abstract class LeasingEvent {}

class ResetLeasingData extends LeasingEvent {
  final List<HeadLeasingMasterModel> leasingList;

  ResetLeasingData(this.leasingList);
}

class LeasingDataAdded extends LeasingEvent {
  LeasingDataAdded();
}

class LeasingDataModified extends LeasingEvent {
  final int rowIndex;
  final String columnName;
  final int newValue;

  LeasingDataModified({
    required this.rowIndex,
    required this.columnName,
    required this.newValue,
  });
}
