import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/stu_data_table.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_event.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_state.dart';

class StuBloc<BaseEvent, BaseState> extends Bloc<StuEvent, StuState> {
  StuBloc() : super(StuInitial([])) {
    on<ResetStuData>((event, emit) {
      emit(
        StuInitial([
          StuData('MAXI', 0, 0, '0.0', 0, '0.0'),
          StuData('AT CLASSY', 0, 0, '0.0', 0, '0.0'),
          StuData('AT LPM', 0, 0, '0.0', 0, '0.0'),
          StuData('Others', 0, 0, '0.0', 0, '0.0'),
        ]),
      );
    });
    on<ModifyStuData>(modifyData);
    on<ModifyStuResultData>(modifyResultData);
    on<ModifyStuTargetData>(modifyTargetData);
    on<ModifyStuLmData>(modifyLmData);
  }

  Future<void> modifyData(
    ModifyStuData event,
    Emitter<StuState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<StuData> newList = List<StuData>.from(state.data);

    StuData entryToUpdate = newList[event.rowIndex];

    int currentResult = entryToUpdate.result;
    int currentTarget = entryToUpdate.target;
    int currentLm = entryToUpdate.lm;

    if (event.newResultValue != null) {
      currentResult = event.newResultValue!;
    }
    if (event.newTargetValue != null) {
      currentTarget = event.newTargetValue!;
    }
    if (event.newLmValue != null) {
      currentLm = event.newLmValue!;
    }

    log(
      'Current Result: $currentResult, Current Target: $currentTarget, Current LM: $currentLm',
    );

    String newAchievementRate = '0.0';
    if (currentResult > 0 && currentTarget > 0) {
      log('Calculating Achievement Rate');
      newAchievementRate = (currentResult / currentTarget * 100)
          .toStringAsFixed(1);
      log('New Achievement Rate: $newAchievementRate%');
    }

    String newGrowthRate = '0.0';
    if (currentResult > 0 && currentLm > 0) {
      log('Calculating Growth Rate');
      newGrowthRate = (currentResult / currentLm * 100).toStringAsFixed(1);
      log('New Growth Rate: $newGrowthRate%');
    }

    newList[event.rowIndex] = StuData(
      entryToUpdate.type,
      currentResult,
      currentTarget,
      newAchievementRate,
      currentLm,
      newGrowthRate,
    );

    emit(StuDataModified(newList));
  }

  Future<void> modifyResultData(
    ModifyStuResultData event,
    Emitter<StuState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<StuData> newList = List<StuData>.from(state.data);

    StuData entryToUpdate = newList[event.rowIndex];

    int currentResult = entryToUpdate.result;
    int currentTarget = entryToUpdate.target;
    int currentLm = entryToUpdate.lm;

    if (event.newResultValue != null) {
      currentTarget = event.newResultValue!;
    }

    String newAchievementRate = '0.0';
    log('Current Result: $currentResult, Current Target: $currentTarget');
    if (currentResult > 0 && currentTarget > 0) {
      newAchievementRate = (currentResult / currentTarget * 100)
          .toStringAsFixed(1);
    }

    String newGrowthRate = '0.0';
    log('Current Result: $currentResult, Current LM: $currentLm');
    if (currentResult > 0 && currentLm > 0) {
      newGrowthRate = (currentResult / currentLm * 100).toStringAsFixed(1);
    }

    newList[event.rowIndex] = StuData(
      entryToUpdate.type,
      currentResult,
      currentTarget,
      newAchievementRate,
      currentLm,
      newGrowthRate,
    );

    emit(StuDataModified(newList));
  }

  Future<void> modifyTargetData(
    ModifyStuTargetData event,
    Emitter<StuState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<StuData> newList = List<StuData>.from(state.data);

    StuData entryToUpdate = newList[event.rowIndex];

    int currentResult = entryToUpdate.result;
    int currentTarget = entryToUpdate.target;

    if (event.newTargetValue != null) {
      currentTarget = event.newTargetValue!;
    }

    String newAchievementRate = '0.0';
    log('Current Result: $currentResult, Current Target: $currentTarget');
    if (currentResult > 0 && currentTarget > 0) {
      newAchievementRate = (currentResult / currentTarget * 100)
          .toStringAsFixed(1);
    }

    newList[event.rowIndex] = StuData(
      entryToUpdate.type,
      currentResult,
      currentTarget,
      newAchievementRate,
      entryToUpdate.lm,
      entryToUpdate.growth,
    );

    emit(StuDataModified(newList));
  }

  Future<void> modifyLmData(
    ModifyStuLmData event,
    Emitter<StuState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<StuData> newList = List<StuData>.from(state.data);

    StuData entryToUpdate = newList[event.rowIndex];

    int currentResult = entryToUpdate.result;
    int currentLm = entryToUpdate.lm;

    if (event.newLmValue != null) {
      currentLm = event.newLmValue!;
    }

    String newGrowthRate = '0.0';
    log('Current Result: $currentResult, Current LM: $currentLm');
    if (currentResult > 0 && currentLm > 0) {
      newGrowthRate = (currentResult / currentLm * 100).toStringAsFixed(1);
    }

    newList[event.rowIndex] = StuData(
      entryToUpdate.type,
      currentResult,
      entryToUpdate.target,
      entryToUpdate.ach,
      currentLm,
      newGrowthRate,
    );

    emit(StuDataModified(newList));
  }
}
