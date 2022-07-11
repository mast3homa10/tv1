import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../../backend/models/estimate_exchange_amount_model.dart';
import '../network_constants.dart';

class EstimateExchangeAmountApi {
  Future<EstimateExchangeAmountModel?> getAmount({
    bool isForReverse = false,
    String? sourceCurrency,
    String? destinationCurrency,
    String? directionOfExchangeFlow = "direct",
    String? type,
    double? sourceAmount,
    String? sourceNetwork,
    String? destinationNetwork,
    double? destinationAmount,
  }) async {
    try {
      http.Response response;
      if (isForReverse) {
        response =
            await http.post(Uri.parse(baseUrl + esimatExchangeAmountEndpoint),
                body: json.encode({
                  "sourceCurrency": sourceCurrency,
                  "destinationCurrency": destinationCurrency,
                  "type": type,
                  "directionOfExchangeFlow": directionOfExchangeFlow,
                  "sourceNetwork": sourceNetwork,
                  "destinationNetwork": destinationNetwork,
                  "destinationAmount": destinationAmount,
                }),
                headers: {'Content-Type': 'application/json'});
      } else {
        response =
            await http.post(Uri.parse(baseUrl + esimatExchangeAmountEndpoint),
                body: json.encode({
                  "sourceCurrency": sourceCurrency,
                  "destinationCurrency": destinationCurrency,
                  "type": type,
                  "directionOfExchangeFlow": directionOfExchangeFlow,
                  "sourceAmount": sourceAmount,
                  "sourceNetwork": sourceNetwork,
                  "destinationNetwork": destinationNetwork,
                }),
                headers: {'Content-Type': 'application/json'});
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            json.decode(response.body)['data']['estimateExchangeAmount'];

        var decodedData = EstimateExchangeAmountModel().fromJson(data);
        log('$decodedData');
        return decodedData;
      } else {
        log("${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("$e");
      return null;
    }
  }
}
