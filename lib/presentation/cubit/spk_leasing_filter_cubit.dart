import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/domain/repositories/spk_leasing_filter_domain.dart';
import 'package:sip_sales_clean/presentation/functions.dart';

class SpkLeasingFilterCubit extends Cubit<SpkLeasingFilterState> {
  final SpkLeasingFilterRepo spkLeasingFilterRepo;

  SpkLeasingFilterCubit({required this.spkLeasingFilterRepo})
    : super(SpkLeasingFilterState());

  Future<void> loadFilterData() async {
    final employeeId = await Functions.readAndWriteEmployeeId();
    final groupDealer = await spkLeasingFilterRepo.loadGroupDealer(employeeId);
    final dealer = await spkLeasingFilterRepo.loadDealer(employeeId, '');
    final leasing = await spkLeasingFilterRepo.loadLeasing();
    final category = await spkLeasingFilterRepo.loadCategory();

    emit(
      SpkLeasingFilterLoaded(
        groupDealerList: groupDealer['data'] ?? [],
        dealerList: dealer['data'] ?? [],
        leasingList: leasing['data'] ?? [],
        categoryList: category['data'] ?? [],
      ),
    );
  }

  void resetFilter() => emit(SpkLeasingFilterState());

  Future<void> changeFilter({
    final String date = '',
    final String branchShop = '',
    final String category = '',
    final String leasingId = '',
    final String dealerType = '',
  }) async {
    emit(
      SpkLeasingFilterApplied(
        date: date,
        branchShop: branchShop,
        category: category,
        leasingId: leasingId,
        dealerType: dealerType,
      ),
    );
  }
}

class SpkLeasingFilterState {
  SpkLeasingFilterState();
}

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
