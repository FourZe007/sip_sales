class RadiusCheckerModel {
  final String isClose;
  final String eventPhoto;
  final String eventPhotoThumb;
  final String eventPhotoUrl;
  final String gMapUrl;

  RadiusCheckerModel({
    required this.isClose,
    required this.eventPhoto,
    required this.eventPhotoThumb,
    required this.eventPhotoUrl,
    required this.gMapUrl,
  });

  factory RadiusCheckerModel.fromJson(Map<String, dynamic> json) {
    return RadiusCheckerModel(
      isClose: json['Result'],
      eventPhoto: json['EventPhoto'],
      eventPhotoThumb: json['EventPhotoThumb'],
      eventPhotoUrl: json['EventPhotoUrl'],
      gMapUrl: json['GMapUrl'],
    );
  }
}
