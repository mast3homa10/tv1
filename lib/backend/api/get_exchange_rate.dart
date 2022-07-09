import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../backend/models/get_exchange_rate_model.dart';
import '../network_constants.dart';

class GetExchangeRateApi {
  Future<GetExchangeRateModel?> getExchangeRate({
    String? sourceCurrency,
    String? destinationCurrency,
    String? type,
    String? sourceNetwork,
    String? destinationNetwork,
  }) async {
    http.Response response = await http.post(
        Uri.parse(baseUrl + getExchangeRateEndpoint),
        body: json.encode({
          "sourceCurrency": sourceCurrency,
          "destinationCurrency": destinationCurrency,
          "type": type,
          "sourceNetwork": sourceNetwork,
          "destinationNetwork": destinationNetwork
        }),
        headers: {
          'x-changenow-api-key': '{{free-api-key}}',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body)['data']['exchangeRate'];

      var decodedData = GetExchangeRateModel.fromJson(data);
      return decodedData;
    } else {
      log("${response.statusCode}");
    }
  }
}
