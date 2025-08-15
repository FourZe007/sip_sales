import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/model.dart';

class FollowupCubit extends Cubit<UpdateFollowUpDashboardModel> {
  FollowupCubit()
      : super(UpdateFollowUpDashboardModel(
          customerName: '',
          prospectDate: '',
          customerStatus: '',
          modelName: '',
          mobilePhone: '',
          prospectStatus: '',
          firstFUDate: '',
          followup: [],
        ));

  UpdateFollowUpDashboardModel get getFollowup => state;

  void resetFollowup() => emit(
        UpdateFollowUpDashboardModel(
          customerName: '',
          prospectDate: '',
          customerStatus: '',
          modelName: '',
          mobilePhone: '',
          prospectStatus: '',
          firstFUDate: '',
          followup: [],
        ),
      );

  void changeFollowup(UpdateFollowUpDashboardModel data) => emit(data);
}
