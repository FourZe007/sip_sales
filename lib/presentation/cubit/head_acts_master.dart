import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/domain/repositories/head_store_domain.dart';

class HeadActsMasterCubit extends Cubit<HeadActsMasterState> {
  final HeadStoreRepo headStoreRepo;

  HeadActsMasterCubit(this.headStoreRepo) : super(HeadActsMasterInit());

  Future<void> fetchHeadActsMasterData(
    String branch,
    String shop,
  ) async {
    try {
      emit(HeadActsMasterLoading());

      // ~:Briefing Master:~
      final briefingRes = await headStoreRepo.fetchHeadBriefingMaster(
        branch,
        shop,
      );

      if (briefingRes['status'] == 'success' && briefingRes['code'] == '100') {
        log(
          'Briefing Master fetched; bsName: ${(briefingRes['data'] as List<HeadBriefingMasterModel>)[0].bsName}',
        );
      } else {
        log('Briefing Master failed');
      }

      // ~:Visit Master:~
      final visitRes = await headStoreRepo.fetchHeadVisitMaster(
        branch,
        shop,
      );

      if (visitRes['status'] == 'success' && visitRes['code'] == '100') {
        log(
          'Visit Master fetched; length: ${(visitRes['data'] as List).length}',
        );
      } else {
        log('Visit Master failed');
      }

      // ~:Recruitment Master:~
      final recruitmentRes = await headStoreRepo.fetchHeadRecruitmentMaster(
        branch,
        shop,
      );

      if (recruitmentRes['status'] == 'success' &&
          recruitmentRes['code'] == '100') {
        log(
          'Recruitment Master fetched; length: ${(recruitmentRes['data'] as List).length}',
        );
      } else {
        log('Recruitment Master failed');
      }

      // ~:Interview Master:~
      final interviewRes = await headStoreRepo.fetchHeadInterviewMaster(
        branch,
        shop,
      );

      if (interviewRes['status'] == 'success' &&
          interviewRes['code'] == '100') {
        log(
          'Interview Master fetched; length: ${(interviewRes['data'] as List).length}',
        );
      } else {
        log('Interview Master failed');
      }

      // ~:Report Master:~
      final reportRes = await headStoreRepo.fetchHeadReportMaster(
        branch,
        shop,
      );

      if (reportRes['status'] == 'success' && reportRes['code'] == '100') {
        log(
          'Report Master fetched; length: ${(reportRes['data'] as List).length}',
        );
      } else {
        log('Report Master failed');
      }

      // ~:Handle final state:~
      emit(
        HeadActsMasterLoaded(
          briefingRes['data'],
          visitRes['data'],
          recruitmentRes['data'],
          interviewRes['data'],
          reportRes['data'],
        ),
      );
    } catch (e) {
      log('Something went wrong, ${e.toString()}');
      emit(HeadActsMasterFailed(e.toString()));
    }
  }
}

class HeadActsMasterState {}

class HeadActsMasterInit extends HeadActsMasterState {}

class HeadActsMasterLoading extends HeadActsMasterState {}

class HeadActsMasterLoaded extends HeadActsMasterState {
  final List<HeadBriefingMasterModel> briefingMaster;
  final List<HeadVisitMasterModel> visitMaster;
  final List<HeadRecruitmentMasterModel> recruitmentMaster;
  final List<HeadInterviewMasterModel> interviewMaster;
  final List<HeadReportMasterModel> reportMaster;

  HeadActsMasterLoaded(
    this.briefingMaster,
    this.visitMaster,
    this.recruitmentMaster,
    this.interviewMaster,
    this.reportMaster,
  );
}

class HeadActsMasterFailed extends HeadActsMasterState {
  final String message;

  HeadActsMasterFailed(this.message);
}
