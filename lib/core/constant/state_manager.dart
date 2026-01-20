import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sip_sales_clean/data/repositories/attendance_data.dart';
import 'package:sip_sales_clean/data/repositories/followup_data.dart';
import 'package:sip_sales_clean/data/repositories/head_store_data.dart';
import 'package:sip_sales_clean/data/repositories/image_data.dart';
import 'package:sip_sales_clean/data/repositories/login_data.dart';
import 'package:sip_sales_clean/data/repositories/radius_checker_data.dart';
import 'package:sip_sales_clean/data/repositories/sales.dart';
import 'package:sip_sales_clean/data/repositories/salesman_data.dart';
import 'package:sip_sales_clean/data/repositories/spk_leasing_filter_data.dart';
import 'package:sip_sales_clean/data/repositories/update_followup_data.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/location_service/location_service_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/update_followup/update_fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/attendance_type_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/briefing_desc.dart';
import 'package:sip_sales_clean/presentation/cubit/counter_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_type.dart';
import 'package:sip_sales_clean/presentation/cubit/forgot_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/fu_controls_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/fu_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/head_act_types.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
import 'package:sip_sales_clean/presentation/cubit/navbar_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_data_cubit.dart';

class StateManager {
  static List<SingleChildWidget> getBlocProviders() {
    return [
      BlocProvider<CounterCubit>(
        create: (context) => CounterCubit(),
      ),
      BlocProvider<ImageCubit>(
        create: (context) => ImageCubit(ImageRepoImp()),
      ),
      BlocProvider<NavbarCubit>(
        create: (context) => NavbarCubit(),
      ),
      BlocProvider<HeadActTypesCubit>(
        create: (context) => HeadActTypesCubit(),
      ),
      BlocProvider<HeadActsMasterCubit>(
        create: (context) => HeadActsMasterCubit(HeadStoreDataImp()),
      ),
      BlocProvider<BriefingDescCubit>(
        create: (context) => BriefingDescCubit(),
      ),
      BlocProvider<DashboardSlidingUpCubit>(
        create: (context) => DashboardSlidingUpCubit(),
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
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(loginRepo: LoginRepoImp()),
      ),
      BlocProvider<ForgotCubit>(
        create: (context) => ForgotCubit(loginRepository: LoginRepoImp()),
      ),
      BlocProvider<LocationServiceBloc>(
        create: (context) => LocationServiceBloc(),
      ),
      // BlocProvider<HeadActCubit>(
      //   create: (context) => HeadActCubit(),
      // ),
      BlocProvider<HeadStoreBloc>(
        create: (context) => HeadStoreBloc(
          headStoreRepo: HeadStoreDataImp(),
          followupRepo: FollowupDataImp(),
        ),
      ),
      BlocProvider<StuTableBloc>(create: (context) => StuTableBloc()),
      BlocProvider<PaymentTableBloc>(create: (context) => PaymentTableBloc()),
      BlocProvider<LeasingTableBloc>(create: (context) => LeasingTableBloc()),
      BlocProvider<SalesmanTableBloc>(
        create: (context) => SalesmanTableBloc(
          salesRepo: SalesRepoImp(),
        ),
      ),
      BlocProvider<SpkLeasingFilterCubit>(
        create: (context) => SpkLeasingFilterCubit(
          spkLeasingFilterRepo: SpkLeasingFilterDataImp(),
        ),
      ),
      BlocProvider<SpkLeasingDataCubit>(
        create: (context) => SpkLeasingDataCubit(
          spkLeasingFilterDataImp: SpkLeasingFilterDataImp(),
        ),
      ),
      BlocProvider<RadiusCheckerBloc>(
        create: (context) =>
            RadiusCheckerBloc(radiusCheckerRepo: RadiusCheckerRepoImp()),
      ),
      BlocProvider<AttendanceBloc>(
        create: (context) => AttendanceBloc(
          attendanceRepo: AttendanceRepoImp(),
          radiusCheckerRepo: RadiusCheckerRepoImp(),
        ),
      ),
      BlocProvider<SalesmanBloc>(
        create: (context) => SalesmanBloc(salesmanRepo: SalesmanDataImp()),
      ),
      BlocProvider<AttendanceTypeCubit>(
        create: (context) => AttendanceTypeCubit(),
      ),
      BlocProvider<ShopCoordinatorBloc>(
        create: (context) => ShopCoordinatorBloc(),
      ),
      BlocProvider<FollowupDashboardBloc>(
        create: (context) =>
            FollowupDashboardBloc(followupRepo: FollowupDataImp()),
      ),
      BlocProvider<UpdateFollowupDashboardBloc>(
        create: (context) =>
            UpdateFollowupDashboardBloc(followupRepo: UpdateFollowupDataImp()),
      ),
    ];
  }
}
