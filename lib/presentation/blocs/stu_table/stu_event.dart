abstract class StuEvent {}

class ResetStuData extends StuEvent {
  ResetStuData();
}

class ModifyStuData extends StuEvent {
  final int rowIndex;
  final int? newResultValue;
  final int? newTargetValue;
  final int? newLmValue;

  ModifyStuData({
    required this.rowIndex,
    this.newResultValue,
    this.newTargetValue,
    this.newLmValue,
  });
}

class ModifyStuResultData extends StuEvent {
  final int rowIndex;
  final int? newResultValue;

  ModifyStuResultData({
    required this.rowIndex,
    this.newResultValue,
  });
}

class ModifyStuTargetData extends StuEvent {
  final int rowIndex;
  final int? newTargetValue;

  ModifyStuTargetData({
    required this.rowIndex,
    this.newTargetValue,
  });
}

class ModifyStuLmData extends StuEvent {
  final int rowIndex;
  final int? newLmValue;

  ModifyStuLmData({
    required this.rowIndex,
    this.newLmValue,
  });
}
