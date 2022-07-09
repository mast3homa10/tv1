class ValidationAddressModel {
  String? isValid;
  String? message;

  ValidationAddressModel({
    this.isValid = 'false',
    this.message = 'test',
  });

  ValidationAddressModel.fromJson(json)
      : isValid = json['isValid'].toString(),
        message = json['message'];

  @override
  toString() => "\n {isValid: $isValid }{message: $message ...},,";
}
