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
      followup: (json['followUp'] as List)
          .map<UpdateFollowupDashboardDetails>(
            (data) => UpdateFollowupDashboardDetails.fromJson(data),
          )
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
