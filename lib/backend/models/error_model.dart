class ErrorModel {
  String? error;
  String? message;

  ErrorModel({this.error, this.message});

  ErrorModel.fromJson(json)
      : error = json["error"],
        message = json["message"];

  @override
  toString() => "{{error: $error}, {message: $message}}";
}
