import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/domain/repositories/spk_leasing_filter_domain.dart';

class SpkLeasingFilterCubit extends Cubit<SpkLeasingFilterState> {
  final SpkLeasingFilterRepo spkLeasingFilterRepo;

  SpkLeasingFilterCubit({required this.spkLeasingFilterRepo})
    : super(SpkLeasingFilterState());

  Future<void> loadFilterData({String selectedGroupDealer = ''}) async {
    emit(SpkLeasingFilterLoading());

    // final employeeId = await Functions.readAndWriteEmployeeId();
    // final groupDealer = await spkLeasingFilterRepo.loadGroupDealer(employeeId);
    // final dealer = await spkLeasingFilterRepo.loadDealer(
    //   employeeId,
    //   selectedGroupDealer,
    // );
    final leasing = await spkLeasingFilterRepo.loadLeasing();
    final category = await spkLeasingFilterRepo.loadCategory();

    emit(
      SpkLeasingFilterLoaded(
        // groupDealerList: [
        //   SpkGrouDealerModel(
        //     order: 0,
        //     groupName: 'Semua',
        //   ),
        //   ...(groupDealer['data'] ?? []),
        // ],
        // dealerList: [
        //   SpkDealerModel(
        //     branch: '',
        //     shop: '',
        //     bsName: 'Semua',
        //     serverName: '',
        //     dbName: '',
        //     password: '',
        //     pt: '',
        //     groupName: '',
        //   ),
        //   ...(dealer['data']?.where(
        //         (SpkDealerModel e) =>
        //             e.branch.isNotEmpty &&
        //             e.shop.isNotEmpty &&
        //             e.bsName.isNotEmpty,
        //       ) ??
        //       []),
        // ],
        leasingList: [
          SpkLeasingModel(
            leasingId: 'Semua',
          ),
          ...?leasing['data'] ?? [],
        ],
        categoryList: [
          SpkCategoryModel(
            category: 'Semua',
          ),
          ...(category['data'] ?? []),
        ],
      ),
    );
  }

  void resetFilter() => emit(SpkLeasingFilterState());

  // Future<void> changeFilter({
  //   final String date = '',
  //   final String branchShop = '',
  //   final String category = '',
  //   final String leasingId = '',
  //   final String dealerType = '',
  // }) async {
  //   emit(
  //     SpkLeasingFilterApplied(
  //       date: date,
  //       branchShop: branchShop,
  //       category: category,
  //       leasingId: leasingId,
  //       dealerType: dealerType,
  //     ),
  //   );
  // }
}

class SpkLeasingFilterState {
  SpkLeasingFilterState();
}

class SpkLeasingFilterLoading extends SpkLeasingFilterState {}

class SpkLeasingFilterLoaded extends SpkLeasingFilterState {
  final List<SpkGrouDealerModel> groupDealerList;
  final List<SpkDealerModel> dealerList;
  final List<SpkLeasingModel> leasingList;
  final List<SpkCategoryModel> categoryList;

  SpkLeasingFilterLoaded({
    this.groupDealerList = const [],
    this.dealerList = const [],
    this.leasingList = const [],
    this.categoryList = const [],
  });

  SpkLeasingFilterLoaded copyWith({
    List<SpkGrouDealerModel>? groupDealerList,
    List<SpkDealerModel>? dealerList,
    List<SpkLeasingModel>? leasingList,
    List<SpkCategoryModel>? categoryList,
  }) {
    return SpkLeasingFilterLoaded(
      groupDealerList: groupDealerList ?? this.groupDealerList,
      dealerList: dealerList ?? this.dealerList,
      leasingList: leasingList ?? this.leasingList,
      categoryList: categoryList ?? this.categoryList,
    );
  }
}

class SpkLeasingFilterApplied extends SpkLeasingFilterState {
  final String date;
  final String branchShop;
  final String category;
  final String leasingId;
  final String dealerType;

  SpkLeasingFilterApplied({
    this.date = '',
    this.branchShop = '',
    this.category = '',
    this.leasingId = '',
    this.dealerType = '',
  });
}
