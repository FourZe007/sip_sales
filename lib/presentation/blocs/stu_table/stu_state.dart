import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';

class StuState with EquatableMixin {
  final List<HeadStuCategoriesMasterModel> data;

  StuState(this.data);

  @override
  List<Object?> get props => [data];
}

class StuInitial extends StuState {
  StuInitial(super.data);
}

class StuDataModified extends StuState {
  final List<HeadStuCategoriesMasterModel> newData;

  StuDataModified(this.newData) : super(newData);
}
