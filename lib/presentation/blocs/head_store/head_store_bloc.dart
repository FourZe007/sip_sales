import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/domain/repositories/followup_domain.dart';
import 'package:sip_sales_clean/domain/repositories/head_store_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
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
    on<InsertHeadActs>(insertHeadActs);
    on<DeleteHeadActs>(deleteHeadActs);
  }

  Future<void> loadHeadActs(
    LoadHeadActs event,
    Emitter<HeadStoreState> emit,
  ) async {
    log('Load Head Acts');
    try {
      emit(HeadStoreLoading(isActs: true, isDashboard: false, isInsert: false));

      final res = await headStoreRepo.fetchHeadActs(
        event.employeeID,
        event.date,
      );
      log('Result: $res');

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

      final res = await headStoreRepo.fetchHeadActsDetails(
        event.employeeID,
        event.date,
        event.activityID,
      );
      log('$res');

      if (res['status'] == 'success') {
        log('Success');
        emit(HeadStoreDataDetailLoaded(res['data']));
      } else if (res['status'].toString().toLowerCase() == 'no data') {
        log('Empty');
        emit(HeadStoreDataDetailFailed('Data tidak tersedia.'));
      } else {
        log('Failed');
        emit(HeadStoreDataDetailFailed(res['msg']));
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

  Future<void> insertHeadActs(
    InsertHeadActs event,
    Emitter<HeadStoreState> emit,
  ) async {
    try {
      emit(
        HeadStoreLoading(
          isInsert: true,
          isActs: false,
          isDashboard: false,
          isActsDetail: false,
          isDelete: false,
        ),
      );

      // if (event.activityID.isEmpty) {
      //   emit(HeadStoreInsertFailed('Tipe aktivitas tidak boleh kosong'));
      //   return;
      // } else
      if (event.desc.isEmpty) {
        emit(HeadStoreInsertFailed('Deskripsi tidak boleh kosong'));
        return;
      } else if (event.img is ImageInitial) {
        emit(HeadStoreInsertFailed('Foto tidak boleh kosong'));
        return;
      } else if (event.img is ImageError) {
        emit(HeadStoreInsertFailed((event.img as ImageError).message));
        return;
      } else {
        final res = await headStoreRepo.insertNewActivity(
          '1',
          event.employee.employeeID,
          event.employee.branch,
          event.employee.shop,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('HH:mm').format(DateTime.now()),
          (await Geolocator.getCurrentPosition()).latitude,
          (await Geolocator.getCurrentPosition()).longitude,
          event.actId,
          event.desc,
          base64Encode(await (event.img as ImageCaptured).image.readAsBytes()),
        );
        log('$res');

        if (res['status'] == 'success' && res['code'] == '100') {
          log('Success');
          emit(HeadStoreInsertSucceed());
        } else if (res['status'] == 'fail' &&
            res['code'] == '200' &&
            (res['data'] as List)[0].resultMessage.toLowerCase().contains(
              'duplicate key',
            )) {
          emit(HeadStoreInsertFailed('Aktivitas sudah pernah diinput'));
        } else {
          emit(HeadStoreInsertFailed(res['msg']));
        }
      }
    } on LocationServiceDisabledException {
      emit(HeadStoreInsertFailed('Lokasi tidak diizinkan'));
    } on PermissionDeniedException {
      emit(HeadStoreInsertFailed('Izin lokasi ditolak'));
    } on TimeoutException {
      emit(HeadStoreInsertFailed('Waktu permintaan lokasi habis'));
    } catch (e) {
      emit(HeadStoreInsertFailed(e.toString()));
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

      final res = await headStoreRepo.deleteActivity(
        '2',
        event.employeeID,
        event.date,
        event.activityID,
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
