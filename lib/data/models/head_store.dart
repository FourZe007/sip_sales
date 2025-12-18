// Model for Shop Manager Activities
// 2401/003346 -> HARKA WICAKSONO
class HeadActsModel {
  String employeeId;
  String employeeName;
  String branch;
  String shopId;
  String shopName;
  String date;
  String time;
  double lat;
  double lng;
  String activityId;
  String activityName;
  String activityDesc;
  String img;

  HeadActsModel({
    required this.employeeId,
    required this.employeeName,
    required this.branch,
    required this.shopId,
    required this.shopName,
    required this.date,
    required this.time,
    required this.lat,
    required this.lng,
    required this.activityId,
    required this.activityName,
    required this.activityDesc,
    required this.img,
  });

  factory HeadActsModel.fromJson(Map<String, dynamic> json) {
    return HeadActsModel(
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      branch: json['branch'],
      shopId: json['shop'],
      shopName: json['bsName'],
      date: json['currentDate'],
      time: json['currentTime'],
      lat: (json['lat'] is int ? json['lat'].toDouble() : json['lat']),
      lng: (json['lng'] is int ? json['lng'].toDouble() : json['lng']),
      activityId: json['activityID'],
      activityName: json['activityName'],
      // ~:New:~
      activityDesc: json['activityDescription'],
      img: json['pic1'],
      // ~:New:~
    );
  }
}

class HeadActsDetailsModel {
  String time;
  double lat;
  double lng;
  String actId;
  String actDesc;
  String pic1;

  HeadActsDetailsModel({
    required this.time,
    required this.lat,
    required this.lng,
    required this.actId,
    required this.actDesc,
    required this.pic1,
  });

  factory HeadActsDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadActsDetailsModel(
      time: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      actId: json['activityID'],
      actDesc: json['activityDescription'],
      pic1: json['pic1'],
    );
  }
}

class HeadBriefingMasterModel {
  final String bsName;
  final String area;
  final int contestant;
  final int shopManager;
  final int salesCounter;
  final int salesman;
  final int others;

  HeadBriefingMasterModel({
    required this.bsName,
    required this.area,
    required this.contestant,
    required this.shopManager,
    required this.salesCounter,
    required this.salesman,
    required this.others,
  });

  factory HeadBriefingMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadBriefingMasterModel(
      bsName: json['bsName'],
      area: json['area'],
      contestant: json['peserta'],
      shopManager: json['shopManager'],
      salesCounter: json['salesCounter'],
      salesman: json['salesman'],
      others: json['others'],
    );
  }
}

class HeadVisitMasterModel {
  final String bsName;
  final String area;

  HeadVisitMasterModel({
    required this.bsName,
    required this.area,
  });

  factory HeadVisitMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadVisitMasterModel(
      bsName: json['bsName'],
      area: json['area'],
    );
  }
}

class HeadRecruitmentMasterModel {
  final String bsName;
  final String area;

  HeadRecruitmentMasterModel({
    required this.bsName,
    required this.area,
  });

  factory HeadRecruitmentMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadRecruitmentMasterModel(
      bsName: json['bsName'],
      area: json['area'],
    );
  }
}

class HeadInterviewMasterModel {
  final String bsName;
  final String area;
  final List<HeadMediaMasterModel> masterMedia;

  HeadInterviewMasterModel({
    required this.bsName,
    required this.area,
    required this.masterMedia,
  });

  factory HeadInterviewMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadInterviewMasterModel(
      bsName: json['bsName'],
      area: json['area'],
      masterMedia: (json['masterMedia'] as List)
          .map((e) => HeadMediaMasterModel.fromJson(e))
          .toList(),
    );
  }
}

class HeadMediaMasterModel {
  final int mediaCode;
  final String mediaName;
  final int line;

  HeadMediaMasterModel({
    required this.mediaCode,
    required this.mediaName,
    required this.line,
  });

  factory HeadMediaMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadMediaMasterModel(
      mediaCode: json['mediaCode'],
      mediaName: json['mediaName'],
      line: json['line'],
    );
  }
}

class HeadReportMasterModel {
  final String bsName;
  final String area;
  final List<HeadStuCategoriesMasterModel> stuCategories;
  final List<HeadPaymentMasterModel> payment;
  final List<HeadLeasingMasterModel> spkLeasing;
  final List<HeadEmployeeMasterModel> employee;

  HeadReportMasterModel({
    required this.bsName,
    required this.area,
    required this.stuCategories,
    required this.payment,
    required this.spkLeasing,
    required this.employee,
  });

  factory HeadReportMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadReportMasterModel(
      bsName: json['bsName'],
      area: json['area'],
      stuCategories: (json['stuCategory'] as List)
          .map((e) => HeadStuCategoriesMasterModel.fromJson(e))
          .toList(),
      payment: (json['payment'] as List)
          .map((e) => HeadPaymentMasterModel.fromJson(e))
          .toList(),
      spkLeasing: (json['spkLeasing'] as List)
          .map((e) => HeadLeasingMasterModel.fromJson(e))
          .toList(),
      employee: (json['employee'] as List)
          .map((e) => HeadEmployeeMasterModel.fromJson(e))
          .toList(),
    );
  }
}

class HeadStuCategoriesMasterModel {
  final int line;
  final String category;
  final int target;
  final int tm;
  final double acv;
  final int lm;
  final double growth;

  HeadStuCategoriesMasterModel({
    required this.line,
    required this.category,
    required this.target,
    required this.tm,
    required this.acv,
    required this.lm,
    required this.growth,
  });

  factory HeadStuCategoriesMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadStuCategoriesMasterModel(
      line: json['line'],
      category: json['category'],
      target: json['target'],
      tm: json['tm'],
      acv: json['acv'],
      lm: json['lm'],
      growth: json['growth'],
    );
  }
}

class HeadPaymentMasterModel {
  final int line;
  final String payment;
  final int tm;
  final int lm;
  final double growth;

  HeadPaymentMasterModel({
    required this.line,
    required this.payment,
    required this.tm,
    required this.lm,
    required this.growth,
  });

  factory HeadPaymentMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadPaymentMasterModel(
      line: json['line'],
      payment: json['payment'],
      tm: json['tm'],
      lm: json['lm'],
      growth: json['growth'],
    );
  }
}

class HeadLeasingMasterModel {
  final int line;
  final String leasingID;
  final int total;
  final int terbuka;
  final int disetujui;
  final int ditolak;
  final double persentase;

  HeadLeasingMasterModel({
    required this.line,
    required this.leasingID,
    required this.total,
    required this.terbuka,
    required this.disetujui,
    required this.ditolak,
    required this.persentase,
  });

  factory HeadLeasingMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadLeasingMasterModel(
      line: json['line'],
      leasingID: json['leasingID'],
      total: json['total'],
      terbuka: json['terbuka'],
      disetujui: json['disetujui'],
      ditolak: json['ditolak'],
      persentase: json['persentase'],
    );
  }
}

class HeadEmployeeMasterModel {
  final int line;
  final String employeeID;
  final String eName;
  final String eTypeID;
  final String position;
  final int spk;
  final int stu;
  final int stuLm;

  HeadEmployeeMasterModel({
    required this.line,
    required this.employeeID,
    required this.eName,
    required this.eTypeID,
    required this.position,
    required this.spk,
    required this.stu,
    required this.stuLm,
  });

  factory HeadEmployeeMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadEmployeeMasterModel(
      line: json['line'],
      employeeID: json['employeeID'],
      eName: json['eName'],
      eTypeID: json['eTypeID'],
      position: json['position'],
      spk: json['spk'],
      stu: json['stu'],
      stuLm: json['stuLm'],
    );
  }
}
