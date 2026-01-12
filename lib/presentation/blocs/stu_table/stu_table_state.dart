import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';

class StuTableState with EquatableMixin {
  final List<HeadStuCategoriesMasterModel> data;

  StuTableState(this.data);

  @override
  List<Object?> get props => [data];
}

class StuInitial extends StuTableState {
  StuInitial(super.data);
}

class StuDataModified extends StuTableState {
  final List<HeadStuCategoriesMasterModel> newData;

  StuDataModified(this.newData) : super(newData);
}
