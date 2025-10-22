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
      detail: (json['detail'] as List)
          .map<FollowUpDashboardDetailModel>(
            (data) => FollowUpDashboardDetailModel.fromJson(data),
          )
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
  final int lineNo;

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
    required this.lineNo,
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
      lineNo: json['urutan'],
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
      detail: (json['detail'] as List)
          .map<FollowUpDealDashboardDetailModel>(
            (data) => FollowUpDealDashboardDetailModel.fromJson(data),
          )
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
