import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sip_sales_clean/data/models/new_salesman_data_table.dart';
import 'package:sip_sales_clean/data/models/salesman_data_table.dart';

class SalesmanTableEvent with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ResetSalesman extends SalesmanTableEvent {
  final List<SalesmanData> salesDraftList;

  ResetSalesman(this.salesDraftList);
}

class FetchSalesman extends SalesmanTableEvent {
  final BuildContext context;

  FetchSalesman(this.context);
}

class AddSalesman extends SalesmanTableEvent {
  final String id;
  final String name;
  final String tier;
  final int status;

  AddSalesman(this.id, this.name, this.tier, this.status);
}

class AddSalesmanList extends SalesmanTableEvent {
  final List<NewSalesModel> salesDraftList;

  AddSalesmanList(this.salesDraftList);
}

class ModifySalesman extends SalesmanTableEvent {
  final int rowIndex;
  final String columnName;
  final int newValue;

  ModifySalesman({
    required this.rowIndex,
    required this.columnName,
    required this.newValue,
  });

  @override
  List<Object?> get props => [rowIndex, columnName, newValue];
}

class ModifySalesmanStatus extends SalesmanTableEvent {
  final NewSalesModel sales;

  ModifySalesmanStatus({required this.sales});
}
