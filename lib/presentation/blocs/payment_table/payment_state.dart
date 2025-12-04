import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/payment_data_table.dart';

class PaymentState with EquatableMixin {
  final List<PaymentData> data;

  PaymentState(this.data);

  @override
  List<Object?> get props => [data];
}

class PaymentInitial extends PaymentState {
  PaymentInitial(super.data);
}

class PaymentModified extends PaymentState {
  final List<PaymentData> newData;

  PaymentModified(this.newData) : super(newData);
}
