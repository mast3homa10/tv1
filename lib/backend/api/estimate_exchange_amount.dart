import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../../backend/models/estimate_exchange_amount_model.dart';
import '../network_constants.dart';

class EstimateExchangeAmountApi {
  Future<EstimateExchangeAmountModel?> getAmount({
    String? sourceCurrency,
    String? destinationCurrency,
    String? directionOfExchangeFlow = "direct",
    String? type,
    double? sourceAmount,
    String? sourceNetwork,
    String? destinationNetwork,
  }) async {
    try {
      http.Response response =
          await http.post(Uri.parse(baseUrl + esimatExchangeAmountEndpoint),
              body: json.encode({
                "sourceCurrency": sourceCurrency,
                "destinationCurrency": destinationCurrency,
                "type": type,
                "directionOfExchangeFlow": directionOfExchangeFlow,
                "sourceAmount": sourceAmount,
                "sourceNetwork": sourceNetwork,
                "destinationNetwork": destinationNetwork
              }),
              headers: {'Content-Type': 'application/json'});

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
