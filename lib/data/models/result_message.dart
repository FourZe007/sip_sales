class ResultMessageModel {
  String resultMessage;

  ResultMessageModel({
    required this.resultMessage,
  });

  factory ResultMessageModel.fromJson(Map<String, dynamic> json) {
    return ResultMessageModel(
      resultMessage: json['resultMessage'],
    );
  }
}
