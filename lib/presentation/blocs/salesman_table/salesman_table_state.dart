import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/data/models/sales_profile.dart';

class SalesmanTableState with EquatableMixin {
  // final List<SalesProfileModel> salesDraftList;
  final List<HeadEmployeeMasterModel> salesmanList;
  final List<HeadReportMasterModel> fetchSalesList;
  final List<HeadEmployeeMasterModel> salesDataList;

  SalesmanTableState(
    this.salesmanList,
    this.fetchSalesList,
    this.salesDataList,
  );

  @override
  List<Object?> get props => [salesmanList, fetchSalesList, salesDataList];
}

class SalesmanInitial extends SalesmanTableState {
  SalesmanInitial(
    super.salesmanList,
    super.fetchSalesList,
    super.salesDataList,
  );
}

class SalesmanLoading extends SalesmanTableState {
  SalesmanLoading(SalesmanTableState previousState)
    : super(previousState.salesmanList, previousState.fetchSalesList, []);

  List<SalesProfileModel> get getSalesmanLoading => [];
}

class SalesmanFetched extends SalesmanTableState {
  final List<HeadReportMasterModel> salesList;
  final List<HeadEmployeeMasterModel> salesmanDataList;

  SalesmanFetched(
    SalesmanTableState previousState,
    this.salesList,
    this.salesmanDataList,
  ) : super(previousState.salesmanList, salesList, salesmanDataList);

  @override
  List<Object?> get props => [salesmanList, fetchSalesList, salesDataList];
}

class SalesmanAdded extends SalesmanTableState {
  final List<Map<String, dynamic>>? results;

  SalesmanAdded({this.results}) : super([], [], []);

  @override
  List<Object?> get props => [results];
}

class SalesmanPartialSuccess extends SalesmanTableState {
  final List<Map<String, dynamic>> results;
  final String? errorMessage;

  SalesmanPartialSuccess(this.results, {this.errorMessage}) : super([], [], []);

  @override
  List<Object?> get props => [results, errorMessage];
}

class SalesmanError extends SalesmanTableState {
  final String error;

  SalesmanError(this.error) : super([], [], []);

  String get getSalesmanError => 'Error: $error';
}

// ~:Table Insertation:~
class SalesmanModified extends SalesmanTableState {
  final SalesmanTableState previousState;
  final List<HeadEmployeeMasterModel> newData;

  SalesmanModified(this.previousState, this.newData) : super([], [], newData);
}

// ~:Modify Salesman Status:~
class SalesmanStatusModified extends SalesmanTableState {
  final String message;

  SalesmanStatusModified(this.message) : super([], [], []);
}

class SalesmanStatusModifyError extends SalesmanTableState {
  final String error;

  SalesmanStatusModifyError(this.error) : super([], [], []);
}
