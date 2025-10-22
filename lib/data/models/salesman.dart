import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';

class SalesmanAttendanceModel {
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

  SalesmanAttendanceModel({
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

  factory SalesmanAttendanceModel.fromJson(Map<String, dynamic> json) {
    return SalesmanAttendanceModel(
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

class SalesActsModel {
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

  SalesActsModel({
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

  factory SalesActsModel.fromJson(Map<String, dynamic> json) {
    return SalesActsModel(
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
    );
  }
}
