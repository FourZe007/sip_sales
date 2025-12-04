import 'package:equatable/equatable.dart';

class PaymentData extends Equatable {
  const PaymentData(this.type, this.result, this.lm, this.growth);

  final String type;
  final int result;
  final int lm;
  final String growth;

  // Add a copyWith method for easier immutable updates
  PaymentData copyWith({String? type, int? result, int? lm, String? growth}) {
    return PaymentData(
      type ?? this.type,
      result ?? this.result,
      lm ?? this.lm,
      growth ?? this.growth,
    );
  }

  @override
  List<Object?> get props => [type, result, lm, growth];
}
