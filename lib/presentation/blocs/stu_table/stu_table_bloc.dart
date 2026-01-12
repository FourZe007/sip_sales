import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_state.dart';

// Change all model from StuData to HeadStuCategoriesMasterModel
class StuTableBloc<BaseEvent, BaseState>
    extends Bloc<StuTableEvent, StuTableState> {
  StuTableBloc() : super(StuInitial([])) {
    on<ResetStuData>(resetData);
    // on<ResetStuData>((event, emit) {
    //   emit(
    //     StuInitial([
    //       StuData('MAXI', 0, 0, '0.0', 0, '0.0'),
    //       StuData('AT CLASSY', 0, 0, '0.0', 0, '0.0'),
    //       StuData('AT LPM', 0, 0, '0.0', 0, '0.0'),
    //       StuData('Others', 0, 0, '0.0', 0, '0.0'),
    //     ]),
    //   );
    // });
    on<ModifyStuData>(modifyData);
    on<ModifyStuResultData>(modifyResultData);
    on<ModifyStuTargetData>(modifyTargetData);
    on<ModifyStuLmData>(modifyLmData);
  }

  Future<void> resetData(
    ResetStuData event,
    Emitter<StuTableState> emit,
  ) async {
    log('Stu list length: ${event.stuList.length}');
    emit(
      StuInitial(
        event.stuList.where((e) => e.category != 'STU TOTAL').toList(),
      ),
    );
  }

  Future<void> modifyData(
    ModifyStuData event,
    Emitter<StuTableState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<HeadStuCategoriesMasterModel> newList =
        List<HeadStuCategoriesMasterModel>.from(state.data);

    HeadStuCategoriesMasterModel entryToUpdate = newList[event.rowIndex];

    int currentTm = entryToUpdate.tm ?? 0;
    int currentTarget = entryToUpdate.target ?? 0;
    int currentLm = entryToUpdate.lm ?? 0;

    if (event.newTmValue != null) {
      currentTm = event.newTmValue!;
    }
    if (event.newTargetValue != null) {
      currentTarget = event.newTargetValue!;
    }
    if (event.newLmValue != null) {
      currentLm = event.newLmValue!;
    }

    log(
      'Current TM: $currentTm, Current Target: $currentTarget, Current LM: $currentLm',
    );

    String newAchievementRate = '0.0';
    if (currentTm > 0 && currentTarget > 0) {
      log('Calculating Achievement Rate');
      newAchievementRate = (currentTm / currentTarget * 100).toStringAsFixed(1);
      log('New Achievement Rate: $newAchievementRate%');
    }

    String newGrowthRate = '0.0';
    if (currentTm > 0 && currentLm > 0) {
      log('Calculating Growth Rate');
      newGrowthRate = (currentTm / currentLm * 100).toStringAsFixed(1);
      log('New Growth Rate: $newGrowthRate%');
    }

    newList[event.rowIndex] = HeadStuCategoriesMasterModel(
      line: event.rowIndex + 1,
      category: entryToUpdate.category,
      target: currentTarget,
      tm: currentTm,
      acv: double.parse(newAchievementRate),
      lm: currentLm,
      growth: double.parse(newGrowthRate),
    );

    emit(StuDataModified(newList));
  }

  Future<void> modifyResultData(
    ModifyStuResultData event,
    Emitter<StuTableState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<HeadStuCategoriesMasterModel> newList =
        List<HeadStuCategoriesMasterModel>.from(state.data);

    HeadStuCategoriesMasterModel entryToUpdate = newList[event.rowIndex];

    int currentTm = entryToUpdate.tm ?? 0;
    int currentTarget = entryToUpdate.target ?? 0;
    int currentLm = entryToUpdate.lm ?? 0;

    if (event.newResultValue != null) {
      currentTarget = event.newResultValue!;
    }

    String newAchievementRate = '0.0';
    log('Current Result: $currentTm, Current Target: $currentTarget');
    if (currentTm > 0 && currentTarget > 0) {
      newAchievementRate = (currentTm / currentTarget * 100).toStringAsFixed(1);
    }

    String newGrowthRate = '0.0';
    log('Current Result: $currentTm, Current LM: $currentLm');
    if (currentTm > 0 && currentLm > 0) {
      newGrowthRate = (currentTm / currentLm * 100).toStringAsFixed(1);
    }

    newList[event.rowIndex] = HeadStuCategoriesMasterModel(
      line: event.rowIndex + 1,
      category: entryToUpdate.category,
      target: currentTarget,
      tm: currentTm,
      acv: double.parse(newAchievementRate),
      lm: currentLm,
      growth: double.parse(newGrowthRate),
    );

    emit(StuDataModified(newList));
  }

  Future<void> modifyTargetData(
    ModifyStuTargetData event,
    Emitter<StuTableState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<HeadStuCategoriesMasterModel> newList =
        List<HeadStuCategoriesMasterModel>.from(state.data);

    HeadStuCategoriesMasterModel entryToUpdate = newList[event.rowIndex];

    int currentTm = entryToUpdate.tm ?? 0;
    int currentTarget = entryToUpdate.target ?? 0;

    if (event.newTargetValue != null) {
      currentTarget = event.newTargetValue!;
    }

    String newAchievementRate = '0.0';
    log('Current Result: $currentTm, Current Target: $currentTarget');
    if (currentTm > 0 && currentTarget > 0) {
      newAchievementRate = (currentTm / currentTarget * 100).toStringAsFixed(1);
    }

    newList[event.rowIndex] = HeadStuCategoriesMasterModel(
      line: event.rowIndex + 1,
      category: entryToUpdate.category,
      target: currentTarget,
      tm: currentTm,
      acv: double.parse(newAchievementRate),
      lm: entryToUpdate.lm,
      growth: entryToUpdate.growth,
    );

    emit(StuDataModified(newList));
  }

  Future<void> modifyLmData(
    ModifyStuLmData event,
    Emitter<StuTableState> emit,
  ) async {
    // Create a NEW list based on the current state's data
    final List<HeadStuCategoriesMasterModel> newList =
        List<HeadStuCategoriesMasterModel>.from(state.data);

    HeadStuCategoriesMasterModel entryToUpdate = newList[event.rowIndex];

    int currentTm = entryToUpdate.tm ?? 0;
    int currentLm = entryToUpdate.lm ?? 0;

    if (event.newLmValue != null) {
      currentLm = event.newLmValue!;
    }

    String newGrowthRate = '0.0';
    log('Current Result: $currentTm, Current LM: $currentLm');
    if (currentTm > 0 && currentLm > 0) {
      newGrowthRate = (currentTm / currentLm * 100).toStringAsFixed(1);
    }

    newList[event.rowIndex] = HeadStuCategoriesMasterModel(
      line: event.rowIndex + 1,
      category: entryToUpdate.category,
      target: currentTm,
      tm: currentTm,
      acv: entryToUpdate.acv,
      lm: entryToUpdate.lm,
      growth: double.parse(newGrowthRate),
    );

    emit(StuDataModified(newList));
  }
}
