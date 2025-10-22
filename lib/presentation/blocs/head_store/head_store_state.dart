import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';

abstract class HeadStoreState {}

class HeadStoreInit extends HeadStoreState {}

class HeadStoreLoading extends HeadStoreState {
  final bool isActs;
  final bool isActsDetail;
  final bool isDashboard;
  final bool isInsert;
  final bool isDelete;

  HeadStoreLoading({
    this.isActs = false,
    this.isActsDetail = false,
    this.isDashboard = false,
    this.isInsert = false,
    this.isDelete = false,
  });
}

// ~:Daily Activities:~
class HeadStoreDataLoaded extends HeadStoreState {
  final List<HeadActsModel> headActs;

  HeadStoreDataLoaded(this.headActs);
}

class HeadStoreDataFailed extends HeadStoreState {
  final String message;

  HeadStoreDataFailed(this.message);
}

// ~:Daily Activities Detail:~
class HeadStoreDataDetailLoaded extends HeadStoreState {
  final List<HeadActsDetailsModel> headActsDetails;

  HeadStoreDataDetailLoaded(this.headActsDetails);
}

class HeadStoreDataDetailFailed extends HeadStoreState {
  final String message;

  HeadStoreDataDetailFailed(this.message);
}

// ~:Dashboard:~
class HeadStoreDashboardLoaded extends HeadStoreState {
  final List<CoordinatorDashboardModel> headStoreDashboard;

  HeadStoreDashboardLoaded(this.headStoreDashboard);
}

class HeadStoreDashboardFailed extends HeadStoreState {
  final String message;

  HeadStoreDashboardFailed(this.message);
}

// ~:Insert New Data:~
class HeadStoreInsertSucceed extends HeadStoreState {
  HeadStoreInsertSucceed();
}

class HeadStoreInsertFailed extends HeadStoreState {
  final String message;

  HeadStoreInsertFailed(this.message);
}

// ~:Delete Data:~
class HeadStoreDeleteSucceed extends HeadStoreState {
  final String message;

  HeadStoreDeleteSucceed(this.message);
}

class HeadStoreDeleteFailed extends HeadStoreState {
  final String message;

  HeadStoreDeleteFailed(this.message);
}
