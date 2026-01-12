import 'package:sip_sales_clean/data/models/head_store.dart';

abstract class PaymentTableEvent {}

class ResetPaymentData extends PaymentTableEvent {
  final List<HeadPaymentMasterModel> paymentList;

  ResetPaymentData(this.paymentList);
}

class PaymentDataAdded extends PaymentTableEvent {
  PaymentDataAdded();
}

class PaymentDataModified extends PaymentTableEvent {
  final int rowIndex;
  final int? newResultValue;
  final int? newTargetValue;

  PaymentDataModified({
    required this.rowIndex,
    this.newResultValue,
    this.newTargetValue,
  });
}
