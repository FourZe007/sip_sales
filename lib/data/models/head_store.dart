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
      lat: json['lat'],
      lng: json['lng'],
      activityId: json['activityID'],
      activityName: json['activityName'],
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
