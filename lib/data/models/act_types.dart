class HeadActTypesModel {
  String activityID;
  String activityName;
  String activityTemplate;

  HeadActTypesModel({
    required this.activityID,
    required this.activityName,
    required this.activityTemplate,
  });

  factory HeadActTypesModel.fromJson(Map<String, dynamic> json) {
    return HeadActTypesModel(
      activityID: json['activityID'],
      activityName: json['activityName'],
      activityTemplate: json['descriptionTemplate'],
    );
  }
}
