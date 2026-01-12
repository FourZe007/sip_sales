import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_state.dart';

class PaymentTableBloc extends Bloc<PaymentTableEvent, PaymentTableState> {
  PaymentTableBloc() : super(PaymentInitial([])) {
    on<ResetPaymentData>(resetData);
    on<PaymentDataModified>(onPaymentDataModify);
  }

  Future<void> resetData(
    ResetPaymentData event,
    Emitter<PaymentTableState> emit,
  ) async {
    emit(PaymentInitial(event.paymentList));
  }

  Future<void> onPaymentDataModify(
    PaymentDataModified event,
    Emitter<PaymentTableState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<HeadPaymentMasterModel> newList =
        List<HeadPaymentMasterModel>.from(state.data);

    HeadPaymentMasterModel entryToUpdate = newList[event.rowIndex];

    int currentTm = entryToUpdate.tm ?? 0;
    int currentLm = entryToUpdate.lm ?? 0;

    if (event.newResultValue != null) {
      currentTm = event.newResultValue!;
    }
    if (event.newTargetValue != null) {
      currentLm = event.newTargetValue!;
    }

    String newGrowthRate = '0.0';
    log('Current Target: $currentLm, Current Result: $currentTm');
    if (currentLm > 0 && currentTm > 0) {
      newGrowthRate = (currentTm / currentLm * 100).toStringAsFixed(1);
    }

    // Create new LeasingData with updated values
    newList[event.rowIndex] = entryToUpdate.copyWith(
      tm: currentTm,
      lm: currentLm,
      growth: double.parse(newGrowthRate),
    );

    log(
      'Row ${event.rowIndex} updated: Result: $currentTm, LM: $currentLm, Growth: $newGrowthRate',
    );
    emit(PaymentModified(newList));
    log('Updated data length: ${newList.length}');
  }
}
