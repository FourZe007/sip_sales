import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/domain/repositories/spk_leasing_filter_domain.dart';
import 'package:sip_sales_clean/presentation/functions.dart';

class SpkLeasingFilterCubit extends Cubit<SpkLeasingFilterState> {
  final SpkLeasingFilterRepo spkLeasingFilterRepo;

  SpkLeasingFilterCubit({required this.spkLeasingFilterRepo})
    : super(SpkLeasingFilterState());

  void changeFilter(SpkLeasingFilterState state) => emit(state);

  Future<void> loadFilterData() async {
    final employeeId = await Functions.readAndWriteEmployeeId();
    final groupDealer = await spkLeasingFilterRepo.loadGroupDealer(employeeId);
    final dealer = await spkLeasingFilterRepo.loadDealer(employeeId, '');
    final leasing = await spkLeasingFilterRepo.loadLeasing();
    final category = await spkLeasingFilterRepo.loadCategory();

    emit(
      SpkLeasingFilterState(
        groupDealerList: groupDealer['data'] ?? [],
        dealerList: dealer['data'] ?? [],
        leasingList: leasing['data'] ?? [],
        categoryList: category['data'] ?? [],
      ),
    );
  }
}

class SpkLeasingFilterState {
  final List<SpkGrouDealerModel> groupDealerList;
  final List<SpkDealerModel> dealerList;
  final List<SpkLeasingModel> leasingList;
  final List<SpkCategoryModel> categoryList;

  SpkLeasingFilterState({
    this.groupDealerList = const [],
    this.dealerList = const [],
    this.leasingList = const [],
    this.categoryList = const [],
  });

  SpkLeasingFilterState copyWith({
    List<SpkGrouDealerModel>? groupDealerList,
    List<SpkDealerModel>? dealerList,
    List<SpkLeasingModel>? leasingList,
    List<SpkCategoryModel>? categoryList,
  }) {
    return SpkLeasingFilterState(
      groupDealerList: groupDealerList ?? this.groupDealerList,
      dealerList: dealerList ?? this.dealerList,
      leasingList: leasingList ?? this.leasingList,
      categoryList: categoryList ?? this.categoryList,
    );
  }
}
