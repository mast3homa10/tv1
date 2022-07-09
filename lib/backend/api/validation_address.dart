import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../backend/models/validation_address_model.dart';
import '../network_constants.dart';

class ValidationAddressApi {
  Future<ValidationAddressModel?> getValidation(
      {required String address, required String currencyNetwork}) async {
    http.Response response = await http.post(
        Uri.parse(baseUrl + validationAddressEndpoint),
        body: json.encode({"currency": currencyNetwork, "address": address}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body)['data']['validAddress'];

      ValidationAddressModel decodedData =
          ValidationAddressModel.fromJson(data);
      log('$decodedData');
      return decodedData;
    } else {
      log("${response.statusCode}");
    }
  }
}
