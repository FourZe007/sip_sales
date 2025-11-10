import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/data/repositories/spk_leasing_filter_data.dart';

// Manages the data is being loaded for the SPK Leasing Filter
// based on the selected filter
class SpkLeasingDataCubit extends Cubit<SpkLeasingDataState> {
  final SpkLeasingFilterDataImp spkLeasingFilterDataImp;

  SpkLeasingDataCubit({
    required this.spkLeasingFilterDataImp,
  }) : super(SpkLeasingDataState());

  // "EmployeeID":"1612/002435",
  //   "TransDate":"2025-10-31",
  //   "BranchShop":"''0318''",
  //   "Category":"",
  //   "LeasingID":"",
  //   "JenisDealer":"SIP GROUP"
  Future<void> loadData(
    /*required filters to load the data*/
    final String employeeId,
    final String transDate,
    final String branchShop,
    final String category,
    final String leasingId,
    final String jenisDealer,
  ) async {
    try {
      log('Loading SPK Leasing Data');
      emit(SpkLeasingDataLoading());

      final res = await spkLeasingFilterDataImp.loadSpkLeasingData(
        employeeId,
        transDate,
        branchShop,
        category,
        leasingId,
        jenisDealer,
      );
      log('Refresh SPK Leasing Data: $res');

      if (res['status'] == 'success' && res['code'] == '100') {
        log('SPK Leasing data loaded successfully');
        emit(SpkLeasingDataLoaded(result: res['data']));
      } else if (res['status'] == 'no data' && res['code'] == '100') {
        log('SPK Leasing data has no data');
        emit(SpkLeasingDataFailed(message: 'No Data'));
      } else {
        log('SPK Leasing data loaded failed');
        emit(SpkLeasingDataFailed(message: res['status']));
      }
    } catch (e) {
      log('Error: $e');
      emit(SpkLeasingDataFailed(message: e.toString()));
    }
  }
}

class SpkLeasingDataState {
  // final List filterDataResult;

  // SpkLeasingFilterDataState({
  //   this.filterDataResult = const [],
  // });

  // SpkLeasingFilterDataState copyWith({
  //   List? filterDataResult,
  // }) {
  //   return SpkLeasingFilterDataState(
  //     filterDataResult: filterDataResult ?? this.filterDataResult,
  //   );
  // }
}

class SpkLeasingDataLoading extends SpkLeasingDataState {}

class SpkLeasingDataLoaded extends SpkLeasingDataState {
  final SpkDataModel result;

  SpkLeasingDataLoaded({required this.result});
}

class SpkLeasingDataFailed extends SpkLeasingDataState {
  final String message;

  SpkLeasingDataFailed({required this.message});
}
