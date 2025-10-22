class ResultMessageModel2 {
  String resultMessage;

  ResultMessageModel2({
    required this.resultMessage,
  });

  factory ResultMessageModel2.fromJson(Map<String, dynamic> json) {
    return ResultMessageModel2(
      resultMessage: json['ResultMessage'],
    );
  }
}
