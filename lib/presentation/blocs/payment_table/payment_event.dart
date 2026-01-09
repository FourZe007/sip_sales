import 'package:sip_sales_clean/data/models/head_store.dart';

abstract class PaymentEvent {}

class ResetPaymentData extends PaymentEvent {
  final List<HeadPaymentMasterModel> paymentList;

  ResetPaymentData(this.paymentList);
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
