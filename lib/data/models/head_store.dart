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
  // String img;

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
    // required this.img,
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
      // img: json['pic1'],
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

// ~:New:~
class HeadBriefingCreationModel {
  final String mode;
  final String desc;

  HeadBriefingCreationModel(this.mode, this.desc);
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
      img: json['pic1Thumb'],
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

class HeadVisitCreationModel {
  final String mode;
  final String branch;
  final String shop;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String activityType;
  final String location;
  final int salesman;
  final String unitDisplay;
  final int database;
  final int hotProspek;
  final int deal;
  final String unitTestRide;
  final int participantsTestRide;
  final String pic1;
  final String employeeId;

  HeadVisitCreationModel({
    required this.mode,
    required this.branch,
    required this.shop,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.activityType,
    required this.location,
    required this.salesman,
    required this.unitDisplay,
    required this.database,
    required this.hotProspek,
    required this.deal,
    required this.unitTestRide,
    required this.participantsTestRide,
    required this.pic1,
    required this.employeeId,
  });
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
  final double lat;
  final double lng;
  final String jenisAktivitas;
  final String lokasi;
  final int salesman;
  final String unitDisplay;
  final int database;
  final int hotProspek;
  final int deal;
  final String unitTestRide;
  final int pesertaTestRide;
  final String employeeId;
  final String employeeName;
  final String img;

  HeadVisitDetailsModel({
    required this.bsName,
    required this.area,
    required this.date,
    required this.time,
    required this.lat,
    required this.lng,
    required this.jenisAktivitas,
    required this.lokasi,
    required this.salesman,
    required this.unitDisplay,
    required this.database,
    required this.hotProspek,
    required this.deal,
    required this.unitTestRide,
    required this.pesertaTestRide,
    required this.employeeId,
    required this.employeeName,
    required this.img,
  });

  factory HeadVisitDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadVisitDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      date: json['currentDate'],
      time: json['currentTime'],
      lat: (json['lat'] is int ? json['lat'].toDouble() : json['lat']),
      lng: (json['lng'] is int ? json['lng'].toDouble() : json['lng']),
      jenisAktivitas: json['jenisAktivitas'],
      lokasi: json['lokasi'],
      salesman: json['salesman'],
      unitDisplay: json['unitDisplay'],
      database: json['database'],
      hotProspek: json['hotProspek'],
      deal: json['deal'],
      unitTestRide: json['unitTestRide'],
      pesertaTestRide: json['pesertaTestRide'],
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      img: json['pic1Thumb'],
    );
  }
}

class HeadRecruitmentCreationModel {
  final String mode;
  final String branch;
  final String shop;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String media;
  final String posisi;
  final String pic1;
  final String employeeID;

  HeadRecruitmentCreationModel({
    required this.mode,
    required this.branch,
    required this.shop,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.media,
    required this.posisi,
    required this.pic1,
    required this.employeeID,
  });
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
  final String date;
  final String time;
  final double lat;
  final double lng;
  final String img;
  final String employeeID;
  final String eName;
  final String media;
  final String posisi;

  HeadRecruitmentDetailsModel({
    required this.bsName,
    required this.area,
    required this.date,
    required this.time,
    required this.lat,
    required this.lng,
    required this.img,
    required this.employeeID,
    required this.eName,
    required this.media,
    required this.posisi,
  });

  factory HeadRecruitmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadRecruitmentDetailsModel(
      bsName: json['bsName'],
      area: json['area'],
      date: json['currentDate'],
      time: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      img: json['pic1Thumb'],
      employeeID: json['employeeID'],
      eName: json['eName'],
      media: json['media'],
      posisi: json['posisi'],
    );
  }
}

class HeadInterviewCreationModel {
  final String mode;
  final String branch;
  final String shop;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final int dipanggil;
  final int datang;
  final int diterima;
  final String pic1;
  final String employeeID;
  final List<HeadMediaMasterModel> listMedia;

  HeadInterviewCreationModel({
    required this.mode,
    required this.branch,
    required this.shop,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.dipanggil,
    required this.datang,
    required this.diterima,
    required this.pic1,
    required this.employeeID,
    required this.listMedia,
  });
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
  final String img;
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
    required this.img,
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
      img: json['pic1Thumb'],
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
  final int? line;
  final int mediaCode;
  final String? mediaName;
  final int qty;

  HeadMediaDetailsModel({
    this.line = 0,
    required this.mediaCode,
    this.mediaName = '',
    required this.qty,
  });

  factory HeadMediaDetailsModel.fromJson(Map<String, dynamic> json) {
    return HeadMediaDetailsModel(
      line: json.containsKey('line') ? json['line'] : null,
      mediaCode: json['mediaCode'],
      mediaName: json['mediaName'] ?? '',
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaCode': mediaCode,
      'mediaName': mediaName,
      'qty': qty,
    };
  }
}

class HeadReportCreationModel {
  final String mode;
  final String branch;
  final String shop;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String pic1;
  final String employeeID;
  final List<HeadStuCategoriesMasterModel> listCategory;
  final List<HeadPaymentMasterModel> listPayment;
  final List<HeadLeasingMasterModel> listLeasing;
  final List<HeadEmployeeMasterModel> listEmployee;

  HeadReportCreationModel({
    required this.mode,
    required this.branch,
    required this.shop,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.pic1,
    required this.employeeID,
    required this.listCategory,
    required this.listPayment,
    required this.listLeasing,
    required this.listEmployee,
  });
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
  int? target;
  int? tm;
  final double? acv;
  int? lm;
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

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'target': target,
      'tm': tm,
      'acv': acv,
      'lm': lm,
      'growth': growth,
    };
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

  HeadPaymentMasterModel copyWith({
    int? line,
    String? payment,
    int? tm,
    int? lm,
    double? growth,
  }) {
    return HeadPaymentMasterModel(
      line: line ?? this.line,
      payment: payment ?? this.payment,
      tm: tm ?? this.tm,
      lm: lm ?? this.lm,
      growth: growth ?? this.growth,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment': payment,
      'tm': tm,
      'lm': lm,
      'growth': growth,
    };
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

  HeadLeasingMasterModel copyWith({
    int? line,
    String? leasingID,
    int? total,
    int? terbuka,
    int? disetujui,
    int? ditolak,
    double? persentase,
  }) {
    return HeadLeasingMasterModel(
      line: line ?? this.line,
      leasingID: leasingID ?? this.leasingID,
      total: total ?? this.total,
      terbuka: terbuka ?? this.terbuka,
      disetujui: disetujui ?? this.disetujui,
      ditolak: ditolak ?? this.ditolak,
      persentase: persentase ?? this.persentase,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leasingID': leasingID,
      'total': total,
      'terbuka': terbuka,
      'disetujui': disetujui,
      'ditolak': ditolak,
      'persentase': persentase,
    };
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

  // Add a copyWith method for easier immutable updates
  HeadEmployeeMasterModel copyWith({
    int? line,
    String? employeeId,
    String? employeeName,
    String? typeId,
    String? position,
    int? spk,
    int? stu,
    int? stuLm,
  }) {
    return HeadEmployeeMasterModel(
      line: line ?? this.line,
      employeeID: employeeId ?? employeeID,
      eName: employeeName ?? eName,
      eTypeID: typeId ?? eTypeID,
      position: position ?? this.position,
      spk: spk ?? this.spk,
      stu: stu ?? this.stu,
      stuLm: stuLm ?? this.stuLm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeID': employeeID,
      'eName': eName,
      'eTypeID': eTypeID,
      'position': position,
      'spk': spk,
      'stu': stu,
      'stuLm': stuLm,
    };
  }
}

class HeadReportDetailsModel {
  final String bsName;
  final String area;
  final String currentDate;
  final String currentTime;
  final double lat;
  final double lng;
  final String img;
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
    required this.img,
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
      img: json['pic1Thumb'],
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
