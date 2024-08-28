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
  String locationID;
  String locationName;
  double latitude;
  double longitude;
  String date;
  String checkIn;
  String checkOut;

  ModelAttendanceHistory({
    required this.employeeID,
    required this.employeeName,
    required this.branch,
    required this.shop,
    required this.branchName,
    required this.locationID,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.checkIn,
    required this.checkOut,
  });

  factory ModelAttendanceHistory.fromJson(Map<String, dynamic> json) {
    return ModelAttendanceHistory(
      employeeID: json['EmployeeID'],
      employeeName: json['EName'],
      branch: json['Branch'],
      shop: json['Shop'],
      branchName: json['BSName'],
      locationID: json['LocationID'],
      locationName: json['LocationName'],
      latitude: json['Lat'],
      longitude: json['Lng'],
      date: json['Date_'],
      checkIn: json['CheckIn'],
      checkOut: json['CheckOut'],
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
      detail: json['detail']
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
