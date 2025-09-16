import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_bloc.dart';
import 'package:sip_sales/global/state/dashboard_slidingup_cubit.dart';
import 'package:sip_sales/global/state/dashboardtype_cubit.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/followupdate_cubit.dart';
import 'package:sip_sales/global/state/fufiltercontrols_cubit.dart';
import 'package:sip_sales/global/state/login/login_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_bloc.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_bloc.dart';

class BlocConstants {
  static List<SingleChildWidget> getBlocProviders() {
    return [
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
      ),
      BlocProvider<SalesDashboardBloc>(
        create: (context) => SalesDashboardBloc(),
      ),
      BlocProvider<CoordinatorDashboardBloc>(
        create: (context) => CoordinatorDashboardBloc(),
      ),
      BlocProvider<FollowupDashboardBloc>(
        create: (context) => FollowupDashboardBloc(),
      ),
      BlocProvider<UpdateFollowupDashboardBloc>(
        create: (context) => UpdateFollowupDashboardBloc(),
      ),
      BlocProvider<DashboardTypeCubit>(
        create: (context) => DashboardTypeCubit(),
      ),
      BlocProvider<FollowupCubit>(
        create: (context) => FollowupCubit(),
      ),
      BlocProvider<FuFilterControlsCubit>(
        create: (context) => FuFilterControlsCubit(),
      ),
      BlocProvider<DashboardSlidingUpCubit>(
        create: (context) => DashboardSlidingUpCubit(),
      ),
      BlocProvider<SMActivitiesDashboardBloc>(
        create: (context) => SMActivitiesDashboardBloc(),
      ),
    ];
  }
}
