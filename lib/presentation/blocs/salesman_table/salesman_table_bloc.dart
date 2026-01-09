import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/domain/repositories/sales.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_state.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
import 'package:sip_sales_clean/presentation/functions.dart';

class SalesmanTableBloc<BaseEvent, BaseState>
    extends Bloc<SalesmanTableEvent, SalesmanTableState> {
  final SalesRepo salesRepo;

  SalesmanTableBloc({required this.salesRepo})
    : super(SalesmanInitial([], [], [])) {
    on<ResetSalesman>(resetSalesman);
    on<FetchSalesman>(fetchSalesmanHandler);
    on<AddSalesman>(addSalesmanHandler);
    on<AddSalesmanList>(addSalesmanListHandler);
    on<ModifySalesman>(modifySalesmanHandler);
    on<ModifySalesmanStatus>(modifySalesmanStatusHandler);
    // on<RemoveSalesman>(removeSalesmanHandler);
  }

  Future<void> resetSalesman(
    ResetSalesman event,
    Emitter<SalesmanTableState> emit,
  ) async {}

  /// Dynamically creates a list of SalesmanData using state.fetchSalesList,
  /// extracting only the name and tier, and setting other parameters to 0.
  // List<SalesmanData> buildSalesmanDataListFromFetchSalesList() {
  //   return state.fetchSalesList.map((sales) {
  //     return SalesmanData(
  //       0,
  //       sales.userId,
  //       sales.userName,
  //       sales.tierLevel,
  //       sales.tierLevel,
  //       0,
  //       0,
  //       0,
  //     );
  //   }).toList();
  // }

  Future<void> fetchSalesmanHandler(
    FetchSalesman event,
    Emitter<SalesmanTableState> emit,
  ) async {
    emit(SalesmanLoading(state));
    try {
      final isSalesmanEmpty = await event.context
          .read<HeadActsMasterCubit>()
          .getHeadActsMasterData();

      if (!isSalesmanEmpty) {
        final fetchedList =
            (isSalesmanEmpty as HeadActsMasterLoaded).reportMaster;

        // Map from the API model to our new UI model
        final List<HeadEmployeeMasterModel> uiList = fetchedList[0].employee;

        emit(SalesmanFetched(state, fetchedList, uiList));
      } else {
        emit(SalesmanError('No data received'));
      }
    } catch (e) {
      emit(SalesmanError(e.toString()));
    }
  }

  Future<void> addSalesmanHandler(
    AddSalesman event,
    Emitter<SalesmanTableState> emit,
  ) async {
    emit(SalesmanLoading(state));
    try {
      // ~:Secure Storage Simulation:~
      final String userId = await Functions.readAndWriteEmployeeId();

      if (userId != '') {
        // ~:Network Call Simulation:~
        Map<String, dynamic> result = await salesRepo.addOrModifySalesman(
          userId,
          event.id,
          event.name,
          event.tier,
          event.status,
        );

        if (result['status'] == 'success') {
          // ~:Emit success state with user data:~
          emit(SalesmanAdded());
        } else {
          if ((result['data'] as String).contains('duplicate key')) {
            emit(SalesmanError('Duplicate ID found'));
          } else {
            emit(SalesmanError(result['data'] as String));
          }
        }
      } else {
        emit(SalesmanError('User credentials not found'));
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      emit(SalesmanError(e.toString()));
    }
  }

  Future<void> addSalesmanListHandler(
    AddSalesmanList event,
    Emitter<SalesmanTableState> emit,
  ) async {
    emit(SalesmanLoading(state));
    try {
      final String userId = await Functions.readAndWriteEmployeeId();

      if (userId != '') {
        List<Map<String, dynamic>> results = [];
        bool hasError = false;
        String? errorMessage;

        // Process each salesman in the list
        for (var salesman in event.salesDraftList) {
          try {
            Map<String, dynamic> result = await salesRepo.addOrModifySalesman(
              userId,
              Formatter.removeSpaces(salesman.id),
              Formatter.removeSpaces(salesman.name),
              Formatter.removeSpaces(salesman.tier),
              salesman.isActive,
            );

            results.add({
              'success': result['status'] == 'success',
              'message': result['data'] as String,
            });

            // If any insert fails, mark as error but continue processing others
            if (result['status'] != 'success') {
              hasError = true;
              errorMessage = result['data'] as String;
            }
          } catch (e) {
            hasError = true;
            errorMessage = e.toString();
            results.add({'success': false, 'message': e.toString()});
          }
        }

        // After processing all items
        if (hasError) {
          // If any insert failed, show error but include successful ones
          emit(
            SalesmanPartialSuccess(
              results,
              errorMessage: errorMessage ?? 'Some salesmen could not be added',
            ),
          );
        } else {
          // All inserts were successful
          emit(SalesmanAdded(results: results));
        }
      } else {
        emit(SalesmanError('User credentials not found'));
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      emit(SalesmanError('Failed to process salesman list: ${e.toString()}'));
    }
  }

  Future<void> modifySalesmanHandler(
    ModifySalesman event,
    Emitter<SalesmanTableState> emit,
  ) async {
    try {
      // Only proceed if we have data to modify
      if (state is! SalesmanFetched && state is! SalesmanModified) return;

      // 1. Create a NEW list from the current state's list.
      final List<HeadEmployeeMasterModel> newList =
          List<HeadEmployeeMasterModel>.from(
            state.salesDataList,
          );

      // 2. Check for a valid index.
      if (event.rowIndex < 0 || event.rowIndex >= newList.length) return;

      // 3. Get a reference to the specific object to be updated.
      HeadEmployeeMasterModel entryToUpdate = newList[event.rowIndex];

      // 4. Use `copyWith` and a switch on the column name to create a new instance.
      switch (event.columnName) {
        case 'SPK':
          entryToUpdate = entryToUpdate.copyWith(spk: event.newValue);
          break;
        case 'STU':
          entryToUpdate = entryToUpdate.copyWith(stu: event.newValue);
          break;
        case 'STU LM':
          entryToUpdate = entryToUpdate.copyWith(stuLm: event.newValue);
          break;
      }

      // 5. Replace the old object with the new one in our new list.
      newList[event.rowIndex] = entryToUpdate;

      // 6. Emit a new state containing the new list.
      emit(SalesmanModified(state, newList));
    } catch (e) {
      log('Error: ${e.toString()}');
      emit(SalesmanError('Failed to modify sales data: ${e.toString()}'));
    }
  }

  Future<void> modifySalesmanStatusHandler(
    ModifySalesmanStatus event,
    Emitter<SalesmanTableState> emit,
  ) async {
    try {
      // ~:Secure Storage Simulation:~
      final String userId = await Functions.readAndWriteEmployeeId();

      if (userId != '') {
        // ~:Network Call Simulation:~
        Map<String, dynamic> result = await salesRepo.addOrModifySalesman(
          userId,
          Formatter.removeSpaces(event.sales.id),
          Formatter.removeSpaces(event.sales.name),
          Formatter.removeSpaces(event.sales.tier),
          event.sales.isActive,
          isModify: true,
        );

        if (result['status'] == 'success') {
          // ~:Emit success state with user data:~
          emit(SalesmanStatusModified('Data successfully updated'));
        } else {
          emit(SalesmanStatusModifyError(result['data'] as String));
        }
      } else {
        emit(SalesmanStatusModifyError('User credentials not found'));
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      emit(
        SalesmanStatusModifyError(
          'Failed to modify salesman status: ${e.toString()}',
        ),
      );
    }
  }
}
