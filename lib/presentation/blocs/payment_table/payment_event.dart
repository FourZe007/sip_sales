abstract class PaymentEvent {}

class ResetPaymentData extends PaymentEvent {
  ResetPaymentData();
}

class PaymentDataAdded extends PaymentEvent {
  PaymentDataAdded();
}

class PaymentDataModified extends PaymentEvent {
  final int rowIndex;
  final int? newResultValue;
  final int? newTargetValue;

  PaymentDataModified({
    required this.rowIndex,
    this.newResultValue,
    this.newTargetValue,
  });
}
