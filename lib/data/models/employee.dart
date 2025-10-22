class EmployeeModel {
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

  EmployeeModel({
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

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
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
