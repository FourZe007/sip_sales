class ModelUser {
  int flag;
  String memo;
  String employeeID;
  String employeeName;
  String branch;
  String shop;
  String bsName;
  String locationID;
  String locationName;
  double latitude;
  double longitude;
  String profilePicture;
  int code;

  ModelUser({
    required this.flag,
    required this.memo,
    required this.employeeID,
    required this.employeeName,
    required this.branch,
    required this.shop,
    required this.bsName,
    required this.locationID,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.profilePicture,
    required this.code,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      flag: json['Flag'],
      memo: json['Memo'],
      employeeID: json['EmployeeID'],
      employeeName: json['EName'],
      branch: json['Branch'],
      shop: json['Shop'],
      bsName: json['BSName'],
      locationID: json['LocationID'],
      locationName: json['LocationName'],
      latitude: json['Lat'],
      longitude: json['Lng'],
      profilePicture: json['PhotoThumb'],
      code: json['Kode'],
    );
  }
}

class ModelAttendanceHistory {
  String employeeID;
  String employeeName;
  String branch;
  String shop;
  String branchName;
  String shopName;
  String locationID;
  String locationName;
  double latitude;
  double longitude;
  String date;
  String checkIn;
  String checkOut;
  String absentLocation;
  double userLat;
  double userLng;
  String eventName;
  String eventPhoto;
  String eventThumbnail;

  ModelAttendanceHistory({
    required this.employeeID,
    required this.employeeName,
    required this.branch,
    required this.shop,
    required this.branchName,
    required this.shopName,
    required this.locationID,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.absentLocation,
    required this.userLat,
    required this.userLng,
    required this.eventName,
    required this.eventPhoto,
    required this.eventThumbnail,
  });

  factory ModelAttendanceHistory.fromJson(Map<String, dynamic> json) {
    return ModelAttendanceHistory(
      employeeID: json['EmployeeID'],
      employeeName: json['EName'],
      branch: json['Branch'],
      shop: json['Shop'],
      branchName: json['BName'],
      shopName: json['BSName'],
      locationID: json['LocationID'],
      locationName: json['LocationName'],
      latitude: json['Lat'],
      longitude: json['Lng'],
      date: json['Date_'],
      checkIn: json['CheckIn'],
      checkOut: json['CheckOut'],
      absentLocation: json['LokasiAbsen'],
      userLat: json['CLat'],
      userLng: json['CLng'],
      eventName: json['EventName'],
      eventPhoto: json['EventPhoto'],
      eventThumbnail: json['EventPhotoThumb'],
    );
  }
}

// "qtyLM": 1,
// "qtyTM": 2,
// "persenSPK": 100.0000,
// "qtySJLM": 1,
// "qtySJTM": 0,
// "persenSJ": -100.0000,
// "qtyPLM": 25,
// "qtyPTM": 38,
// "persenProspek": 52.0000
class SalesDashboardModel {
  int qtyLM;
  int qtyTM;
  double spk;
  int qtySJLM;
  int qtySJTM;
  double delivery;
  int qtyLTM;
  int qtyPTM;
  double prospect;

  SalesDashboardModel({
    required this.qtyLM,
    required this.qtyTM,
    required this.spk,
    required this.qtySJLM,
    required this.qtySJTM,
    required this.delivery,
    required this.qtyLTM,
    required this.qtyPTM,
    required this.prospect,
  });

  factory SalesDashboardModel.fromJson(Map<String, dynamic> json) {
    return SalesDashboardModel(
      qtyLM: json['qtyLM'],
      qtyTM: json['qtyTM'],
      spk: json['persenSPK'],
      qtySJLM: json['qtySJLM'],
      qtySJTM: json['qtySJTM'],
      delivery: json['persenSJ'],
      qtyLTM: json['qtyPLM'],
      qtyPTM: json['qtyPTM'],
      prospect: json['persenProspek'],
    );
  }
}

class ModelResultMessage {
  String resultMessage;

  ModelResultMessage({
    required this.resultMessage,
  });

  factory ModelResultMessage.fromJson(Map<String, dynamic> json) {
    return ModelResultMessage(
      resultMessage: json['ResultMessage'],
    );
  }
}

class ModelResultMessage2 {
  String resultMessage;

  ModelResultMessage2({
    required this.resultMessage,
  });

  factory ModelResultMessage2.fromJson(Map<String, dynamic> json) {
    return ModelResultMessage2(
      resultMessage: json['resultMessage'],
    );
  }
}

class ModelWithinRadius {
  double longitude1;
  double latitude1;
  double longitude2;
  double latitude2;
  String timeDifference;

  ModelWithinRadius({
    required this.longitude1,
    required this.latitude1,
    required this.longitude2,
    required this.latitude2,
    required this.timeDifference,
  });
}

class ModelCoordinate {
  double longitude;
  double latitude;
  String time;

  ModelCoordinate({
    required this.longitude,
    required this.latitude,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'lng': longitude,
        'lat': latitude,
        'time': time,
      };

  factory ModelCoordinate.fromJson(Map<String, dynamic> json) {
    return ModelCoordinate(
      longitude: json['lng'] as double,
      latitude: json['lat'] as double,
      time: json['time'] as String,
    );
  }
}

class ModelStateIndex {
  bool state;
  int index;

  ModelStateIndex({
    required this.state,
    required this.index,
  });
}

class ModelActivityRoute {
  String startTime;
  String endTime;
  dynamic lat;
  dynamic lng;
  int duration;
  double distance;
  int? isActAvailable;
  List<dynamic> detail;

  ModelActivityRoute({
    required this.startTime,
    required this.endTime,
    required this.lat,
    required this.lng,
    required this.duration,
    required this.distance,
    this.isActAvailable,
    required this.detail,
  });

  factory ModelActivityRoute.fromJson(Map<String, dynamic> json) {
    return ModelActivityRoute(
      startTime: json['startTime'],
      endTime: json['endTime'],
      lat: (json['lat'] is double) ? json['lat'] : double.parse(json['lat']),
      lng: (json['lng'] is double) ? json['lng'] : double.parse(json['lng']),
      duration: json['duration'],
      distance: json['distance'],
      isActAvailable: json['adaAktivitas'],
      detail: (json['detail'] as List)
          .map((dynamic data) => ModelActivityRouteDetails.fromJson(data))
          .toList(),
    );
  }
}

class ModelActivityRouteDetails {
  String actId;
  String actName;
  String actDesc;
  String contactName;
  String contactNumber;
  String pic1;
  String pic2;
  String pic3;
  String pic4;
  String pic5;

  ModelActivityRouteDetails({
    required this.actId,
    required this.actName,
    required this.actDesc,
    required this.contactName,
    required this.contactNumber,
    required this.pic1,
    required this.pic2,
    required this.pic3,
    required this.pic4,
    required this.pic5,
  });

  Map<String, dynamic> toJson() => {
        'activityID': actId,
        'activityName': actName,
        'activityDescription': actDesc,
        'contactName': contactName,
        'contactPhoneNo': contactNumber,
        'pic1': pic1,
        'pic2': pic2,
        'pic3': pic3,
        'pic4': pic4,
        'pic5': pic5,
      };

  factory ModelActivityRouteDetails.fromJson(Map<String, dynamic> json) {
    return ModelActivityRouteDetails(
      actId: json['activityID'],
      actName: json['activityName'],
      actDesc: json['activityDescription'],
      contactName: json['contactName'],
      contactNumber: json['contactPhoneNo'],
      pic1: json['pic1'],
      pic2: json['pic2'],
      pic3: json['pic3'],
      pic4: json['pic4'],
      pic5: json['pic5'],
    );
  }
}

class ModelImage {
  String imageDir;
  bool isSelected;

  ModelImage({
    required this.imageDir,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() => {
        'imageDir': imageDir,
        'isSelected': isSelected,
      };

  factory ModelImage.fromJson(Map<String, dynamic> json) {
    return ModelImage(
      imageDir: json['imageDir'] as String,
      isSelected: json['isSelected'] as bool,
    );
  }
}

class ModelDetailsProcessing {
  List<ModelActivityRouteDetails> routeDetails;
  List<List<ModelImage>> images;

  ModelDetailsProcessing({
    required this.routeDetails,
    required this.images,
  });
}

// Model for Sales and Shop Manager
class ModelActivities {
  String activityID;
  String activityName;
  String activityTemplate;

  ModelActivities({
    required this.activityID,
    required this.activityName,
    required this.activityTemplate,
  });

  factory ModelActivities.fromJson(Map<String, dynamic> json) {
    return ModelActivities(
      activityID: json['activityID'],
      activityName: json['activityName'],
      activityTemplate: json['descriptionTemplate'],
    );
  }
}

class ModelNewActivityDetails {
  List<ModelActivities> activities;
  List<String> image;

  ModelNewActivityDetails({
    required this.activities,
    required this.image,
  });
}

// Model for Sales Activities
class ModelSalesActivities {
  String date;
  String startTime;
  String endTime;
  double lat;
  double lng;
  int duration;
  String activityID;
  String activityName;
  String activityDescription;
  String contactName;
  String contactPhoneNo;
  String pic1;
  String pic2;
  String pic3;
  String pic4;
  String pic5;

  ModelSalesActivities({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.lat,
    required this.lng,
    required this.duration,
    required this.activityID,
    required this.activityName,
    required this.activityDescription,
    required this.contactName,
    required this.contactPhoneNo,
    required this.pic1,
    required this.pic2,
    required this.pic3,
    required this.pic4,
    required this.pic5,
  });

  factory ModelSalesActivities.fromJson(Map<String, dynamic> json) {
    return ModelSalesActivities(
      date: json['currentDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      lat: json['lat'],
      lng: json['lng'],
      duration: json['duration'],
      activityID: json['activityID'],
      activityName: json['activityName'],
      activityDescription: json['activityDescription'],
      contactName: json['contactName'],
      contactPhoneNo: json['contactPhoneNo'],
      pic1: json['pic1'],
      pic2: json['pic2'],
      pic3: json['pic3'],
      pic4: json['pic4'],
      pic5: json['pic5'],
    );
  }
}

// Model for Shop Manager Activities
class ModelManagerActivities {
  // "employeeID": "2401/003346",
  // "eName": "HARKA WICAKSONO",
  // "branch": "01",
  // "shop": "01",
  // "bsName": "GRAHA RSSM",
  // "currentDate": "2024-08-27",
  // "currentTime": "08:42:34",
  // "lat": -7.2660353,
  // "lng": 112.7413002,
  // "activityID": "00",
  // "activityName": "MORNING BRIEFING"
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
  // String activityDescription;
  // String pic1;

  ModelManagerActivities({
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
    // required this.activityDescription,
    // required this.pic1,
  });

  factory ModelManagerActivities.fromJson(Map<String, dynamic> json) {
    return ModelManagerActivities(
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      branch: json['branch'],
      shopId: json['shop'],
      shopName: json['bsName'],
      date: json['currentDate'],
      time: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      activityId: json['activityID'],
      activityName: json['activityName'],
      // activityDescription: json['activityDescription'],
      // pic1: json['pic1'],
    );
  }
}

class ModelManagerActivityDetails {
  String time;
  double lat;
  double lng;
  String actId;
  String actDesc;
  String pic1;

  ModelManagerActivityDetails({
    required this.time,
    required this.lat,
    required this.lng,
    required this.actId,
    required this.actDesc,
    required this.pic1,
  });

  factory ModelManagerActivityDetails.fromJson(Map<String, dynamic> json) {
    return ModelManagerActivityDetails(
      time: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      actId: json['activityID'],
      actDesc: json['activityDescription'],
      pic1: json['pic1'],
    );
  }
}

class SalesmanDashboardModel {
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
  final List<CategoryModel> categoryList;
  final List<LeasingModel> leasingList;
  final List<DailyModel> dailyList;
  final List<ProspekTypeModel> prospekTypeList;

  SalesmanDashboardModel({
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
    required this.categoryList,
    required this.leasingList,
    required this.dailyList,
    required this.prospekTypeList,
  });

  factory SalesmanDashboardModel.fromJson(Map<String, dynamic> json) {
    return SalesmanDashboardModel(
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
      categoryList: json['category']
          .map<CategoryModel>((data) => CategoryModel.fromJson(data))
          .toList(),
      leasingList: json['leasing']
          .map<LeasingModel>((data) => LeasingModel.fromJson(data))
          .toList(),
      dailyList: json['daily']
          .map<DailyModel>((data) => DailyModel.fromJson(data))
          .toList(),
      prospekTypeList: json['prospekType']
          .map<ProspekTypeModel>((data) => ProspekTypeModel.fromJson(data))
          .toList(),
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

class FollowUpDashboardModel {
  final int totalProspect;
  final int newProspect;
  final int prosesFU;
  final int closing;
  final int batal;
  final int belumFU;
  final dynamic persenNew;
  final List<FollowUpDashboardDetailModel> detail;

  FollowUpDashboardModel({
    required this.totalProspect,
    required this.newProspect,
    required this.prosesFU,
    required this.closing,
    required this.batal,
    required this.belumFU,
    required this.persenNew,
    required this.detail,
  });

  factory FollowUpDashboardModel.fromJson(Map<String, dynamic> json) {
    return FollowUpDashboardModel(
      totalProspect: json['totalProspect'],
      newProspect: json['newProspect'],
      prosesFU: json['prosesFU'],
      closing: json['closing'],
      batal: json['batal'],
      belumFU: json['belumFU'],
      persenNew: json['persenNew'] is double
          ? (json['persenNew'] as double)
          : (json['persenNew'] as int).toDouble(),
      detail: json['detail']
          .map<FollowUpDashboardDetailModel>(
              (data) => FollowUpDashboardDetailModel.fromJson(data))
          .toList(),
    );
  }
}

class FollowUpDashboardDetailModel {
  final String prospectDate;
  final String prospectDateFormat;
  final String customerName;
  final String customerStatus;
  final String mobilePhone;
  final String fuStatus;
  final String lastFUDate;
  final String lastFUMemo;
  final String nextFUDate;

  FollowUpDashboardDetailModel({
    required this.prospectDate,
    required this.prospectDateFormat,
    required this.customerName,
    required this.customerStatus,
    required this.mobilePhone,
    required this.fuStatus,
    required this.lastFUDate,
    required this.lastFUMemo,
    required this.nextFUDate,
  });

  factory FollowUpDashboardDetailModel.fromJson(Map<String, dynamic> json) {
    return FollowUpDashboardDetailModel(
      prospectDate: json['prospectDate'],
      prospectDateFormat: json['prospectDateFormat'],
      customerName: json['customerName'],
      customerStatus: json['customerStatus'],
      mobilePhone: json['mobilePhone'],
      fuStatus: json['fuStatus'],
      lastFUDate: json['lastFUDate'],
      lastFUMemo: json['lastFUMemo'],
      nextFUDate: json['nextFUDate'],
    );
  }
}

class FollowUpDealDashboardModel {
  final int totalProspect;
  final int newProspect;
  final int prosesFU;
  final int closing;
  final int batal;
  final int belumFU;
  final dynamic persenNew;
  final List<FollowUpDealDashboardDetailModel> detail;

  FollowUpDealDashboardModel({
    required this.totalProspect,
    required this.newProspect,
    required this.prosesFU,
    required this.closing,
    required this.batal,
    required this.belumFU,
    required this.persenNew,
    required this.detail,
  });

  factory FollowUpDealDashboardModel.fromJson(Map<String, dynamic> json) {
    return FollowUpDealDashboardModel(
      totalProspect: json['totalProspect'],
      newProspect: json['newProspect'],
      prosesFU: json['prosesFU'],
      closing: json['closing'],
      batal: json['batal'],
      belumFU: json['belumFU'],
      persenNew: json['persenNew'] is double
          ? (json['persenNew'] as double)
          : (json['persenNew'] as int).toDouble(),
      detail: json['detail']
          .map<FollowUpDealDashboardDetailModel>(
              (data) => FollowUpDealDashboardDetailModel.fromJson(data))
          .toList(),
    );
  }
}

class FollowUpDealDashboardDetailModel {
  final String prospectDate;
  final String prospectDateFormat;
  final String customerName;
  final String mobilePhone;
  final String noSPK;
  final String tglSPK;
  final String pembayaran;
  final String noSJ;
  final String tglSJ;
  final String chasisNo;

  FollowUpDealDashboardDetailModel({
    required this.prospectDate,
    required this.prospectDateFormat,
    required this.customerName,
    required this.mobilePhone,
    required this.noSPK,
    required this.tglSPK,
    required this.pembayaran,
    required this.noSJ,
    required this.tglSJ,
    required this.chasisNo,
  });

  factory FollowUpDealDashboardDetailModel.fromJson(Map<String, dynamic> json) {
    return FollowUpDealDashboardDetailModel(
      prospectDate: json['prospectDate'],
      prospectDateFormat: json['prospectDateFormat'],
      customerName: json['customerName'],
      mobilePhone: json['mobilePhone'],
      noSPK: json['noSPK'],
      tglSPK: json['tglSPK'],
      pembayaran: json['pembayaran'],
      noSJ: json['noSJ'],
      tglSJ: json['tglSJ'],
      chasisNo: json['chasisNo'],
    );
  }
}

class UpdateFollowUpDashboardModel {
  final String customerName;
  final String prospectDate;
  final String customerStatus;
  final String modelName;
  final String mobilePhone;
  final String prospectStatus;
  final String firstFUDate;
  final List<UpdateFollowupDashboardDetails> followup;

  UpdateFollowUpDashboardModel({
    required this.customerName,
    required this.prospectDate,
    required this.customerStatus,
    required this.modelName,
    required this.mobilePhone,
    required this.prospectStatus,
    required this.firstFUDate,
    required this.followup,
  });

  factory UpdateFollowUpDashboardModel.fromJson(Map<String, dynamic> json) {
    return UpdateFollowUpDashboardModel(
      customerName: json['customerName'],
      prospectDate: json['prospectDate'],
      customerStatus: json['customerStatus'],
      modelName: json['modelName'],
      mobilePhone: json['mobilePhone'],
      prospectStatus: json['prospectStatus'],
      firstFUDate: json['firstFUDate'],
      followup: json['followUp']
          .map<UpdateFollowupDashboardDetails>(
              (data) => UpdateFollowupDashboardDetails.fromJson(data))
          .toList(),
    );
  }

  UpdateFollowUpDashboardModel copyWith({
    String? customerName,
    String? prospectDate,
    String? customerStatus,
    String? modelName,
    String? mobilePhone,
    String? prospectStatus,
    String? firstFUDate,
    List<UpdateFollowupDashboardDetails>? followup,
  }) {
    return UpdateFollowUpDashboardModel(
      customerName: customerName ?? this.customerName,
      prospectDate: prospectDate ?? this.prospectDate,
      customerStatus: customerStatus ?? this.customerStatus,
      modelName: modelName ?? this.modelName,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      prospectStatus: prospectStatus ?? this.prospectStatus,
      firstFUDate: firstFUDate ?? this.firstFUDate,
      followup: followup ?? List.from(this.followup),
    );
  }
}

class UpdateFollowupDashboardDetails {
  final int line;
  final String fuDate;
  final String fuResult;
  final String fuMemo;
  final String nextFUDate;

  UpdateFollowupDashboardDetails({
    required this.line,
    required this.fuDate,
    required this.fuResult,
    required this.fuMemo,
    required this.nextFUDate,
  });

  factory UpdateFollowupDashboardDetails.fromJson(Map<String, dynamic> json) {
    return UpdateFollowupDashboardDetails(
      line: json['line'],
      fuDate: json['fuDate'],
      fuResult: json['fuResult'],
      fuMemo: json['fuMemo'],
      nextFUDate: json['nextFUDate'],
    );
  }

  UpdateFollowupDashboardDetails copyWith({
    String? fuDate,
    String? fuResult,
    String? fuMemo,
    String? nextFUDate,
    int? line,
  }) {
    return UpdateFollowupDashboardDetails(
      fuDate: fuDate ?? this.fuDate,
      fuResult: fuResult ?? this.fuResult,
      fuMemo: fuMemo ?? this.fuMemo,
      nextFUDate: nextFUDate ?? this.nextFUDate,
      line: line ?? this.line,
    );
  }
}
