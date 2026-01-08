// Apperently, not used!
class SalesmanData {
  final int line;
  final String employeeId;
  final String employeeName;
  final String typeId;
  final String position;
  final int spk;
  final int stu;
  final int stuLm;

  SalesmanData(
    this.line,
    this.employeeId,
    this.employeeName,
    this.typeId,
    this.position,
    this.spk,
    this.stu,
    this.stuLm,
  );

  // Add a copyWith method for easier immutable updates
  SalesmanData copyWith({
    int? line,
    String? employeeId,
    String? employeeName,
    String? typeId,
    String? position,
    int? spk,
    int? stu,
    int? stuLm,
  }) {
    return SalesmanData(
      line ?? this.line,
      employeeId ?? this.employeeId,
      employeeName ?? this.employeeName,
      typeId ?? this.typeId,
      position ?? this.position,
      spk ?? this.spk,
      stu ?? this.stu,
      stuLm ?? this.stuLm,
    );
  }
}
