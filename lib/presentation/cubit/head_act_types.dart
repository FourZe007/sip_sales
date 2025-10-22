import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/act_types.dart';
import 'package:sip_sales_clean/data/repositories/head_store_data.dart';

class HeadActTypesCubit extends Cubit<List<HeadActTypesModel>> {
  HeadActTypesCubit() : super([]);

  List<HeadActTypesModel> getActTypes() => state;

  Future<void> fetchActTypes() async {
    try {
      final res = await HeadStoreDataImp().fetchHeadActTypes();

      final String status = res['status'];
      final String code = res['code'];
      final List<HeadActTypesModel> data = res['data'];

      if (status == 'success' && code == '100') {
        emit(data);
      } else {
        emit(data);
      }
    } catch (e) {
      emit([]);
    }
  }
}
