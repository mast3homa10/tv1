import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../backend/models/get_transaction_status_model.dart';
import '../network_constants.dart';

class GetTransactionStatusApi {
  Future<GetTransactionStatusModel?> getExchangeRate(
      String? transactionId) async {
    try {
      http.Response response = await http.post(
          Uri.parse(baseUrl + getTransactionStatusEndpoint),
          body: json.encode({"transactionId": transactionId}),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            json.decode(response.body)['data']['transactionStatus'];

        var decodedData = GetTransactionStatusModel.fromJson(data);
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
