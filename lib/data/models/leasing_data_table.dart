class LeasingData {
  LeasingData(
    this.type,
    this.spk,
    this.open,
    this.accept,
    this.reject,
    this.approve,
  );

  final String type;
  final int spk;
  final int open;
  final int accept;
  final int reject;
  final double approve;

  // Add a copyWith method for easier immutable updates
  LeasingData copyWith({
    String? type,
    int? spk,
    int? open,
    int? accept,
    int? reject,
    double? approve,
  }) {
    return LeasingData(
      type ?? this.type,
      spk ?? this.spk,
      open ?? this.open,
      accept ?? this.accept,
      reject ?? this.reject,
      approve ?? this.approve,
    );
  }
}
