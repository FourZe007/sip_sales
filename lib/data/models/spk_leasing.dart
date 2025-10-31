class SpkDataModel {
  final int totalSPK;
  final int spkTerbuka;
  final int spkApprove;
  final int spkReject;
  final int satuHari;
  final int duaHari;
  final int tigaHari;
  final int lebihTigaHari;
  final List<SpkDataDetail1Model> detail1;
  final List<SpkDataDetail2Model> detail2;
  final List<SpkDataDetail3Model> detail3;

  SpkDataModel({
    required this.totalSPK,
    required this.spkTerbuka,
    required this.spkApprove,
    required this.spkReject,
    required this.satuHari,
    required this.duaHari,
    required this.tigaHari,
    required this.lebihTigaHari,
    required this.detail1,
    required this.detail2,
    required this.detail3,
  });

  factory SpkDataModel.fromJson(Map<String, dynamic> json) {
    return SpkDataModel(
      totalSPK: json['totalSPK'],
      spkTerbuka: json['spkTerbuka'],
      spkApprove: json['spkApprove'],
      spkReject: json['spkReject'],
      satuHari: json['satuHari'],
      duaHari: json['duaHari'],
      tigaHari: json['tigaHari'],
      lebihTigaHari: json['lebihTigaHari'],
      detail1: (json['detail1'] as List)
          .map((x) => SpkDataDetail1Model.fromJson(x))
          .toList(),
      detail2: (json['detail2'] as List)
          .map((x) => SpkDataDetail2Model.fromJson(x))
          .toList(),
      detail3: (json['detail3'] as List)
          .map((x) => SpkDataDetail3Model.fromJson(x))
          .toList(),
    );
  }
}

class SpkDataDetail1Model {
  final String leasingId;
  final int totalSPK;
  final int spkTerbuka;
  final int spkApprove;
  final int spkReject;
  final String urutanLeasing;

  SpkDataDetail1Model({
    required this.leasingId,
    required this.totalSPK,
    required this.spkTerbuka,
    required this.spkApprove,
    required this.spkReject,
    required this.urutanLeasing,
  });

  factory SpkDataDetail1Model.fromJson(Map<String, dynamic> json) {
    return SpkDataDetail1Model(
      leasingId: json['leasingID'],
      totalSPK: json['totalSPK'],
      spkTerbuka: json['spkTerbuka'],
      spkApprove: json['spkApprove'],
      spkReject: json['spkReject'],
      urutanLeasing: json['urutanLeasing'],
    );
  }
}

class SpkDataDetail2Model {
  final String category;
  final int totalSPK;
  final int spkTerbuka;
  final int spkApprove;
  final int spkReject;
  final String urutanCategory;

  SpkDataDetail2Model({
    required this.category,
    required this.totalSPK,
    required this.spkTerbuka,
    required this.spkApprove,
    required this.spkReject,
    required this.urutanCategory,
  });

  factory SpkDataDetail2Model.fromJson(Map<String, dynamic> json) {
    return SpkDataDetail2Model(
      category: json['category'],
      totalSPK: json['totalSPK'],
      spkTerbuka: json['spkTerbuka'],
      spkApprove: json['spkApprove'],
      spkReject: json['spkReject'],
      urutanCategory: json['urutanCategory'],
    );
  }
}

class SpkDataDetail3Model {
  final String reasonId;
  final String reasonName;
  final int qty;

  SpkDataDetail3Model({
    required this.reasonId,
    required this.reasonName,
    required this.qty,
  });

  factory SpkDataDetail3Model.fromJson(Map<String, dynamic> json) {
    return SpkDataDetail3Model(
      reasonId: json['reasonID'],
      reasonName: json['reasonName'],
      qty: json['qty'],
    );
  }
}

class SpkLeasingModel {
  final String leasingId;

  SpkLeasingModel({
    required this.leasingId,
  });

  factory SpkLeasingModel.fromJson(Map<String, dynamic> json) {
    return SpkLeasingModel(
      leasingId: json['leasingID'],
    );
  }
}

class SpkCategoryModel {
  final String category;

  SpkCategoryModel({
    required this.category,
  });

  factory SpkCategoryModel.fromJson(Map<String, dynamic> json) {
    return SpkCategoryModel(
      category: json['category'],
    );
  }
}

class SpkGrouDealerModel {
  final int order;
  final String groupName;

  SpkGrouDealerModel({
    required this.order,
    required this.groupName,
  });

  factory SpkGrouDealerModel.fromJson(Map<String, dynamic> json) {
    return SpkGrouDealerModel(
      order: json['urutan'],
      groupName: json['groupName'],
    );
  }
}

class SpkDealerModel {
  final String branch;
  final String shop;
  final String bsName;
  final String serverName;
  final String dbName;
  final String password;
  final String pt;
  final String groupName;

  SpkDealerModel({
    required this.branch,
    required this.shop,
    required this.bsName,
    required this.serverName,
    required this.dbName,
    required this.password,
    required this.pt,
    required this.groupName,
  });

  factory SpkDealerModel.fromJson(Map<String, dynamic> json) {
    return SpkDealerModel(
      branch: json['branch'],
      shop: json['shop'],
      bsName: json['bsName'],
      serverName: json['serverName'],
      dbName: json['dbName'],
      password: json['password'],
      pt: json['pt'],
      groupName: json['groupName'],
    );
  }
}
