class StuData {
  StuData(this.type, this.result, this.target, this.ach, this.lm, this.growth);

  String type;
  int result;
  int target;
  String ach;
  int lm;
  String growth;

  // Add a copyWith method for easier immutable updates
  StuData copyWith({
    String? type,
    int? result,
    int? target,
    String? ach,
    int? lm,
    String? growth,
  }) {
    return StuData(
      type ?? this.type,
      result ?? this.result,
      target ?? this.target,
      ach ?? this.ach,
      lm ?? this.lm,
      growth ?? this.growth,
    );
  }
}
