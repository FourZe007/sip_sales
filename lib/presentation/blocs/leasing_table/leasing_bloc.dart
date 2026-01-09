import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_event.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_state.dart';

class LeasingBloc<BaseEvent, BaseState>
    extends Bloc<LeasingEvent, LeasingState> {
  LeasingBloc() : super(LeasingInitial([])) {
    on<ResetLeasingData>(resetData);
    on<LeasingDataAdded>(addData);
    on<LeasingDataModified>(modifyData);
  }

  void resetData(ResetLeasingData event, Emitter<LeasingState> emit) {
    emit(LeasingInitial(event.leasingList));
  }

  Future<void> addData(
    LeasingDataAdded event,
    Emitter<LeasingState> emit,
  ) async {
    // emit(LeasingLoading(state.data));
    log('Current data length: ${state.data.length}');

    // Create a NEW list based on the current state's data
    final List<HeadLeasingMasterModel> newList =
        List<HeadLeasingMasterModel>.from(state.data);
    // Add the new item to this new list
    newList.add(
      HeadLeasingMasterModel(
        line: 0,
        leasingID: '',
        total: 0,
        terbuka: 0,
        disetujui: 0,
        ditolak: 0,
        persentase: 0,
      ),
    );

    emit(AddLeasingData(newList));
    log('Updated data length: ${newList.length}');
  }

  Future<void> modifyData(
    LeasingDataModified event,
    Emitter<LeasingState> emit,
  ) async {
    log('Current data length: ${state.data.length}');

    // Create a NEW list based on the current state's data
    final List<HeadLeasingMasterModel> newList =
        List<HeadLeasingMasterModel>.from(state.data);

    HeadLeasingMasterModel entryToUpdate = newList[event.rowIndex];

    int currentAccept = entryToUpdate.disetujui ?? 0;
    int currentReject = entryToUpdate.ditolak ?? 0;
    int currentTotal = entryToUpdate.total ?? 0;
    int currentOpen = entryToUpdate.terbuka ?? 0;

    log(
      'Current values: Accept: $currentAccept, Reject: $currentReject, Total: $currentTotal, Opened: $currentOpen',
    );

    if (event.newValue != null) {
      if (event.columnName == 'Accepted') {
        currentAccept = event.newValue;
      } else if (event.columnName == 'Rejected') {
        currentReject = event.newValue;
      } else if (event.columnName == 'SPK') {
        currentTotal = event.newValue;
      } else if (event.columnName == 'Opened') {
        currentOpen = event.newValue;
      }
    }

    double newApprovalRate = 0.0;
    if ((currentAccept + currentReject) > 0) {
      newApprovalRate = (currentAccept / (currentAccept + currentReject)) * 100;
    }

    // Create new LeasingData with updated values
    newList[event.rowIndex] = entryToUpdate.copyWith(
      line: entryToUpdate.line,
      leasingID: entryToUpdate.leasingID,
      total: currentTotal,
      terbuka: currentOpen,
      disetujui: currentAccept,
      ditolak: currentReject,
      persentase: newApprovalRate,
    );

    log(
      'Row ${event.rowIndex} updated: Total: $currentTotal, Opened: $currentOpen, Accept: $currentAccept, Reject: $currentReject, Approval: $newApprovalRate',
    );
    emit(AddLeasingData(newList));
    log('Updated data length: ${newList.length}');
  }
}
