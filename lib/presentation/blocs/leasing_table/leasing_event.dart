abstract class LeasingEvent {}

class ResetLeasingData extends LeasingEvent {
  ResetLeasingData();
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
