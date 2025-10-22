import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/data/repositories/head_store_data.dart';

class HeadActCubit extends Cubit<List<HeadActsModel>> {
  HeadActCubit() : super([]);

  List<HeadActsModel> getActData() => state;

  Future<void> fetchAct(
    String employeeID,
    String date,
  ) async {
    try {
      final res = await HeadStoreDataImp().fetchHeadActs(employeeID, date);

      final String status = res['status'];
      final String code = res['code'];
      final List<HeadActsModel> data = res['data'];

      if (status == 'success' && code == '100') {
        emit(data);
      } else {
        emit([]);
      }
    } catch (e) {
      emit([]);
    }
  }
}
