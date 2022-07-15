class ValidationAddressModel {
  String? isValid;
  String? message;

  ValidationAddressModel({
    this.isValid = '',
    this.message = '',
  });

  ValidationAddressModel.fromJson(json)
      : isValid = json['isValid'].toString(),
        message = json['message'];

  @override
  toString() => "{{isValid: $isValid }, {message: $message }}";
}
