import 'package:equatable/equatable.dart';

class ReportModel {
  final String date;
  final String userId;
  final String userName;
  final String area;
  final String pic;
  final List<PaymentModel> payment;
  final List<SalesmanModel> salesmen;
  final List<StuModel> stu;
  final List<LeasingModel> leasing;

  ReportModel({
    required this.date,
    required this.userId,
    required this.userName,
    required this.area,
    required this.pic,
    required this.payment,
    required this.salesmen,
    required this.stu,
    required this.leasing,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      date: json['TransDate'],
      userId: json['CustomerID'],
      userName: json['CName'],
      area: json['Area'],
      pic: json['PIC'],
      payment: (json['DataPayment'] as List)
          .map((item) => PaymentModel.fromJson(item))
          .toList(),
      salesmen: (json['DataSalesman'] as List)
          .map((item) => SalesmanModel.fromJson(item))
          .toList(),
      stu: (json['DataSTU'] as List)
          .map((item) => StuModel.fromJson(item))
          .toList(),
      leasing: (json['DataLeasing'] as List)
          .map((item) => LeasingModel.fromJson(item))
          .toList(),
    );
  }
}

class PaymentModel extends Equatable {
  final String payment;
  final int result;
  final int lmPayment;
  final int flag;
  final int line;

  const PaymentModel({
    required this.payment,
    required this.result,
    required this.lmPayment,
    required this.flag,
    required this.line,
  });

  @override
  List<Object?> get props => [payment, result, lmPayment, flag, line];

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      payment: json['Payment'],
      result: json['ResultPayment'],
      lmPayment: json['LMPayment'],
      flag: json['FlagPayment'],
      line: json['LinePayment'],
    );
  }
}

class SalesmanModel {
  final String idCardNumber;
  final String name;
  final String tierLevel;
  final int spk;
  final int stu;
  final int stuLm;
  final int line;
  final int flag;

  SalesmanModel({
    required this.idCardNumber,
    required this.name,
    required this.tierLevel,
    required this.spk,
    required this.stu,
    required this.stuLm,
    required this.line,
    required this.flag,
  });

  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      idCardNumber: json['KTP'],
      name: json['Name'],
      tierLevel: json['EntryLevel'],
      spk: json['SPK'],
      stu: json['STU'],
      stuLm: json['STULM'],
      line: json['LineSalesman'],
      flag: json['FlagSalesman'],
    );
  }
}

class StuModel {
  final String group;
  final int stuResult;
  final int stuTarget;
  final int lmStu;
  final int line;
  final int flag;

  StuModel({
    required this.group,
    required this.stuResult,
    required this.stuTarget,
    required this.lmStu,
    required this.line,
    required this.flag,
  });

  factory StuModel.fromJson(Map<String, dynamic> json) {
    return StuModel(
      group: json['MotorGroup'],
      stuResult: json['ResultSTU'],
      stuTarget: json['TargetSTU'],
      lmStu: json['LMSTU'],
      line: json['LineSTU'],
      flag: json['FlagSTU'],
    );
  }
}

class LeasingModel {
  final String leasing;
  final int openSpk;
  final int acceptedSpk;
  final int rejectedSpk;
  final int line;
  final int flag;

  LeasingModel({
    required this.leasing,
    required this.openSpk,
    required this.acceptedSpk,
    required this.rejectedSpk,
    required this.line,
    required this.flag,
  });

  factory LeasingModel.fromJson(Map<String, dynamic> json) {
    return LeasingModel(
      leasing: json['Leasing'],
      openSpk: json['OpenSPK'],
      acceptedSpk: json['ApprovedSPK'],
      rejectedSpk: json['RejectedSPK'],
      line: json['LineLeasing'],
      flag: json['FlagLeasing'],
    );
  }
}
