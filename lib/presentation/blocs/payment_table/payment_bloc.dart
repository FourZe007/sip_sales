import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/payment_data_table.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_event.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc()
    : super(
        PaymentInitial([
          const PaymentData('Cash', 0, 0, '0.0'),
          const PaymentData('Credit', 0, 0, '0.0'),
        ]),
      ) {
    on<ResetPaymentData>(resetData);
    on<PaymentDataModified>(onPaymentDataModify);
  }

  Future<void> resetData(
    ResetPaymentData event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      PaymentInitial([
        const PaymentData('Cash', 0, 0, '0.0'),
        const PaymentData('Credit', 0, 0, '0.0'),
      ]),
    );
  }

  Future<void> onPaymentDataModify(
    PaymentDataModified event,
    Emitter<PaymentState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<PaymentData> newList = List<PaymentData>.from(state.data);

    PaymentData entryToUpdate = newList[event.rowIndex];

    int currentResult = entryToUpdate.result;
    int currentTarget = entryToUpdate.lm;

    if (event.newResultValue != null) {
      currentResult = event.newResultValue!;
    }
    if (event.newTargetValue != null) {
      currentTarget = event.newTargetValue!;
    }

    String newGrowthRate = '0.0';
    log('Current Target: $currentTarget, Current Result: $currentResult');
    if (currentTarget > 0 && currentResult > 0) {
      newGrowthRate = (currentResult / currentTarget * 100).toStringAsFixed(1);
    }

    // Create new LeasingData with updated values
    newList[event.rowIndex] = entryToUpdate.copyWith(
      result: currentResult,
      lm: currentTarget,
      growth: newGrowthRate,
    );

    log(
      'Row ${event.rowIndex} updated: Result: $currentResult, LM: $currentTarget, Growth: $newGrowthRate',
    );
    emit(PaymentModified(newList));
    log('Updated data length: ${newList.length}');
  }
}
