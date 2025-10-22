abstract class HeadStoreEvent {
  final String employeeID;
  final String activityID;

  HeadStoreEvent({
    required this.employeeID,
    required this.activityID,
  });
}

class LoadHeadDashboard extends HeadStoreEvent {
  final String date;

  LoadHeadDashboard({
    required super.employeeID,
    super.activityID = '',
    required this.date,
  });
}

class LoadHeadActs extends HeadStoreEvent {
  final String date;

  LoadHeadActs({
    required super.employeeID,
    super.activityID = '',
    required this.date,
  });
}

class LoadHeadActsDetail extends HeadStoreEvent {
  final String date;

  LoadHeadActsDetail({
    required super.employeeID,
    required this.date,
    required super.activityID,
  });
}

class InsertHeadActs extends HeadStoreEvent {
  final String branch;
  final String shop;
  final String date;
  final String time;
  final double lat;
  final double lng;
  final String desc;
  final String image;

  InsertHeadActs({
    required super.employeeID,
    required super.activityID,
    required this.branch,
    required this.shop,
    required this.date,
    required this.time,
    required this.lat,
    required this.lng,
    required this.desc,
    required this.image,
  });
}

class DeleteHeadActs extends HeadStoreEvent {
  final String date;

  DeleteHeadActs({
    required super.employeeID,
    required super.activityID,
    required this.date,
  });
}
