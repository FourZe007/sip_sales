import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/validator.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/domain/repositories/followup_domain.dart';
import 'package:sip_sales_clean/domain/repositories/head_store_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/counter_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';

class HeadStoreBloc extends Bloc<HeadStoreEvent, HeadStoreState> {
  final HeadStoreRepo headStoreRepo;
  final FollowupRepo followupRepo;

  HeadStoreBloc({
    required this.headStoreRepo,
    required this.followupRepo,
  }) : super(HeadStoreInit()) {
    on<LoadHeadActs>(loadHeadActs);
    on<LoadHeadActsDetail>(loadHeadActsDetail);
    on<LoadHeadDashboard>(loadHeadDashboard);
    on<InsertMorningBriefing>(insertMorningBriefing);
    on<InsertVisitMarket>(insertVisitMarket);
    on<InsertRecruitment>(insertRecruitment);
    on<InsertInterview>(insertInterview);
    on<InsertDailyReport>(insertDailyReport);
    on<DeleteHeadActs>(deleteHeadActs);
  }

  Future<void> loadHeadActs(
    LoadHeadActs event,
    Emitter<HeadStoreState> emit,
  ) async {
    log('Load Head Acts');
    try {
      emit(HeadStoreLoading(isActs: true, isDashboard: false, isInsert: false));

      log('Fetching data using API call');
      final res = await headStoreRepo.fetchHeadActs(
        event.employeeID,
        event.date,
      );
      log('Result: ${(res['data'] as List).length}');

      if (res['status'] == 'success') {
        log('Success');
        emit(HeadStoreDataLoaded(res['data']));
      } else if (res['status'].toString().toLowerCase() == 'no data') {
        log('Empty');
        emit(HeadStoreDataFailed('Data tidak tersedia.'));
      } else {
        log('Failed');
        emit(HeadStoreDataFailed(res['msg']));
      }
    } catch (e) {
      log('Load Head Acts failed: $e');
      emit(HeadStoreDataFailed(e.toString()));
    }
  }

  Future<void> loadHeadActsDetail(
    LoadHeadActsDetail event,
    Emitter<HeadStoreState> emit,
  ) async {
    log('Load Head Acts Detail');
    try {
      emit(
        HeadStoreLoading(
          isActs: false,
          isActsDetail: true,
          isDashboard: false,
          isInsert: false,
        ),
      );

      final breifingRes = await headStoreRepo.fetchHeadBriefingDetails(
        event.employeeID,
        event.date,
        event.activityID,
      );
      log('$breifingRes');

      final visitRes = await headStoreRepo.fetchHeadVisitDetails(
        event.employeeID,
        event.date,
        event.activityID,
      );
      log('$visitRes');

      final recruitmnetRes = await headStoreRepo.fetchHeadRecruitmentDetails(
        event.employeeID,
        event.date,
        event.activityID,
      );
      log('$recruitmnetRes');

      final interviewRes = await headStoreRepo.fetchHeadInterviewDetails(
        event.employeeID,
        event.date,
        event.activityID,
      );
      log('$interviewRes');

      final reportRes = await headStoreRepo.fetchHeadReportDetails(
        event.employeeID,
        event.date,
        event.activityID,
      );
      log('$reportRes');

      if (breifingRes['status'] == 'success') {
        log('Success');
        emit(HeadStoreDataDetailLoaded(breifingRes['data']));
      } else if (breifingRes['status'].toString().toLowerCase() == 'no data') {
        log('Empty');
        emit(HeadStoreDataDetailFailed('Data tidak tersedia.'));
      } else {
        log('Failed');
        emit(HeadStoreDataDetailFailed(breifingRes['msg']));
      }
    } catch (e) {
      log('Load Head Acts Detail failed: $e');
      emit(HeadStoreDataDetailFailed(e.toString()));
    }
  }

  Future<void> loadHeadDashboard(
    LoadHeadDashboard event,
    Emitter<HeadStoreState> emit,
  ) async {
    log('Load Head Dashboard');
    try {
      emit(HeadStoreLoading(isDashboard: true));

      final res = await headStoreRepo.fetchHeadDashboard(
        event.employeeID,
        event.date,
      );
      log('$res');

      if (res['status'] == 'success') {
        log('Success');
        emit(HeadStoreDashboardLoaded(res['data']));
      } else if (res['status'].toString().toLowerCase() == 'no data') {
        log('Empty');
        emit(HeadStoreDashboardFailed('Data tidak tersedia.'));
      } else {
        log('Failed');
        emit(HeadStoreDashboardFailed(res['msg']));
      }
    } catch (e) {
      log('Load Head Dashboard failed: $e');
      emit(HeadStoreDashboardFailed(e.toString()));
    }
  }

  Future<void> insertMorningBriefing(
    InsertMorningBriefing event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(HeadStoreLoading(isInsert: true));

      final employee =
          (event.context.read<LoginBloc>().state as LoginSuccess).user;
      log('EmployeeId: ${employee.employeeID}');
      final isDescEmpty = event.desc.isEmpty;
      final img = event.context.read<ImageCubit>().state;
      final isImgInvalid = img is ImageInitial || img is ImageError;
      final headActsMaster = event.context.read<HeadActsMasterCubit>().state;
      final counter = event.context.read<CounterCubit>().getValues([
        'shop_manager',
        'sales_counter',
        'salesman',
        'others',
      ]);

      if (isDescEmpty && isImgInvalid) {
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.morningBriefing,
            'Deskripsi dan foto tidak boleh kosong',
          ),
        );
        return;
      } else if (isDescEmpty) {
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.morningBriefing,
            'Deskripsi tidak boleh kosong',
          ),
        );
        return;
      } else if (isImgInvalid) {
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.morningBriefing,
            img is ImageInitial
                ? 'Foto tidak boleh kosong'
                : (img as ImageError).message,
          ),
        );
        return;
      } else {
        final res = await headStoreRepo.insertNewBriefingActivity(
          '1',
          employee.branch,
          employee.shop,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('HH:mm').format(DateTime.now()),
          (await Geolocator.getCurrentPosition()).latitude,
          (await Geolocator.getCurrentPosition()).longitude,
          base64Encode(await (img as ImageCaptured).image.readAsBytes()),
          employee.employeeID,
          (headActsMaster is HeadActsMasterLoaded)
              ? headActsMaster.briefingMaster[0].bsName
              : employee.bsName,
          event.desc,
          counter[0],
          counter[1],
          counter[2],
          counter[3],
          counter[4],
        );
        log('$res');

        if (res['status'] == 'success' && res['code'] == '100') {
          log('Success');
          emit(HeadStoreInsertSucceed(HeadStoreActTypes.morningBriefing));
        } else if (res['status'] == 'fail' &&
            res['code'] == '200' &&
            (res['data'] as List)[0].resultMessage.toLowerCase().contains(
              'duplicate key',
            )) {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.morningBriefing,
              'Aktivitas sudah pernah diinput',
            ),
          );
        } else {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.morningBriefing,
              res['msg'],
            ),
          );
        }
      }
    } on LocationServiceDisabledException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.morningBriefing,
          'Lokasi tidak diizinkan',
        ),
      );
    } on PermissionDeniedException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.morningBriefing,
          'Izin lokasi ditolak',
        ),
      );
    } on TimeoutException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.morningBriefing,
          'Waktu permintaan lokasi habis',
        ),
      );
    } catch (e) {
      emit(
        HeadStoreInsertFailed(HeadStoreActTypes.morningBriefing, e.toString()),
      );
    }
  }

  Future<void> insertVisitMarket(
    InsertVisitMarket event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(HeadStoreLoading(isInsert: true));

      final employee =
          (event.context.read<LoginBloc>().state as LoginSuccess).user;
      final isActEmpty = event.actTypeName.isEmpty;
      final isUnitDisplayEmpty = event.unitDisplay.isEmpty;
      final isUnitTestEmpty = event.unitTest.isEmpty;
      final img = event.context.read<ImageCubit>().state;
      final isImgInvalid = img is ImageInitial || img is ImageError;
      final validator = Validator.visitMarket(
        isActEmpty: isActEmpty,
        isUnitDisplayEmpty: isUnitDisplayEmpty,
        isUnitTestEmpty: isUnitTestEmpty,
        isImgInvalid: isImgInvalid,
      );
      final headActsMaster = event.context.read<HeadActsMasterCubit>().state;
      final counter = event.context.read<CounterCubit>().getValues([
        'ttl_sales',
        'db',
        'hot_pros',
        'deal',
        'test_ride_participant',
      ]);

      if (!validator.isValid) {
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.visitMarket,
            validator.errorMessage!,
          ),
        );
        return;
      } else {
        final res = await headStoreRepo.insertNewVisitActivity(
          '1',
          employee.branch,
          employee.shop,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('HH:mm').format(DateTime.now()),
          (await Geolocator.getCurrentPosition()).latitude,
          (await Geolocator.getCurrentPosition()).longitude,
          event.actTypeName,
          (headActsMaster is HeadActsMasterLoaded)
              ? headActsMaster.briefingMaster[0].bsName
              : employee.bsName,
          counter[0],
          event.unitDisplay,
          counter[1],
          counter[2],
          counter[3],
          event.unitTest,
          counter[4],
          base64Encode(await (img as ImageCaptured).image.readAsBytes()),
          employee.employeeID,
        );
        log('$res');

        if (res['status'] == 'success' && res['code'] == '100') {
          log('Success');
          emit(HeadStoreInsertSucceed(HeadStoreActTypes.visitMarket));
        } else if (res['status'] == 'fail' &&
            res['code'] == '200' &&
            (res['data'] as List)[0].resultMessage.toLowerCase().contains(
              'duplicate key',
            )) {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.visitMarket,
              'Aktivitas sudah pernah diinput',
            ),
          );
        } else {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.visitMarket,
              res['msg'],
            ),
          );
        }
      }
    } on LocationServiceDisabledException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.visitMarket,
          'Lokasi tidak diizinkan',
        ),
      );
    } on PermissionDeniedException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.visitMarket,
          'Izin lokasi ditolak',
        ),
      );
    } on TimeoutException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.visitMarket,
          'Waktu permintaan lokasi habis',
        ),
      );
    } catch (e) {
      emit(
        HeadStoreInsertFailed(HeadStoreActTypes.visitMarket, e.toString()),
      );
    }
  }

  Future<void> insertRecruitment(
    InsertRecruitment event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(HeadStoreLoading(isInsert: true));

      final employee =
          (event.context.read<LoginBloc>().state as LoginSuccess).user;
      final isMediaEmpty = event.media.isEmpty;
      final isPositionEmpty = event.position.isEmpty;
      final img = event.context.read<ImageCubit>().state;
      final isImgInvalid = img is ImageInitial || img is ImageError;
      final validator = Validator.recruitment(
        isMediaEmpty: isMediaEmpty,
        isPositionEmtpy: isPositionEmpty,
        isImgInvalid: isImgInvalid,
      );

      if (!validator.isValid) {
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.recruitment,
            validator.errorMessage!,
          ),
        );
        return;
      } else {
        final res = await headStoreRepo.insertNewRecruitmentActivity(
          '1',
          employee.branch,
          employee.shop,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('HH:mm').format(DateTime.now()),
          (await Geolocator.getCurrentPosition()).latitude,
          (await Geolocator.getCurrentPosition()).longitude,
          event.media,
          event.position,
          base64Encode(await (img as ImageCaptured).image.readAsBytes()),
          employee.employeeID,
        );
        log('$res');

        if (res['status'] == 'success' && res['code'] == '100') {
          log('Success');
          emit(HeadStoreInsertSucceed(HeadStoreActTypes.recruitment));
        } else if (res['status'] == 'fail' &&
            res['code'] == '200' &&
            (res['data'] as List)[0].resultMessage.toLowerCase().contains(
              'duplicate key',
            )) {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.recruitment,
              'Aktivitas sudah pernah diinput',
            ),
          );
        } else {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.recruitment,
              res['msg'],
            ),
          );
        }
      }
    } on LocationServiceDisabledException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.recruitment,
          'Lokasi tidak diizinkan',
        ),
      );
    } on PermissionDeniedException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.recruitment,
          'Izin lokasi ditolak',
        ),
      );
    } on TimeoutException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.recruitment,
          'Waktu permintaan lokasi habis',
        ),
      );
    } catch (e) {
      emit(
        HeadStoreInsertFailed(HeadStoreActTypes.recruitment, e.toString()),
      );
    }
  }

  Future<void> insertInterview(
    InsertInterview event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(HeadStoreLoading(isInsert: true));

      final employee =
          (event.context.read<LoginBloc>().state as LoginSuccess).user;
      final img = event.context.read<ImageCubit>().state;
      final isImgInvalid = img is ImageInitial || img is ImageError;
      final validator = Validator.interview(isImgInvalid: isImgInvalid);

      if (!validator.isValid) {
        log('Validator failed: ${validator.errorMessage}');
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.interview,
            validator.errorMessage!,
          ),
        );
        return;
      } else {
        log('Validator passed');
        final counter = event.context.read<CounterCubit>().getValues([
          'called',
          'came',
          'acc',
          'fb_itv',
          'ig_itv',
          'training_itv',
          'cv_itv',
          'other_itv',
        ]);

        log('Creating the activity');
        final res = await headStoreRepo.insertNewInterviewActivity(
          '1',
          employee.branch,
          employee.shop,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('HH:mm').format(DateTime.now()),
          (await Geolocator.getCurrentPosition()).latitude,
          (await Geolocator.getCurrentPosition()).longitude,
          counter[0],
          counter[1],
          counter[2],
          base64Encode(await (img as ImageCaptured).image.readAsBytes()),
          employee.employeeID,
          <HeadMediaDetailsModel>[
            HeadMediaDetailsModel(
              mediaCode: 1,
              qty: counter[3],
            ),
            HeadMediaDetailsModel(
              mediaCode: 2,
              qty: counter[4],
            ),
            HeadMediaDetailsModel(
              mediaCode: 3,
              qty: counter[5],
            ),
            HeadMediaDetailsModel(
              mediaCode: 4,
              qty: counter[6],
            ),
            HeadMediaDetailsModel(
              mediaCode: 5,
              qty: counter[7],
            ),
          ],
        );
        log('Result: $res');

        if (res['status'] == 'success' && res['code'] == '100') {
          log('Success');
          emit(HeadStoreInsertSucceed(HeadStoreActTypes.interview));
        } else if (res['status'] == 'fail' &&
            res['code'] == '200' &&
            (res['data'] as List)[0].resultMessage.toLowerCase().contains(
              'duplicate key',
            )) {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.interview,
              'Aktivitas sudah pernah diinput',
            ),
          );
        } else {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.interview,
              res['msg'],
            ),
          );
        }
      }
    } on LocationServiceDisabledException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.interview,
          'Lokasi tidak diizinkan',
        ),
      );
    } on PermissionDeniedException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.interview,
          'Izin lokasi ditolak',
        ),
      );
    } on TimeoutException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.interview,
          'Waktu permintaan lokasi habis',
        ),
      );
    } catch (e) {
      emit(
        HeadStoreInsertFailed(HeadStoreActTypes.interview, e.toString()),
      );
    }
  }

  Future<void> insertDailyReport(
    InsertDailyReport event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(HeadStoreLoading(isInsert: true));

      final employee =
          (event.context.read<LoginBloc>().state as LoginSuccess).user;
      final img = event.context.read<ImageCubit>().state;
      final isImgInvalid = img is ImageInitial || img is ImageError;
      final validator = Validator.interview(
        isImgInvalid: isImgInvalid,
      );

      if (!validator.isValid) {
        emit(
          HeadStoreInsertFailed(
            HeadStoreActTypes.interview,
            validator.errorMessage!,
          ),
        );
        return;
      } else {
        final res = await headStoreRepo.insertNewReportActivity(
          '1',
          employee.branch,
          employee.shop,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('HH:mm').format(DateTime.now()),
          (await Geolocator.getCurrentPosition()).latitude,
          (await Geolocator.getCurrentPosition()).longitude,
          base64Encode(await (img as ImageCaptured).image.readAsBytes()),
          employee.employeeID,
          event.categoriesList,
          event.paymentList,
          event.leasingList,
          event.employeeList,
        );
        log('$res');

        if (res['status'] == 'success' && res['code'] == '100') {
          log('Success');
          emit(HeadStoreInsertSucceed(HeadStoreActTypes.dailyReport));
        } else if (res['status'] == 'fail' &&
            res['code'] == '200' &&
            (res['data'] as List)[0].resultMessage.toLowerCase().contains(
              'duplicate key',
            )) {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.dailyReport,
              'Aktivitas sudah pernah diinput',
            ),
          );
        } else {
          emit(
            HeadStoreInsertFailed(
              HeadStoreActTypes.dailyReport,
              res['msg'],
            ),
          );
        }
      }
    } on LocationServiceDisabledException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.dailyReport,
          'Lokasi tidak diizinkan',
        ),
      );
    } on PermissionDeniedException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.dailyReport,
          'Izin lokasi ditolak',
        ),
      );
    } on TimeoutException {
      emit(
        HeadStoreInsertFailed(
          HeadStoreActTypes.dailyReport,
          'Waktu permintaan lokasi habis',
        ),
      );
    } catch (e) {
      emit(
        HeadStoreInsertFailed(HeadStoreActTypes.dailyReport, e.toString()),
      );
    }
  }

  Future<void> deleteHeadActs(
    DeleteHeadActs event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(
        HeadStoreLoading(
          isDelete: true,
          isInsert: false,
          isActs: false,
          isDashboard: false,
          isActsDetail: false,
        ),
      );

      String apiEndpoint = '';
      switch (event.activityID) {
        case ('00'):
          apiEndpoint = APIConstants.headBriefingMasterEndpoint;
          break;
        case ('01'):
          apiEndpoint = APIConstants.headVisitMasterEndpoint;
          break;
        case ('02'):
          apiEndpoint = APIConstants.headRecruitmentMasterEndpoint;
          break;
        case ('03'):
          apiEndpoint = APIConstants.headInterviewMasterEndpoint;
          break;
        case ('04'):
          apiEndpoint = APIConstants.headReportMasterEndpoint;
          break;
      }

      final res = await headStoreRepo.deleteActivity(
        apiEndpoint,
        '2',
        event.employee.branch,
        event.employee.shop,
        event.date,
      );
      log('$res');

      if (res['status'] == 'success' && res['code'] == '100') {
        log('Success');
        emit(HeadStoreDeleteSucceed('Aktivitas berhasil dihapus.'));
      } else {
        log('Failed');
        emit(HeadStoreDeleteFailed(res['msg']));
      }
    } catch (e) {
      emit(HeadStoreDeleteFailed(e.toString()));
    }
  }
}
