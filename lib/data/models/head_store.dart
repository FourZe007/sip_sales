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

// ~:Old Details Model:~
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

// "bsName": "SENTRAL YAMAHA MALANG",
//       "area": "MALANG",
//       "currentDate": "2025-11-12",
//       "currentTime": "08:24",
//       "lat": -7.9778212,
//       "lng": 112.6297474,
//       "lokasi": "DEALER",
//       "topic": "PENJUALAN MINGGU KE 2",
//       "pic1Thumb":
// "employeeID": "2006/002812",
//       "eName": "EVAN AGUS MAULANA",
//       "peserta": 30,
//       "shopManager": 1,
//       "salesCounter": 2,
//       "salesman": 27,
//       "others": 0
class HeadBriefingDetailsModel {
  final String bsName;
  final String area;
  final String date;
  final String time;
  final double lat;
  final double lng;
  final String locationName;
  final String description;
  final String img;
  final String employeeId;
  final String employeeName;
  final int numberOfParticipant;
  final int shopManager;
  final int salesCounter;
  final int salesman;
  final int others;

  HeadBriefingDetailsModel({
    required this.bsName,
    required this.area,
    required this.date,
    required this.time,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.description,
    required this.img,
    required this.employeeId,
    required this.employeeName,
    required this.numberOfParticipant,
    required this.shopManager,
    required this.salesCounter,
    required this.salesman,
    required this.others,
  });

  factory HeadBriefingDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadBriefingDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      date: json['currentDate'],
      time: json['currentTime'],
      lat: (json['lat'] is int ? json['lat'].toDouble() : json['lat']),
      lng: (json['lng'] is int ? json['lng'].toDouble() : json['lng']),
      locationName: json['lokasi'],
      description: json['topic'],
      img: json['pic1'],
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      numberOfParticipant: json['peserta'],
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

class HeadVisitDetailsModel {
  final String bsName;
  final String area;
  final String date;
  final String time;
  final String employeeId;
  final String employeeName;
  final int salesman;
  final int unitDisplay;
  final int database;
  final int hotProspek;
  final int deal;
  final int unitTestRide;
  final int pesertaTestRide;
  final String jenisAktivitas;
  final String lokasi;
  final String jenisAktivitasDesc;

  HeadVisitDetailsModel({
    required this.bsName,
    required this.area,
    required this.date,
    required this.time,
    required this.employeeId,
    required this.employeeName,
    required this.salesman,
    required this.unitDisplay,
    required this.database,
    required this.hotProspek,
    required this.deal,
    required this.unitTestRide,
    required this.pesertaTestRide,
    required this.jenisAktivitas,
    required this.lokasi,
    required this.jenisAktivitasDesc,
  });

  factory HeadVisitDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadVisitDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      date: json['currentDate'],
      time: json['currentTime'],
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      salesman: json['salesman'],
      unitDisplay: json['unitDisplay'],
      database: json['database'],
      hotProspek: json['hotProspek'],
      deal: json['deal'],
      unitTestRide: json['unitTestRide'],
      pesertaTestRide: json['pesertaTestRide'],
      jenisAktivitas: json['jenisAktivitas'],
      lokasi: json['lokasi'],
      jenisAktivitasDesc: json['jenisAktivitasDesc'],
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

class HeadRecruitmentDetailsModel {
  final String bsName;
  final String area;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String pic1Thumb;
  final String employeeID;
  final String eName;
  final String media;
  final String posisi;

  HeadRecruitmentDetailsModel({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.pic1Thumb,
    required this.employeeID,
    required this.eName,
    required this.media,
    required this.posisi,
  });

  factory HeadRecruitmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadRecruitmentDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      pic1Thumb: json['pic1Thumb'],
      employeeID: json['employeeID'],
      eName: json['eName'],
      media: json['media'],
      posisi: json['posisi'],
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
  final int? line;

  HeadMediaMasterModel({
    required this.mediaCode,
    required this.mediaName,
    this.line,
  });

  factory HeadMediaMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadMediaMasterModel(
      mediaCode: json['mediaCode'],
      mediaName: json['mediaName'],
      line: json.containsKey('line') ? json['line'] : null,
    );
  }
}

class HeadInterviewDetailsModel {
  final String bsName;
  final String area;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String pic1Thumb;
  final String employeeID;
  final String eName;
  final int dipanggil;
  final int datang;
  final int diterima;
  final List<HeadMediaDetailsModel> listMedia;

  HeadInterviewDetailsModel({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.pic1Thumb,
    required this.employeeID,
    required this.eName,
    required this.dipanggil,
    required this.datang,
    required this.diterima,
    required this.listMedia,
  });

  factory HeadInterviewDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadInterviewDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      pic1Thumb: json['pic1Thumb'],
      employeeID: json['employeeID'],
      eName: json['eName'],
      dipanggil: json['dipanggil'],
      datang: json['datang'],
      diterima: json['diterima'],
      listMedia: (json['listMedia'] as List)
          .map((e) => HeadMediaDetailsModel.fromJson(e))
          .toList(),
    );
  }
}

class HeadMediaDetailsModel {
  final int line;
  final int mediaCode;
  final String mediaName;
  final int qty;

  HeadMediaDetailsModel({
    required this.line,
    required this.mediaCode,
    required this.mediaName,
    required this.qty,
  });

  factory HeadMediaDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadMediaDetailsModel(
      line: json['line'],
      mediaCode: json['mediaCode'],
      mediaName: json['mediaName'],
      qty: json['qty'],
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
  final int? line;
  final String category;
  final int? target;
  final int? tm;
  final double? acv;
  final int? lm;
  final double? growth;

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
      line: json.containsKey('line') ? (json['line'] ?? 0) : null,
      category: json['category'],
      target: json['target'] ?? 0,
      tm: json['tm'] ?? 0,
      acv: json.containsKey('acv') ? (json['acv'] ?? 0.0) : null,
      lm: json['lm'] ?? 0,
      growth: json.containsKey('growth') ? (json['growth'] ?? 0.0) : null,
    );
  }
}

class HeadPaymentMasterModel {
  final int? line;
  final String payment;
  final int? tm;
  final int? lm;
  final double? growth;

  HeadPaymentMasterModel({
    required this.line,
    required this.payment,
    required this.tm,
    required this.lm,
    required this.growth,
  });

  factory HeadPaymentMasterModel.fromJson(Map<String, dynamic> json) {
    return HeadPaymentMasterModel(
      line: json.containsKey('line') ? (json['line'] ?? 0) : null,
      payment: json['payment'],
      tm: json['tm'] ?? 0,
      lm: json['lm'] ?? 0,
      growth: json.containsKey('growth') ? (json['growth'] ?? 0.0) : null,
    );
  }
}

class HeadLeasingMasterModel {
  final int? line;
  final String leasingID;
  final int? total;
  final int? terbuka;
  final int? disetujui;
  final int? ditolak;
  final double? persentase;

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
      line: json.containsKey('line') ? (json['line'] ?? 0) : null,
      leasingID: json['leasingID'],
      total: json.containsKey('total') ? (json['total'] ?? 0) : null,
      terbuka: json['terbuka'] ?? 0,
      disetujui: json['disetujui'] ?? 0,
      ditolak: json['ditolak'] ?? 0,
      persentase: json.containsKey('persentase')
          ? (json['persentase'] ?? 0.0)
          : null,
    );
  }
}

class HeadEmployeeMasterModel {
  final int? line; //
  final String employeeID;
  final String eName; //
  final String eTypeID;
  final String position; //
  final int? spk;
  final int? stu;
  final int? stuLm;

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
      line: json.containsKey('line') ? (json['line'] ?? 0) : null,
      employeeID: json['employeeID'],
      eName: json.containsKey('eName') ? json['eName'] : null,
      eTypeID: json['eTypeID'],
      position: json.containsKey('position') ? json['position'] : null,
      spk: json['spk'] ?? 0,
      stu: json['stu'] ?? 0,
      stuLm: json['stuLm'] ?? 0,
    );
  }
}

class HeadReportDetailsModel {
  final String bsName;
  final String area;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String pic1Thumb;
  final String employeeID;
  final String eName;
  final List<HeadStuCategoriesMasterModel> stuCategories;
  final List<HeadPaymentMasterModel> payment;
  final List<HeadLeasingMasterModel> leasing;
  final List<HeadEmployeeMasterModel> employee;

  HeadReportDetailsModel({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.pic1Thumb,
    required this.employeeID,
    required this.eName,
    required this.stuCategories,
    required this.payment,
    required this.leasing,
    required this.employee,
  });

  factory HeadReportDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadReportDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      pic1Thumb: json['pic1Thumb'],
      employeeID: json['employeeID'],
      eName: json['eName'],
      stuCategories: (json['stuCategory'] as List)
          .map((e) => HeadStuCategoriesMasterModel.fromJson(e))
          .toList(),
      payment: (json['payment'] as List)
          .map((e) => HeadPaymentMasterModel.fromJson(e))
          .toList(),
      leasing: (json['spkLeasing'] as List)
          .map((e) => HeadLeasingMasterModel.fromJson(e))
          .toList(),
      employee: (json['employee'] as List)
          .map((e) => HeadEmployeeMasterModel.fromJson(e))
          .toList(),
    );
  }
}
