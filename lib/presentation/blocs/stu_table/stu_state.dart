import 'package:equatable/equatable.dart';
import 'package:sip_sales_clean/data/models/stu_data_table.dart';

class StuState with EquatableMixin {
  final List<StuData> data;

  StuState(this.data);

  @override
  List<Object?> get props => [data];
}

class StuInitial extends StuState {
  StuInitial(super.data);
}

class StuDataModified extends StuState {
  final List<StuData> newData;

  StuDataModified(this.newData) : super(newData);
}
