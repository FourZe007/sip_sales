import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';

class PaymentTableState with EquatableMixin {
  final List<HeadPaymentMasterModel> data;

  PaymentTableState(this.data);

  @override
  List<Object?> get props => [data];
}

class PaymentInitial extends PaymentTableState {
  PaymentInitial(super.data);
}

class PaymentModified extends PaymentTableState {
  final List<HeadPaymentMasterModel> newData;

  PaymentModified(this.newData) : super(newData);
}
