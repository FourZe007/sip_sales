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
    } catch (e) {
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
