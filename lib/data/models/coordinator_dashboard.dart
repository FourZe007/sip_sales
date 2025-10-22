class CoordinatorDashboardModel {
  final int prospek;
  final int spk;
  final int spkTerbuka;
  final int delivery;
  final int stu;
  final int prospekH;
  final int spkh;
  final int spkTerbukaH;
  final int deliveryH;
  final int stuh;
  final List<SalesmanProspekModel> prospekList;
  final List<SalesmanStuModel> stuList;
  final List<CategoryModel> categoryList;
  final List<LeasingModel> leasingList;
  final List<DailyModel> dailyList;
  final List<ProspekTypeModel> prospekTypeList;
  final List<SalesFUOverviewModel> salesFUOverviewList;

  CoordinatorDashboardModel({
    required this.prospek,
    required this.spk,
    required this.spkTerbuka,
    required this.delivery,
    required this.stu,
    required this.prospekH,
    required this.spkh,
    required this.spkTerbukaH,
    required this.deliveryH,
    required this.stuh,
    required this.prospekList,
    required this.stuList,
    required this.categoryList,
    required this.leasingList,
    required this.dailyList,
    required this.prospekTypeList,
    required this.salesFUOverviewList,
  });

  factory CoordinatorDashboardModel.fromJson(Map<String, dynamic> json) {
    return CoordinatorDashboardModel(
      prospek: json['prospek'],
      spk: json['spk'],
      spkTerbuka: json['spkTerbuka'],
      delivery: json['delivery'],
      stu: json['stu'],
      prospekH: json['prospekH'],
      spkh: json['spkh'],
      spkTerbukaH: json['spkTerbukaH'],
      deliveryH: json['deliveryH'],
      stuh: json['stuh'],
      prospekList: (json['salesmanP'] as List)
          .map<SalesmanProspekModel>(
            (data) => SalesmanProspekModel.fromJson(data),
          )
          .toList(),
      stuList: (json['salesmanSTU'] as List)
          .map<SalesmanStuModel>((data) => SalesmanStuModel.fromJson(data))
          .toList(),
      categoryList: (json['category'] as List)
          .map<CategoryModel>((data) => CategoryModel.fromJson(data))
          .toList(),
      leasingList: (json['leasing'] as List)
          .map<LeasingModel>((data) => LeasingModel.fromJson(data))
          .toList(),
      dailyList: (json['daily'] as List)
          .map<DailyModel>((data) => DailyModel.fromJson(data))
          .toList(),
      prospekTypeList: (json['prospekType'] as List)
          .map<ProspekTypeModel>((data) => ProspekTypeModel.fromJson(data))
          .toList(),
      salesFUOverviewList: (json['salesmanProspek'] as List)
          .map<SalesFUOverviewModel>(
            (data) => SalesFUOverviewModel.fromJson(data),
          )
          .toList(),
    );
  }
}

class SalesmanProspekModel {
  final String employeeId;
  final String employeeName;
  final String? employeeType;
  final int targetP;
  final int prospek;
  final dynamic ratioP;
  final int targetS;
  final int spk;
  final int ratioS;

  SalesmanProspekModel({
    required this.employeeId,
    required this.employeeName,
    this.employeeType = '',
    required this.targetP,
    required this.prospek,
    required this.ratioP,
    required this.targetS,
    required this.spk,
    required this.ratioS,
  });

  factory SalesmanProspekModel.fromJson(Map<String, dynamic> json) {
    return SalesmanProspekModel(
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      employeeType: json['kode'] ?? '',
      targetP: json['targetP'],
      prospek: json['prospek'],
      ratioP: json['ratioP'],
      targetS: json['targetS'],
      spk: json['spk'],
      ratioS: json['ratioS'],
    );
  }
}

class SalesmanStuModel {
  final String employeeId;
  final String employeeName;
  final int target;
  final int stu;
  final int ratioSTU;
  final int stulm;
  final dynamic growth;
  final dynamic cr;

  SalesmanStuModel({
    required this.employeeId,
    required this.employeeName,
    required this.target,
    required this.stu,
    required this.ratioSTU,
    required this.stulm,
    required this.growth,
    required this.cr,
  });

  factory SalesmanStuModel.fromJson(Map<String, dynamic> json) {
    return SalesmanStuModel(
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      target: json['target'],
      stu: json['stu'],
      ratioSTU: json['ratioSTU'],
      stulm: json['stulm'],
      growth: json['growth'],
      cr: json['cr'],
    );
  }
}

class CategoryModel {
  final int lineSC;
  final String salesCategorySC;
  final int prospekSC;
  final int spksc;
  final int stusc;
  final int lmsc;
  final dynamic ratioSC;

  CategoryModel({
    required this.lineSC,
    required this.salesCategorySC,
    required this.prospekSC,
    required this.spksc,
    required this.stusc,
    required this.lmsc,
    required this.ratioSC,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      lineSC: json['lineSC'],
      salesCategorySC: json['salesCategorySC'],
      prospekSC: json['prospekSC'],
      spksc: json['spksc'],
      stusc: json['stusc'],
      lmsc: json['lmsc'],
      ratioSC: json['ratioSC'],
    );
  }
}

class LeasingModel {
  final int lineLeasing;
  final String leasingID;
  final int totalSPKLeasing;
  final int spkProsesLeasing;
  final int spkTerbukaLeasing;
  final int spkApproveLeasing;
  final dynamic ratioLeasing;

  LeasingModel({
    required this.lineLeasing,
    required this.leasingID,
    required this.totalSPKLeasing,
    required this.spkProsesLeasing,
    required this.spkTerbukaLeasing,
    required this.spkApproveLeasing,
    required this.ratioLeasing,
  });

  factory LeasingModel.fromJson(Map<String, dynamic> json) {
    return LeasingModel(
      lineLeasing: json['lineLeasing'],
      leasingID: json['leasingID'],
      totalSPKLeasing: json['totalSPKLeasing'],
      spkProsesLeasing: json['spkProsesLeasing'],
      spkTerbukaLeasing: json['spkTerbukaLeasing'],
      spkApproveLeasing: json['spkApproveLeasing'],
      ratioLeasing: json['ratioLeasing'],
    );
  }
}

class DailyModel {
  final int hari;
  final int prospekD;
  final int stud;

  DailyModel({
    required this.hari,
    required this.prospekD,
    required this.stud,
  });

  factory DailyModel.fromJson(Map<String, dynamic> json) {
    return DailyModel(
      hari: json['hari'],
      prospekD: json['prospekD'],
      stud: json['stud'],
    );
  }
}

class ProspekTypeModel {
  final String prospekType;
  final int prospekT;
  final int stut;

  ProspekTypeModel({
    required this.prospekType,
    required this.prospekT,
    required this.stut,
  });

  factory ProspekTypeModel.fromJson(Map<String, dynamic> json) {
    return ProspekTypeModel(
      prospekType: json['prospectType'],
      prospekT: json['prospekT'],
      stut: json['stut'],
    );
  }
}

class SalesFUOverviewModel {
  final String employeeId;
  final String employeeName;
  final String? employeeType;
  final int totalProspect;
  final int newProspect;
  final int prosesFU;
  final int closing;
  final int batal;
  final int belumFU;

  SalesFUOverviewModel({
    required this.employeeId,
    required this.employeeName,
    this.employeeType = '',
    required this.totalProspect,
    required this.newProspect,
    required this.prosesFU,
    required this.closing,
    required this.batal,
    required this.belumFU,
  });

  factory SalesFUOverviewModel.fromJson(Map<String, dynamic> json) {
    return SalesFUOverviewModel(
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      employeeType: json['kode'] ?? '',
      totalProspect: json['totalProspect'],
      newProspect: json['newProspect'],
      prosesFU: json['prosesFU'],
      closing: json['closing'],
      batal: json['batal'],
      belumFU: json['belumFU'],
    );
  }
}
