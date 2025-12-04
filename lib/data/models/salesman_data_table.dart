class SalesmanData {
  SalesmanData(this.name, this.position, this.spk, this.stu, this.stuLm);

  final String name;
  final String position;
  final int spk;
  final int stu;
  final int stuLm;

  // Add a copyWith method for easier immutable updates
  SalesmanData copyWith({
    String? name,
    String? position,
    int? spk,
    int? stu,
    int? stuLm,
  }) {
    return SalesmanData(
      name ?? this.name,
      position ?? this.position,
      spk ?? this.spk,
      stu ?? this.stu,
      stuLm ?? this.stuLm,
    );
  }
}
