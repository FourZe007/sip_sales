import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';

class PaymentState with EquatableMixin {
  final List<HeadPaymentMasterModel> data;

  PaymentState(this.data);

  @override
  List<Object?> get props => [data];
}

class PaymentInitial extends PaymentState {
  PaymentInitial(super.data);
}

class PaymentModified extends PaymentState {
  final List<HeadPaymentMasterModel> newData;

  PaymentModified(this.newData) : super(newData);
}
