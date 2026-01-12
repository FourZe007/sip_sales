import 'package:sip_sales_clean/data/models/head_store.dart';

abstract class StuTableEvent {}

class ResetStuData extends StuTableEvent {
  final List<HeadStuCategoriesMasterModel> stuList;

  ResetStuData(this.stuList);
}

class ModifyStuData extends StuTableEvent {
  final int rowIndex;
  final int? newTmValue;
  final int? newTargetValue;
  final int? newLmValue;

  ModifyStuData({
    required this.rowIndex,
    this.newTmValue,
    this.newTargetValue,
    this.newLmValue,
  });
}

class ModifyStuResultData extends StuTableEvent {
  final int rowIndex;
  final int? newResultValue;

  ModifyStuResultData({
    required this.rowIndex,
    this.newResultValue,
  });
}

class ModifyStuTargetData extends StuTableEvent {
  final int rowIndex;
  final int? newTargetValue;

  ModifyStuTargetData({
    required this.rowIndex,
    this.newTargetValue,
  });
}

class ModifyStuLmData extends StuTableEvent {
  final int rowIndex;
  final int? newLmValue;

  ModifyStuLmData({
    required this.rowIndex,
    this.newLmValue,
  });
}
