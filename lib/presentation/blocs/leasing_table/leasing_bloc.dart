import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/leasing_data_table.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_event.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_state.dart';

class LeasingBloc<BaseEvent, BaseState>
    extends Bloc<LeasingEvent, LeasingState> {
  LeasingBloc()
    : super(
        LeasingInitial([
          LeasingData('BAF', 0, 0, 0, 0, 0),
          LeasingData('Adira', 0, 0, 0, 0, 0),
          LeasingData('SOF', 0, 0, 0, 0, 0),
          LeasingData('IMFI', 0, 0, 0, 0, 0),
          LeasingData('MAF', 0, 0, 0, 0, 0),
          LeasingData('Others', 0, 0, 0, 0, 0),
        ]),
      ) {
    on<ResetLeasingData>(resetData);
    on<LeasingDataAdded>(addData);
    on<LeasingDataModified>(modifyData);
  }

  void resetData(ResetLeasingData event, Emitter<LeasingState> emit) {
    emit(
      LeasingInitial([
        LeasingData('BAF', 0, 0, 0, 0, 0),
        LeasingData('Adira', 0, 0, 0, 0, 0),
        LeasingData('SOF', 0, 0, 0, 0, 0),
        LeasingData('IMFI', 0, 0, 0, 0, 0),
        LeasingData('MAF', 0, 0, 0, 0, 0),
        LeasingData('Others', 0, 0, 0, 0, 0),
      ]),
    );
  }

  Future<void> addData(
    LeasingDataAdded event,
    Emitter<LeasingState> emit,
  ) async {
    // emit(LeasingLoading(state.data));
    log('Current data length: ${state.data.length}');

    // Create a NEW list based on the current state's data
    final List<LeasingData> newList = List<LeasingData>.from(state.data);
    // Add the new item to this new list
    newList.add(LeasingData('', 0, 0, 0, 0, 0));

    emit(AddLeasingData(newList));
    log('Updated data length: ${newList.length}');
  }

  Future<void> modifyData(
    LeasingDataModified event,
    Emitter<LeasingState> emit,
  ) async {
    log('Current data length: ${state.data.length}');

    // Create a NEW list based on the current state's data
    final List<LeasingData> newList = List<LeasingData>.from(state.data);

    LeasingData entryToUpdate = newList[event.rowIndex];

    int currentAccept = entryToUpdate.accept;
    int currentReject = entryToUpdate.reject;
    int currentSpk = entryToUpdate.spk;
    int currentOpen = entryToUpdate.open;

    log(
      'Current values: Accept: $currentAccept, Reject: $currentReject, SPK: $currentSpk, Opened: $currentOpen',
    );

    if (event.newValue != null) {
      if (event.columnName == 'Accepted') {
        currentAccept = event.newValue;
      } else if (event.columnName == 'Rejected') {
        currentReject = event.newValue;
      } else if (event.columnName == 'SPK') {
        currentSpk = event.newValue;
      } else if (event.columnName == 'Opened') {
        currentOpen = event.newValue;
      }
    }

    double newApprovalRate = 0.0;
    if ((currentAccept + currentReject) > 0) {
      newApprovalRate = currentAccept / (currentAccept + currentReject);
    }

    // Create new LeasingData with updated values
    newList[event.rowIndex] = entryToUpdate.copyWith(
      accept: currentAccept,
      reject: currentReject,
      approve: newApprovalRate,
      spk: currentSpk,
      open: currentOpen,
    );

    log(
      'Row ${event.rowIndex} updated: SPK: $currentSpk, Opened: $currentOpen, Accept: $currentAccept, Reject: $currentReject, Approval: $newApprovalRate',
    );
    emit(AddLeasingData(newList));
    log('Updated data length: ${newList.length}');
  }
}
